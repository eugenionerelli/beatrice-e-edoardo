#!/usr/bin/env python3
"""
Server locale per l'editor GrapesJS. Solo libreria standard, nessuna
dipendenza oltre a Python 3.

Serve i file statici (il sito vero + gli asset dell'editor) e gestisce
POST /save per scrivere le modifiche fatte nel canvas.

Uso:
    python3 editor/server.py [porta]      (default: 8767)

Non pubblica nulla da solo: scrive solo su disco. `git push` resta un
passo separato e deliberato — vedi scripts/publish.sh.
"""

import http.server
import json
import re
import sys
from pathlib import Path

RADICE = Path(__file__).resolve().parent.parent
PORTA = int(sys.argv[1]) if len(sys.argv) > 1 else 8767

# Se uno di questi sparisce dall'HTML salvato, main.js smette di funzionare
# in silenzio: il countdown si ferma, l'RSVP non invia, la galleria non si
# apre. Un controllo a stringa è sufficiente per un avviso — non serve un
# parser HTML vero per questo scopo.
ID_RICHIESTI = [
    "cd-giorni", "cd-ore", "cd-minuti", "cd-secondi",
    "countdown", "lightbox", "rsvp-form", "rsvp-nota",
]
CLASSI_RICHIESTE = ["reveal", "galleria-griglia"]
CAMPI_RICHIESTI = ["nome", "cognome", "presenza", "ospiti", "nomi-ospiti", "messaggio"]


def trova_mancanti(html):
    mancanti = []
    for id_ in ID_RICHIESTI:
        if f'id="{id_}"' not in html:
            mancanti.append(f'id="{id_}"')
    for classe in CLASSI_RICHIESTE:
        if not re.search(rf'class="[^"]*\b{re.escape(classe)}\b[^"]*"', html):
            mancanti.append(f'class="{classe}"')
    for campo in CAMPI_RICHIESTI:
        if f'name="{campo}"' not in html:
            mancanti.append(f'name="{campo}"')
    return mancanti


class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=str(RADICE), **kwargs)

    def log_message(self, formato, *args):
        sys.stderr.write(f"[editor] {self.address_string()} — {formato % args}\n")

    def do_POST(self):
        if self.path != "/save":
            self.send_error(404, "Solo /save accetta POST")
            return

        lunghezza = int(self.headers.get("Content-Length", 0))
        if lunghezza == 0 or lunghezza > 10_000_000:
            self._json(400, {"errore": "corpo della richiesta mancante o troppo grande"})
            return

        try:
            dati = json.loads(self.rfile.read(lunghezza))
            html_nuovo = dati["html"]
            css_nuovo = dati["css"]
        except (json.JSONDecodeError, KeyError) as e:
            self._json(400, {"errore": f"JSON non valido: {e}"})
            return

        try:
            avvisi = self._scrivi(html_nuovo, css_nuovo)
        except Exception as e:
            self._json(500, {"errore": str(e)})
            return

        self._json(200, {"ok": True, "avvisi": avvisi})

    def _scrivi(self, html_nuovo, css_nuovo):
        index_path = RADICE / "index.html"
        attuale = index_path.read_text(encoding="utf-8")

        if "<body>" not in attuale or "</body>" not in attuale:
            raise ValueError("index.html non ha <body>/</body>: struttura inattesa, non scrivo nulla")

        testa, _, resto = attuale.partition("<body>")
        _, _, coda = resto.rpartition("</body>")

        # editor.getHtml() di GrapesJS include il proprio tag <body> (il
        # componente radice), quindi va tolto prima di reinserire il nostro:
        # altrimenti si finisce con un <body> annidato dentro l'altro.
        corpo_pulito = html_nuovo.strip()
        corpo_pulito = re.sub(r"^<body[^>]*>", "", corpo_pulito, count=1, flags=re.I)
        corpo_pulito = re.sub(r"</body>\s*$", "", corpo_pulito, count=1, flags=re.I).strip()

        # Il tag <script> resta fisso: l'editor gestisce struttura e stile,
        # non il comportamento interattivo scritto a mano in js/main.js.
        nuovo_contenuto = (
            f"{testa}<body>\n"
            f"{corpo_pulito}\n"
            f'  <script src="js/main.js"></script>\n'
            f"</body>{coda}"
        )

        index_path.write_text(nuovo_contenuto, encoding="utf-8")

        # Livello separato, mai sovrascrive style.css: se l'export di
        # GrapesJS non portasse con sé un dettaglio avanzato (animazioni,
        # media query, texture), il sito non perde comunque l'originale.
        edited_path = RADICE / "css" / "edited.css"
        intestazione = (
            "/* Generato dall'editor locale (GrapesJS) — non modificare a mano.\n"
            "   Si sovrappone a style.css: quest'ultimo resta la base. */\n\n"
        )
        edited_path.write_text(intestazione + css_nuovo, encoding="utf-8")

        return trova_mancanti(corpo_pulito)

    def _json(self, codice, corpo):
        payload = json.dumps(corpo).encode("utf-8")
        self.send_response(codice)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(payload)))
        self.end_headers()
        self.wfile.write(payload)


if __name__ == "__main__":
    server = http.server.ThreadingHTTPServer(("127.0.0.1", PORTA), Handler)
    print(f"Editor su http://127.0.0.1:{PORTA}/editor/  (radice progetto: {RADICE})")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
