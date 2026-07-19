# Progettare in Webstudio, pubblicare su Pages

Il tuo giro di lavoro: disegni nel canvas di Webstudio, esporti, uno script mette
l'export in produzione, il push pubblica.

```
   Webstudio            questo repo              GitHub Pages
   ┌────────┐   .zip    ┌──────────────┐  push   ┌──────────┐
   │ canvas │ ───────▶  │ importa-….sh │ ──────▶ │  online  │
   └────────┘           └──────────────┘         └──────────┘
        ▲                      │
        └── design/spec.html ──┘   (i valori da riprodurre)
```

---

## Prima di cominciare: cosa aspettarti

**Webstudio non importa il sito esistente.** Il canvas parte da una pagina bianca e
il nostro HTML/CSS non si può caricare dentro. Quindi ricostruisci — ed è anche il
motivo per cui questa cartella esiste: [`spec.html`](spec.html) ha ogni valore da
riprodurre, [`contenuti.md`](contenuti.md) ogni testo da incollare.

Non è un ripiego: significa che il design lo rifai tu, con le tue scelte, avendo
sottomano il punto di partenza invece di una pagina vuota.

**Cosa guadagni** rispetto al sito attuale: canvas visuale, animazioni allo scroll
integrate, e soprattutto la **gestione dei moduli** — le conferme RSVP ti arrivano
senza passare da Formspree o dal client di posta.

**Cosa perdi:** il conto alla rovescia (non è nativo — o blocco di codice
personalizzato, o lo togli) e il controllo fine sul CSS scritto a mano.

---

## 1. Prepara la scheda del design

Apri la scheda in una finestra da tenere accanto all'editor:

```bash
open ~/Siti/beatrice-e-edoardo/design/spec.html
```

Contiene palette (codici selezionabili con un clic), i quattro caratteri con
esempi, la scala tipografica, le spaziature e i dettagli facili da perdere.

I testi sono in [`contenuti.md`](contenuti.md), in ordine di sezione,
con i link Google Maps già pronti.

---

## 2. Costruisci in Webstudio

1. Vai su [webstudio.is](https://webstudio.is) e crea un account (piano gratuito).
2. Nuovo progetto → parti da una pagina vuota.
3. Ricostruisci le sezioni nell'ordine di `contenuti.md`.

**Consigli specifici per questo design:**

- **Carica prima i font.** I quattro (Julius Sans One, Cormorant Garamond, Pinyon
  Script, Karla) sono tutti su Google Fonts, gratuiti. Impostali all'inizio come
  stili globali: rifare i font a fine lavoro è una pena.
- **Il fondo non è bianco.** È avorio `#F6F4EF`. È metà dell'effetto.
- **Non comprimere gli spazi.** Le sezioni hanno `5.5rem` di respiro verticale.
  Nel canvas sembrerà troppo — non lo è: è ciò che rende il sito elegante invece
  che affollato.
- **La spaziatura fra le lettere è il carattere del design.** Fino a `0.45em` sulla
  data. Se Webstudio la chiama *letter spacing*, è quella.
- **Controlla il mobile mentre lavori**, non alla fine: la maggior parte degli
  invitati aprirà il link dal telefono. Due punti già risolti nel sito attuale che
  ti conviene replicare: il countdown va in griglia 2×2, e i nomi si impilano su
  tre righe con la `&` al centro (altrimenti resta orfana a fine riga).
- **Testo alternativo su ogni foto**: lo leggono i lettori di schermo.

---

## 3. Esporta

Nel builder: **Publish → Export → Build and download static site**.

Aspetta fino a un minuto: scarica uno `.zip` in `~/Downloads`.

> ⚠️ Deve essere **static site**, non l'export come applicazione JavaScript.
> Pages serve solo file statici. Se sbagli, lo script se ne accorge e ti ferma.

---

## 4. Metti in produzione

```bash
cd ~/Siti/beatrice-e-edoardo
./scripts/importa-webstudio.sh
```

Senza argomenti prende lo zip più recente in `~/Downloads`; puoi anche indicarlo:
`./scripts/importa-webstudio.sh ~/Downloads/export.zip`

Lo script:

1. **Si ferma se hai modifiche non salvate** — così git resta la tua rete di sicurezza.
2. **Verifica che lo zip sia un sito statico** (deve contenere `index.html`).
3. **Ti mostra cosa rimuove e cosa conserva**, e chiede conferma.
4. Sostituisce il sito, conservando `README.md`, `design/`, `scripts/`, `.gitignore`.
5. Crea `.nojekyll` — senza, GitHub cancella le cartelle che iniziano con `_`
   (Webstudio ne genera spesso, tipo `_astro/`) e il sito resta senza stili.
6. **Non fa commit né push**: prima guardi, poi decidi.

Guarda il risultato in locale:

```bash
python3 -m http.server 8000     # → http://localhost:8000
```

Se convince:

```bash
git add . && git commit -m "Nuovo design da Webstudio" && git push
```

Un minuto e sei online su
<https://eugenionerelli.github.io/beatrice-e-edoardo/>.

Se non convince, torni indietro senza lasciare traccia:

```bash
git checkout . && git clean -fd
```

---

## Il sito attuale resta come riferimento

Fino al primo import, quello online è il sito scritto a mano. Anche dopo, resta
nella cronologia git: per rivederlo o recuperarne un pezzo,

```bash
git log --oneline                      # trova il commit
git show cc3da28:css/style.css         # guarda un file di allora
git checkout cc3da28 -- css/style.css  # recuperalo
```

Il commit `cc3da28` è il design originale completo.

---

## Se Webstudio non ti convince

Nessun problema: i file di questo repo sono e restano HTML/CSS normali, e
l'hosting non cambia. Le alternative valutate:

- **Pinegrow** — app desktop che apre *direttamente* `index.html` e `css/style.css`
  e ti dà un canvas visuale sui file veri, senza ricostruire niente. Prova
  gratuita, poi ~50 €/anno o licenza perpetua. È la scelta migliore se ti pesa
  ripartire da zero.
- **Modificare il CSS a mano** — tutti i valori sono in cima a `css/style.css`
  in `:root`, con commenti. Cambiare palette e font è questione di poche righe.
- **Framer** — da escludere: non esporta HTML, il suo modello è l'hosting proprio.
  I tool che "esportano da Framer" fanno scraping del sito già pubblicato, quindi
  dovresti comunque pagare l'abbonamento.
