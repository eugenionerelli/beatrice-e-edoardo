# Piano di ricostruzione via MCP — pronto da eseguire

Risposta operativa a: *"non puoi usare l'MCP per ricostruire il sito intero in
Webstudio?"* — sì, ed ecco esattamente come, con la sintassi vera verificata
nel manuale ufficiale del CLI (`webstudio man project-editing --verbose`,
controllato il 19 luglio 2026 su `webstudio@0.280.1`).

## Perché non l'ho già fatto

Serve un progetto Webstudio collegato — cioè un account e uno *share link* —
prima che l'MCP abbia qualcosa su cui operare. Creare l'account è l'unico
passo che non posso fare al posto tuo (è una policy che mi vincola: non creo
account o inserisco password per conto tuo). Appena esiste il link, però,
tutto il resto sotto è meccanico.

```bash
./scripts/setup-webstudio.sh          # incolli il link, collega tutto
```

Da lì posso guidare l'agente (io stesso, in una sessione con l'MCP attivo) a
eseguire esattamente i passi di questo documento.

## La sintassi reale

Ogni sezione del sito si crea con lo strumento MCP `insert-fragment`, che
accetta JSX nel dialetto di Webstudio: `ws.element` con `ws:tag` per il tag
HTML e `ws:style={css\`...\`}` per il CSS vero e proprio (letterale, non un
sistema proprietario a parte). Esempio dal manuale ufficiale:

```
insert-fragment {"parentInstanceId":"parent-id","fragment":"<ws.element ws:tag=\"section\" ws:style={css`padding: 32px; display: grid; gap: 12px;`}><ws.element ws:tag=\"h2\">Titolo</ws.element></ws.element>"}
```

Questo significa che tradurre il nostro `index.html` + `style.css` è un lavoro
quasi meccanico: ogni tag HTML diventa un `ws.element` con lo stesso `ws:tag`
e le stesse regole CSS incollate dentro `css\`...\``.

**Non verificato ancora:** se il sistema di variabili CSS (`var(--carta)`)
funziona dentro `ws:style`, o se va tradotto nel sistema di token propri di
Webstudio. Nei frammenti sotto uso valori letterali per sicurezza. Prima cosa
da fare a progetto collegato: provare un frammento con `var()` e uno con
valore letterale, con `--dry-run`, e vedere quale rende meglio nel canvas.

## Due frammenti pronti, da validare con `--dry-run`

Scritti secondo la sintassi del manuale ma **mai eseguiti contro un progetto
vero** — la prima esecuzione va sempre con `--dry-run`:

```bash
webstudio insert-fragment '{"parentInstanceId":"<id-pagina>","fragment":"..."}' --dry-run
```

### 1 — Copertina (nomi + data)

```
<ws.element ws:tag="header" ws:style={css`
    min-height: 100svh; display: flex; flex-direction: column;
    align-items: center; justify-content: space-between;
    text-align: center; padding: 3rem 1rem 4.5rem;
    background-color: #F6F4EF; color: #171716;
    font-family: 'Cormorant Garamond', serif;
  `}>
  <ws.element ws:tag="div" ws:style={css`
      font-family: 'Julius Sans One', sans-serif; font-size: 2.6rem; line-height: 1;
    `}>BE</ws.element>
  <ws.element ws:tag="h1" ws:style={css`
      margin: 0; font-family: 'Julius Sans One', sans-serif; font-weight: 400;
      font-size: clamp(2.1rem, 7.5vw, 5.2rem); letter-spacing: 0.06em;
      text-transform: uppercase; line-height: 1.15;
    `}>Beatrice &amp; Edoardo</ws.element>
  <ws.element ws:tag="p" ws:style={css`
      margin: 1.6rem 0 0; font-weight: 300;
      font-size: clamp(1.15rem, 2.6vw, 1.6rem); letter-spacing: 0.45em;
    `}>12 . 06 . 2027</ws.element>
</ws.element>
```

### 2 — Un evento del programma

```
<ws.element ws:tag="article" ws:style={css`max-width: 34rem; margin: 0 auto; text-align: center;`}>
  <ws.element ws:tag="p" ws:style={css`
      font-family: 'Cormorant Garamond', serif; font-weight: 300;
      font-size: clamp(2.2rem, 5vw, 3rem); letter-spacing: 0.12em; margin: 0 0 0.6rem;
    `}>16:00</ws.element>
  <ws.element ws:tag="h3" ws:style={css`
      font-family: 'Julius Sans One', sans-serif; text-transform: uppercase;
      font-size: clamp(1.05rem, 2.4vw, 1.35rem); letter-spacing: 0.28em; margin: 0 0 1.1rem;
    `}>Cerimonia</ws.element>
  <ws.element ws:tag="p" ws:style={css`
      font-family: Karla, sans-serif; font-weight: 500; text-transform: uppercase;
      letter-spacing: 0.22em; font-size: 0.85rem; margin: 0 0 0.2rem;
    `}>Chiesa di San Giorgio</ws.element>
  <ws.element ws:tag="a" ws:style={css`
      display: inline-block; font-family: Karla, sans-serif; font-size: 0.7rem;
      letter-spacing: 0.32em; text-transform: uppercase; text-decoration: none;
      color: #171716; border: 1px solid #171716; padding: 0.85em 1.8em;
    `}>Mostra la posizione</ws.element>
</ws.element>
```

## Il resto delle sezioni

Stesso procedimento per storia, countdown, galleria, RSVP, citazione, footer —
i valori sono tutti in [`spec.html`](spec.html) e [`contenuti.md`](contenuti.md).
Non li scrivo tutti qui perché senza un progetto vero contro cui validarli
sarebbe lavoro rifatto due volte: meglio farlo dal vivo, sezione per sezione,
con lo strumento di verifica visiva del CLI (`preview.start` → `screenshot` →
confronto) che conferma subito se il frammento rende come deve, invece di
scrivere alla cieca altre 200 righe che potrebbero avere un dettaglio di
sintassi sbagliato.

Il countdown JavaScript (`js/main.js`, funzione `aggiornaCountdown`) non ha
equivalente nativo in Webstudio: o un blocco di codice personalizzato, o si
toglie — già segnalato in [`WEBSTUDIO.md`](WEBSTUDIO.md).

## Portarlo nell'account della tua amica

Confermato nel CLI (`webstudio import --help`): un progetto sincronizzato
localmente si può importare in **un altro progetto**, indicando come
destinazione uno share link con permesso *Build* — che può appartenere a un
account diverso dal tuo:

```bash
webstudio sync                              # scarica il progetto costruito
webstudio import --to "<share-link-di-lei>" # lo spinge nel SUO progetto
```

Lei deve solo: creare un account Webstudio (gratuito), un progetto vuoto, e
uno share link con permesso **Build** (confermato gratuito, vedi
[STACK.md](STACK.md#quanto-costa-davvero)) da mandarti. Non serve altro da
parte sua finché non vuole modificarlo di persona nel canvas.

## Cosa manca per partire davvero

Un solo prerequisito, che solo tu puoi fare:

```bash
./scripts/setup-webstudio.sh
```

Appena il link è collegato e riavvii Claude Code, dimmi di procedere e comincio
dalla copertina, verificando ogni sezione con screenshot prima di passare alla
successiva.
