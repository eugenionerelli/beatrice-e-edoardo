# Editor locale (GrapesJS) — come funziona e i suoi limiti reali

Un editor visuale che gira **su questa macchina**: nessun account, nessuna
nuvola, nessun MCP necessario — è una libreria locale (npm), non un servizio
cloud come Webstudio.

## Avviarlo

```bash
python3 editor/server.py
```

Poi apri **http://127.0.0.1:8767/editor/** — o dal launch.json del progetto,
configurazione `editor-locale`.

Carica il sito **vero** (non una copia): legge `../index.html` e
`../css/style.css` al volo ogni volta che apri la pagina.

## Salvare

Il bottone "Salva nel progetto" scrive su disco:

- `index.html` — sostituisce il contenuto del `<body>` con quello del canvas,
  **conservando** intestazione (`<head>`, meta tag, font) e il tag
  `<script src="js/main.js">` esattamente come sono ora.
- `css/edited.css` — un foglio di stile **separato**, che si sovrappone a
  `style.css` senza mai sostituirlo (vedi il perché sotto).

**Non pubblica nulla.** Scrive solo i file locali. Per mandarli online resta
un passo deliberato: `git add . && git commit -m "..." && git push` (o
`./scripts/publish.sh "messaggio"`).

## Un limite reale di GrapesJS, verificato

Testando il salvataggio (19 luglio 2026, `grapesjs@0.22.16`), ho trovato che
**GrapesJS non analizza correttamente le proprietà scritte in forma compatta
`background: colore` e `border: spessore stile colore`** — le toglie
silenziosamente quando importa un foglio di stile esistente. Le forme
estese (`background-color`, `border-color`, `border-width`, `border-style`)
funzionano senza problemi.

Nel nostro `style.css` questo riguarda **7 regole**:

| Selettore | Proprietà in forma compatta |
|---|---|
| `.scroll-hint span` | `background` |
| `.btn-luogo` | `border` |
| `.separatore` | `background` |
| `.chip span` | `border` |
| `.chip input:checked + span` | `background`, `border` |
| `.btn-conferma` | `background`, `border` |
| `.footer` | `border-top` |

**Perché non si vede nulla di rotto oggi:** `css/edited.css` si sovrappone a
`style.css` invece di sostituirlo — è per questo che il salvataggio scrive un
file separato invece di riscrivere `style.css` direttamente. Per quelle 7
regole, `edited.css` semplicemente non dice nulla sulle proprietà perse, e la
dichiarazione originale in `style.css` resta valida e visibile: bordi e
sfondi restano al loro posto.

**Cosa può succedere in pratica:** se apri uno di questi elementi nel
pannello Stile e provi a cambiargli **il colore di sfondo o del bordo**, la
modifica potrebbe non sopravvivere al salvataggio — vedrai il cambiamento nel
canvas, ma dopo "Salva" e un ricaricamento potrebbe tornare quello originale,
perché l'esportazione non ha catturato la nuova proprietà.

**Se ti succede:** non è un errore tuo. Dimmelo (o scrivi direttamente in
`css/edited.css` la regola con `background-color:`/`border-color:` invece
che con la forma compatta — quella forma funziona sempre).

## Rete di sicurezza automatica

Ogni salvataggio controlla che gli id/classi/campi da cui dipende
`js/main.js` siano ancora presenti (countdown, RSVP, lightbox, galleria). Se
manca qualcosa, lo stato in alto nell'editor lo segnala in giallo — un avviso,
non un blocco: il salvataggio avviene comunque, così non perdi il lavoro
mentre decidi come sistemare.
