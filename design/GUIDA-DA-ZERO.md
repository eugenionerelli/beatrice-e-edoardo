# Il tuo sito-invito di nozze, da zero

Guida completa per costruire un sito d'invito come questo: bello, tuo, e che
costa **zero di hosting per sempre**.

Non serve saper programmare. Serve un pomeriggio, e la voglia di provare.

> Questa guida presuppone zero conoscenze tecniche. Se un passaggio ti sembra
> ovvio, saltalo pure.

---

## Cosa otterrai

Un sito con un indirizzo tuo — `https://tuonome.github.io/nozze/` o
`https://nomeenome.pages.dev` — da mandare su WhatsApp agli invitati. Dentro:
i vostri nomi, la vostra storia, il programma della giornata con i bottoni che
aprono Google Maps, la galleria di foto e il modulo per confermare la presenza.

**Costo:** 0 € per l'hosting, sempre. Un dominio tuo (`nomeenome.it`) è
opzionale, ~10–15 €/anno.

---

## Le tre scelte da fare prima

### 1. Chi disegna il sito?

| | Come funziona | Per chi |
|---|---|---|
| **Webstudio** | Trascini gli elementi in un canvas, come in Canva ma per siti | Vuoi vedere quello che fai |
| **Un'IA che scrive il codice** | Descrivi a parole, lei costruisce | Sai spiegarti bene e ti fidi |
| **Tutti e due** | Disegni nel canvas, chiedi all'IA le cose noiose | La via più veloce, consigliata |

### 2. Dove lo metti online?

**GitHub Pages** e **Cloudflare Pages** sono entrambi gratuiti per sempre.

- **GitHub Pages** — indirizzo `tuonome.github.io/nozze`. Il progetto deve
  essere pubblico (chiunque può leggere il codice, non è un problema).
- **Cloudflare Pages** — indirizzo `nomeenome.pages.dev`, **più bello**, e
  funziona anche con progetto privato.

*Consiglio:* Cloudflare, per l'indirizzo più elegante.

### 3. Ti serve un abbonamento IA?

Solo se scegli di farti aiutare da un'IA. Prezzi verificati a **luglio 2026** —
controllali, cambiano spesso.

| | Costo | Cosa ti dà |
|---|---|---|
| **Claude Pro** | ~20 $/mese | Claude Code incluso. Sufficiente per questo progetto. |
| **ChatGPT Plus** (Codex) | ~20 $/mese | Codex incluso. Equivalente. |
| Piani superiori | 100–200 $/mese | **Non ti servono.** Sono per chi programma tutto il giorno. |

Un solo mese basta per finire il sito. Poi disdici.

> Se non vuoi spendere: fai tutto in Webstudio a mano. È completamente gratuito
> e funziona benissimo — l'IA fa risparmiare tempo, non è indispensabile.

**Fonti:** [prezzi Claude](https://claude.com/pricing) ·
[prezzi Codex](https://developers.openai.com/codex/pricing)

---

## Parte 1 — Gli account (20 minuti)

Tutti gratuiti. Servono un'email e una password ciascuno.

1. **GitHub** → [github.com/signup](https://github.com/signup)
   È il "cassetto" dove vive il sito. Segnati il nome utente: finisce
   nell'indirizzo.

2. **Webstudio** → [webstudio.is](https://webstudio.is)
   Il programma per disegnare.

3. **Cloudflare** *(se hai scelto lui)* → [dash.cloudflare.com/sign-up](https://dash.cloudflare.com/sign-up)

4. **Claude o ChatGPT** *(solo se vuoi l'aiuto dell'IA)* — abbonamento a pagamento.

> Attiva l'**autenticazione a due fattori** almeno su GitHub. Ci metti due minuti
> e ti eviti guai.

---

## Parte 2 — Preparare il computer (15 minuti)

Serve solo se userai l'IA o i comandi da terminale. **Se disegni solo in
Webstudio e pubblichi trascinando la cartella, salta alla Parte 3.**

Il *Terminale* è l'app dove si scrivono comandi. Su Mac: `Cmd + Spazio`, scrivi
"Terminale", Invio. Fa impressione, ma qui copi e incolli: niente di più.

### Node.js

Il motore che fa girare gli strumenti. Verifica se c'è già:

```bash
node --version
```

Se risponde `v20` o più, sei a posto. Se dice "command not found",
scaricalo da [nodejs.org](https://nodejs.org) (versione **LTS**) e installa.

### Git

Tiene la storia delle modifiche e manda il sito su GitHub.

```bash
git --version
```

Se manca, il Mac ti propone di installarlo: accetta. Poi presentati:

```bash
git config --global user.name "Il Tuo Nome"
git config --global user.email "tua@email.it"
```

### Claude Code *(solo se hai l'abbonamento)*

```bash
npm install -g @anthropic-ai/claude-code
claude
```

Al primo avvio ti chiede di accedere. Per Codex:
`npm install -g @openai/codex`, poi `codex`.

---

## Parte 3 — Disegnare il sito (il grosso del tempo)

1. Su [webstudio.is](https://webstudio.is), **nuovo progetto**, pagina vuota.
2. Costruisci le sezioni. Un ordine che funziona:

   - **Copertina** — nomi grandi, data, nient'altro. Il vuoto qui è eleganza.
   - **La vostra storia** — due paragrafi, non di più.
   - **Il programma** — per ogni momento: orario, luogo, indirizzo, bottone Maps.
   - **Galleria** — sei foto bastano.
   - **Conferma di presenza** — nome, presenza sì/no, numero di accompagnatori.
   - **Chiusura** — una frase che vi piace.

### I bottoni per Google Maps

Il pezzo che gli invitati useranno di più. Cerca il posto su
[maps.google.com](https://maps.google.com) → **Condividi** → **Copia link**, e
incollalo nel bottone. Oppure usa questo formato, che non scade mai:

```
https://www.google.com/maps/search/?api=1&query=Nome+Locale+Città
```

(gli spazi diventano `+`)

Imposta i bottoni per aprirsi in una **nuova scheda**, così chi clicca non perde
l'invito.

### Cinque consigli che fanno la differenza

1. **Il fondo non sia bianco puro.** Un avorio caldo (`#F6F4EF`) sembra carta;
   il bianco sembra un documento.
2. **Lascia molto spazio vuoto.** Nel canvas sembrerà troppo. Non lo è: è ciò
   che distingue un invito elegante da una pagina affollata.
3. **Massimo due caratteri**, tre se sai il fatto tuo. Su
   [Google Fonts](https://fonts.google.com) sono tutti gratuiti.
4. **Controlla il telefono mentre lavori**, non alla fine: quasi tutti apriranno
   il link dal cellulare.
5. **Scrivi il testo alternativo sulle foto** — lo leggono i non vedenti.

### Se ti fai aiutare dall'IA

Webstudio ha un collegamento ufficiale per Claude Code e Codex. Dalla cartella
del progetto:

```bash
npx webstudio init --link "<share-link>" --template ssg
npx webstudio sync
npx webstudio connect claude      # oppure: codex
```

Il *share link* si prende dal progetto Webstudio: **Share** → nuovo link con
permesso **Build** → **spunta l'accesso via API**. Senza quella spunta non
funziona niente: è l'errore più comune.

Riavvia Claude Code e potrai chiedere: *«cambia la palette in verde salvia»*,
*«fammi vedere come viene su iPhone»*.

> ⚠️ Quel link è **come una password**: chi ce l'ha può modificare il sito. Non
> metterlo mai in un file che finisce su GitHub, non mandarlo su WhatsApp.

---

## Parte 4 — Mandarlo online (15 minuti)

### Esporta

Webstudio: **Publish** → **Export** → **Build and download static site**.
Scarichi uno `.zip`. Deve essere *static site*, non l'app JavaScript: i siti
gratuiti servono solo file statici.

Scompatta lo zip: dentro c'è un `index.html` e alcune cartelle.

### Opzione A — Cloudflare Pages (la più semplice)

Non serve nessun comando.

1. [dash.cloudflare.com](https://dash.cloudflare.com) → **Workers & Pages**
2. **Create** → scheda **Pages** → **Upload assets**
3. Nome progetto: quello che vuoi nell'indirizzo (es. `annaemarco`)
4. **Trascina dentro la cartella** scompattata
5. Fatto: sei su `https://annaemarco.pages.dev`

Per aggiornare: riesporti e ricarichi dalla stessa pagina.

### Opzione B — GitHub Pages

1. Crea un progetto su [github.com/new](https://github.com/new), nome `nozze`,
   **Public**, senza spuntare nulla.
2. Nel Terminale, dalla cartella del sito:

```bash
git init -b main
git add .
git commit -m "Il nostro invito"
git remote add origin https://github.com/TUONOME/nozze.git
git push -u origin main
```

3. Sul progetto: **Settings** → **Pages** → Source: *Deploy from a branch* →
   Branch `main`, cartella `/ (root)` → **Save**.
4. Dopo un minuto sei su `https://TUONOME.github.io/nozze/`.

Per aggiornare: `git add . && git commit -m "aggiornato" && git push`.

> **Il trucco che salva una serata.** Se il sito appare **senza grafica**, crea
> un file vuoto chiamato `.nojekyll` nella cartella principale e ripubblica.
> GitHub scarta le cartelle che iniziano con `_`, e i costruttori di siti le
> usano di continuo. Da terminale: `touch .nojekyll`

---

## Parte 5 — Prima di mandarlo agli invitati

- [ ] Aperto **dal telefono**, non solo dal computer
- [ ] Tutti e tre i bottoni Maps portano al posto giusto
- [ ] Il modulo di conferma **ti recapita davvero** una risposta di prova
- [ ] Nomi, date e orari controllati due volte (il refuso sulla data è il classico)
- [ ] Link mandato a un amico che non c'entra niente, per vedere se si capisce
- [ ] Nessun indirizzo di casa o numero privato: **chiunque abbia il link entra**
- [ ] Sito nascosto ai motori di ricerca (in Webstudio: *noindex* fra le
      impostazioni della pagina)

---

## Un dominio tutto vostro (facoltativo)

`annaemarco.it` costa ~10–15 €/anno da [registrar
Cloudflare](https://domains.cloudflare.com) o simili, e si collega gratis a
entrambe le piattaforme (su Cloudflare: progetto → *Custom domains*).

> I domini "gratuiti" tipo `.tk` non sono più un'opzione seria: Freenom ha chiuso
> le registrazioni. O il sottodominio gratuito, o un dominio a pagamento.

---

## Se ti blocchi

| Problema | Soluzione |
|---|---|
| Sito senza grafica | Manca `.nojekyll` (vedi sopra) |
| "Permission denied" con git | Nome utente sbagliato nell'indirizzo, o serve il token al posto della password |
| L'IA non vede Webstudio | Manca l'accesso API sul link, oppure non hai riavviato |
| Pagina bianca | Il file principale deve chiamarsi esattamente `index.html` |
| Modifiche non visibili | Aspetta un minuto, poi ricarica con `Cmd + Shift + R` |

E se proprio non ne esci: chiedi all'IA incollando **il messaggio d'errore
esatto**. È lì che sono più utili.

---

## Il consiglio finale

Fai la versione brutta **prima**. Nomi, data, luogo, un bottone Maps: online in
un'ora. Poi la rendi bella con calma.

Il contrario — passare tre settimane a scegliere il carattere perfetto e non
pubblicare mai — è il modo più comune di non avere un sito d'invito.

Buone nozze. 🥂
