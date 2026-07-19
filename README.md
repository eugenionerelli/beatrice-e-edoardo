# Invito di nozze — sito statico (demo)

Un sito-invito one-page in stile "black tie": copertina con monogramma e nomi,
racconto, conto alla rovescia, programma della giornata con link a Google Maps,
galleria fotografica, modulo RSVP e citazione finale.

**È tutto statico**: niente database, niente server, niente build. Tre file da
modificare con un editor di testo, perfetto per GitHub Pages o Cloudflare Pages
(entrambi gratuiti).

> Demo con nomi di fantasia (Beatrice & Edoardo) e foto Unsplash a licenza
> libera. Tutto è pensato per essere sostituito con i contenuti veri.

---

## Struttura

```
beatrice-e-edoardo/
├── index.html      → tutti i contenuti (nomi, testi, orari, luoghi, foto)
├── css/style.css   → colori, font, spaziature (design)
├── js/main.js      → conto alla rovescia, animazioni, modulo RSVP
├── assets/img/     → (vuota) qui metterai le tue foto
├── design/
│   ├── STACK.md               → lo stack completo: Webstudio + MCP + Pages
│   ├── WEBSTUDIO.md           → dal canvas alla pubblicazione (senza CLI)
│   ├── webstudio-rebuild-plan.md → ricostruzione via MCP: sintassi reale, pronta da eseguire
│   ├── spec.html              → scheda visiva: palette, font, scala, spaziature
│   ├── contenuti.md           → tutti i testi e i link Maps da incollare
│   └── GUIDA-DA-ZERO.md       → guida per chi parte da capo, senza basi tecniche (italiano)
├── for-a-friend/
│   └── START-HERE.md  → la stessa guida da zero, in inglese, autonoma — per chi non parla italiano
└── scripts/
    ├── setup-webstudio.sh    → collega il progetto e configura l'MCP (una volta)
    ├── build-e-pubblica.sh   → compila con il CLI e manda online
    └── importa-webstudio.sh  → porta in produzione uno zip o una cartella
```

## Ridisegnare il sito

Il design si rifà in **[Webstudio](https://webstudio.is)** (open source, gratuito,
esporta statico). Due modi, intercambiabili:

**Con l'automazione** — Webstudio ha un MCP ufficiale nel suo CLI, quindi Claude
Code può modificare il design a comando. Preparazione in un colpo:

```bash
./scripts/setup-webstudio.sh          # chiede il share link, fa il resto
./scripts/build-e-pubblica.sh         # compila; --pubblica per mandare online
```

Dettagli in **[design/STACK.md](design/STACK.md)**.

**A mano** — disegni nel canvas, esporti lo zip, e

```bash
./scripts/importa-webstudio.sh
```

Dettagli in **[design/WEBSTUDIO.md](design/WEBSTUDIO.md)**. Tieni aperta
`design/spec.html` accanto all'editor: ha tutti i valori da riprodurre.

Per far costruire il design direttamente a me (o a un altro agente) via MCP,
sezione per sezione con verifica visiva: **[design/webstudio-rebuild-plan.md](design/webstudio-rebuild-plan.md)**.

## Per chi non parla italiano

`for-a-friend/START-HERE.md` è la stessa guida da zero
([GUIDA-DA-ZERO.md](design/GUIDA-DA-ZERO.md)), riscritta in inglese e resa
autonoma — non presuppone questo repo, usa nomi generici, e include il
percorso "qualcuno ha già costruito il sito e te lo passa" via
`webstudio import --to`. Pensata per essere copiata così com'è e mandata a chi
ne ha bisogno.

**Online su** <https://eugenionerelli.github.io/beatrice-e-edoardo/>

## Anteprima sul tuo Mac

Doppio click su `index.html` e si apre nel browser: per un sito così basta.
Se preferisci un vero server locale:

```bash
cd wedding-invite-demo
python3 -m http.server 8000
# poi apri http://localhost:8000
```

---

## Personalizzare

Cerca i commenti **`PERSONALIZZA`** dentro `index.html` e `js/main.js`:
segnano ogni punto da cambiare.

### Nomi, data, testi
Tutti in `index.html`: titolo della pagina (`<title>` e i meta `og:` per
l'anteprima su WhatsApp), monogramma, nomi nella copertina, racconto,
programma, citazione, footer.

La data del **conto alla rovescia** è in `js/main.js`
(`DATA_MATRIMONIO`).

### Link Google Maps
Ogni evento del programma ha un bottone "Mostra la posizione". Due modi per
ottenere il link:

1. **Il più semplice** — cerca il luogo su [maps.google.com](https://maps.google.com),
   premi *Condividi* → *Copia link* e incollalo nell'`href` del bottone.
2. **A mano** — funziona sempre questo formato:
   `https://www.google.com/maps/search/?api=1&query=Nome+Luogo+Città`
   (spazi sostituiti da `+`).

### Foto
Le sei foto della galleria sono link a Unsplash (segnaposto). Per usare le
vostre: copia i file in `assets/img/` e in `index.html` sostituisci gli URL,
ad esempio `src="assets/img/proposta.jpg"`. Consiglio: esportale larghe
~1600 px e sotto i 500 KB l'una (su Mac: apri con Anteprima → Strumenti →
Regola dimensione), così il sito resta veloce.

### Modulo RSVP
Il sito è statico, quindi di default il modulo **apre il programma di posta**
dell'ospite con l'email di conferma già scritta (indirizzo in `js/main.js`,
`EMAIL_SPOSI`). Funziona ovunque, ma richiede all'ospite un passaggio in più.

Alternative gratuite per ricevere le risposte in automatico:

- **[Formspree](https://formspree.io)** (50 invii/mese gratis): crei un form,
  ti danno un URL tipo `https://formspree.io/f/abcd1234`; in `index.html`
  aggiungi al `<form>` gli attributi `action="quell'URL"` e `method="POST"`,
  e in `js/main.js` elimini il blocco RSVP in fondo. Le risposte ti arrivano
  via email.
- **Google Form / [Tally](https://tally.so)**: crei il modulo lì e nel sito
  metti solo un bottone che ci porta (o lo incorpori con un `<iframe>`).
  Zero codice, risposte in un foglio di calcolo.

### Colori e font
In cima a `css/style.css` (`:root`) trovi palette e font. I font arrivano da
[Google Fonts](https://fonts.google.com) (gratuiti): per cambiarli scegli i
nuovi sul sito, sostituisci il `<link>` in `index.html` e i nomi in
`style.css`.

### Privacy
- `index.html` contiene `<meta name="robots" content="noindex">`: il sito non
  comparirà su Google. Toglila solo se vuoi il contrario.
- Ricorda comunque che **il sito è pubblico** per chiunque abbia il link:
  valuta cosa scrivere (es. indirizzi di casa no).

---

# Pubblicazione

## Stato attuale ✅

Il sito è **online su GitHub Pages**:

**<https://eugenionerelli.github.io/beatrice-e-edoardo/>**

- Repository: <https://github.com/eugenionerelli/beatrice-e-edoardo> (pubblico)
- Sorgente: branch `main`, cartella radice `/`
- **Ogni `git push` aggiorna il sito da solo**, in circa un minuto.

Il flusso di lavoro quotidiano è quindi:

```bash
cd ~/Siti/beatrice-e-edoardo
# ...modifichi i file...
git add . && git commit -m "Aggiornato il programma" && git push
```

> ⚠️ **Attenzione a Google Drive.** La copia originale in
> `Il mio Drive/wedding-invite-demo/` è rimasta lì come bozza, ma **il
> repository vive in `~/Siti/beatrice-e-edoardo`**: Drive sincronizza male la
> cartella nascosta `.git` e la corrompe. Lavora sempre nella copia in
> `~/Siti/`, non in quella dentro Drive, altrimenti le due divergono.

> Nota: il repo è **pubblico** perché GitHub Pages gratuito lo richiede —
> chiunque può leggere il codice (non è un problema: sono nomi di fantasia).
> Per un repo **privato** serve un piano a pagamento, oppure Cloudflare Pages,
> che pubblica anche da repo privati senza costi.

## Prossimo passo: l'URL `beatriceandedoardo.pages.dev`

Cloudflare Pages regala un sottodominio nella forma `NOME.pages.dev`. Al
momento del controllo **`beatriceandedoardo` risultava libero** (verifica di
nuovo prima: se `https://beatriceandedoardo.pages.dev` non risponde, è ancora
disponibile).

Il collegamento richiede un login nel browser, quindi va fatto a mano —
sei/sette clic, una volta sola:

1. Vai su [dash.cloudflare.com](https://dash.cloudflare.com) e accedi.
2. **Workers & Pages** → **Create** → scheda **Pages** → **Connect to Git**.
3. Autorizza Cloudflare ad accedere a GitHub e scegli il repo
   **`beatrice-e-edoardo`**.
4. Nella schermata di configurazione, il campo **Project name** è quello che
   determina l'URL: scrivi esattamente **`beatriceandedoardo`**.
5. Impostazioni di build — il sito è statico, quindi vanno lasciate vuote:
   - Framework preset: **None**
   - Build command: **(vuoto)**
   - Build output directory: **`/`**
6. **Save and Deploy**. Dopo ~1 minuto il sito è su
   `https://beatriceandedoardo.pages.dev`, e da lì in poi si aggiorna da solo
   a ogni `git push`, esattamente come GitHub Pages.

I due URL possono convivere: stesso repo, due indirizzi. Se poi vorrai tenerne
uno solo, basta disattivare Pages dalle *Settings* del repo GitHub.

## Più avanti: un dominio vero

`.pages.dev` e `.github.io` sono gratis ma restano sottodomini. Un dominio tuo
(es. `beatriceedoardo.it`, ~10–15 €/anno) si collega gratis a entrambe le
piattaforme — su Cloudflare dal progetto → *Custom domains*. Attenzione: i
domini davvero gratuiti tipo `.tk`/`.ml` non sono più una via praticabile
(Freenom ha chiuso le registrazioni), quindi le opzioni serie sono il
sottodominio gratuito o un dominio a pagamento.

---

## Idee per dopo

- Sezione **lista nozze / IBAN** o link alla lista su Amazon ecc.
- **Aggiungi al calendario**: un link `.ics` scaricabile.
- **Password soft**: pagina d'ingresso con parola segreta sull'invito
  cartaceo (per un invito va bene anche se non è vera sicurezza).
- **Foto degli ospiti**: un link a un album Google Photos condiviso dove
  tutti caricano le foto del giorno stesso.
