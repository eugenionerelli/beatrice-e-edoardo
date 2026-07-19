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
wedding-invite-demo/
├── index.html      → tutti i contenuti (nomi, testi, orari, luoghi, foto)
├── css/style.css   → colori, font, spaziature (design)
├── js/main.js      → conto alla rovescia, animazioni, modulo RSVP
└── assets/img/     → (vuota) qui metterai le tue foto
```

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

## Pubblicare — prima un avvertimento su Google Drive

Questa cartella ora è dentro Google Drive. Per **lavorarci e basta** va
benissimo, ma **prima di usare `git`** conviene copiarla fuori (es. in
`~/Siti/`): Drive sincronizza male la cartella nascosta `.git` e può
corromperla.

```bash
cp -R "wedding-invite-demo" ~/Siti/wedding-invite
cd ~/Siti/wedding-invite
```

(Per Cloudflare Pages con caricamento diretto — opzione B — git non serve
proprio, quindi puoi anche lasciare tutto dov'è.)

## Opzione A — GitHub Pages

1. Crea il repository e carica i file:

   ```bash
   cd ~/Siti/wedding-invite
   git init && git add . && git commit -m "Sito invito"
   gh repo create wedding-invite --public --source=. --push
   ```

   (senza `gh`: crea il repo vuoto su [github.com/new](https://github.com/new),
   poi `git remote add origin https://github.com/TUO-USERNAME/wedding-invite.git`
   e `git push -u origin main`.)

2. Sul repo: **Settings → Pages → Build and deployment** →
   Source: *Deploy from a branch* → Branch: `main`, cartella `/ (root)` → Save.

3. Dopo ~1 minuto il sito è su
   `https://TUO-USERNAME.github.io/wedding-invite/`.

Ogni `git push` successivo aggiorna il sito da solo.

> Nota: con un repo **pubblico** chiunque può vedere anche il codice; se lo
> vuoi **privato**, GitHub Pages sui repo privati richiede un piano a
> pagamento — in quel caso meglio Cloudflare Pages.

## Opzione B — Cloudflare Pages (consigliata: più flessibile)

**B1. Caricamento diretto, senza git** (il modo più veloce in assoluto):

1. [dash.cloudflare.com](https://dash.cloudflare.com) → **Workers & Pages** →
   **Create** → scheda **Pages** → **Upload assets**.
2. Dai un nome al progetto e **trascina dentro la cartella** del sito.
3. Fine: il sito è su `https://NOME-PROGETTO.pages.dev`. Per aggiornarlo,
   ricarichi la cartella dalla stessa pagina.

**B2. Collegato a GitHub** (aggiornamento automatico a ogni push):

1. Prima pubblica il repo su GitHub (passo 1 dell'opzione A — il repo può
   essere anche **privato**, il sito resta visibile lo stesso).
2. **Workers & Pages → Create → Pages → Connect to Git**, autorizza GitHub e
   scegli il repo.
3. Impostazioni di build: framework *None*, comando di build **vuoto**,
   output directory `/`. → **Save and Deploy**.

**Dominio personalizzato** (es. `beatriceedoardo.it`): su entrambe le
piattaforme si può collegare gratis; su Cloudflare è particolarmente comodo
se il dominio lo compri/gestisci lì (progetto → *Custom domains*).

---

## Idee per dopo

- Sezione **lista nozze / IBAN** o link alla lista su Amazon ecc.
- **Aggiungi al calendario**: un link `.ics` scaricabile.
- **Password soft**: pagina d'ingresso con parola segreta sull'invito
  cartaceo (per un invito va bene anche se non è vera sicurezza).
- **Foto degli ospiti**: un link a un album Google Photos condiviso dove
  tutti caricano le foto del giorno stesso.
