# Lo stack

```
   ┌──────────────┐   share link    ┌──────────────┐
   │  Webstudio   │ ──(API)───────▶ │ webstudio    │
   │  Cloud       │ ◀────sync────── │ CLI  (Node)  │
   │  (canvas)    │                 └──────┬───────┘
   └──────────────┘                        │ mcp
          ▲                                ▼
          │ disegni a mano          ┌──────────────┐
          │                         │ Claude Code  │  ← modifica il design
          └─────────────────────────│  (o Codex)   │     a comando
                                    └──────┬───────┘
                                           │ build --template ssg
                                           ▼
                                    ┌──────────────┐   push   ┌───────────┐
                                    │  questo repo │ ───────▶ │ GH Pages  │
                                    └──────────────┘          └───────────┘
```

Due modi di lavorare sullo stesso progetto, intercambiabili:

- **A mano**, nel canvas di Webstudio (browser).
- **A voce**, chiedendo a Claude Code — che pilota Webstudio via MCP.

Le modifiche fatte in un modo si vedono nell'altro: `webstudio sync` allinea.

---

## Sì, l'MCP di Webstudio esiste ed è ufficiale

Non lo trovi cercando "Webstudio MCP" perché **non è un pacchetto a sé** e non è
nel registro MCP: è integrato nel CLI ufficiale (`webstudio mcp`), con un comando
apposta per collegare gli agenti:

```
webstudio connect [claude|codex|cursor|vscode]
```

Verificato il 19 luglio 2026 sul CLI `webstudio@0.280.1`. Su npm circola anche un
`@densrt/webstudio-mcp` che si dichiara **non ufficiale**: non serve, ignoralo.

---

## Preparazione (una volta sola)

### 1. Il progetto su Webstudio

Account gratuito su [webstudio.is](https://webstudio.is), poi crea il progetto.
Serve un **share link con accesso API**:

> Progetto aperto → **Share** → nuovo link con permesso **Build** (o superiore) →
> **spunta l'accesso via API** → copia.

Senza la spunta API il CLI riceve un rifiuto e nulla funziona: è l'errore più
comune di questa configurazione.

### 2. Collega tutto

```bash
cd ~/Siti/beatrice-e-edoardo
./scripts/setup-webstudio.sh          # chiede il link e fa il resto
```

Lo script collega il progetto, lo scarica, mostra cosa permette il token,
configura l'MCP per Claude Code, **verifica che il server MCP risponda davvero**,
e controlla che i file col token siano ignorati da git.

Per Codex invece di Claude Code:

```bash
./scripts/setup-webstudio.sh "<share-link>" codex
```

### 3. Riavvia Claude Code

Perché rilegga `.mcp.json`. Da lì in poi posso operare sul progetto.

---

## Uso quotidiano

### Disegnare parlando

```
«cambia la palette in verde salvia e avorio»
«aggiungi una sezione con le indicazioni per l'hotel»
«fammi vedere come viene su iPhone»
```

Il CLI espone strumenti semantici (`insert-fragment`, `components.search`,
`list-breakpoints`) più un **anello di verifica visiva**: avvia un'anteprima,
cattura screenshot, li confronta con un riferimento e legge il testo con OCR.
Cioè l'agente *vede* il risultato invece di limitarsi a scrivere codice alla cieca.

### Comandi a mano

```bash
npx webstudio sync                    # scarica le modifiche fatte nel canvas
npx webstudio preview                 # anteprima locale
npx webstudio audit                   # accessibilità, SEO, performance
npx webstudio mcp list-tools          # cosa sa fare l'MCP
npx webstudio mcp single-op-call meta.index
```

### Pubblicare

```bash
./scripts/build-e-pubblica.sh              # compila e si ferma: prima guardi
./scripts/build-e-pubblica.sh --pubblica   # compila, commit e push
```

Compila con `--template ssg` (sito statico, l'unico che Pages può servire),
mette il risultato nella radice conservando `README`, `design/`, `scripts/`,
e crea `.nojekyll`.

---

## Quanto costa davvero (verificato il 19 luglio 2026)

Fonti dirette: [webstudio.is/pricing](https://webstudio.is/pricing) e la
documentazione degli [share link](https://docs.webstudio.is/university/foundations/share-links).

| Piano | Prezzo | Include |
|---|---|---|
| **Hobby** | **0 €** | Progetti e pagine illimitati, export statico, **share link con permesso Build** (quello che serve all'MCP) |
| Pro | 15 $/mese (annuale) | Domini personalizzati *su hosting Webstudio*, CMS, storage/form più ampi |
| Team | 35 $/mese (annuale) | Come Pro, per collaborazione in team |

**Il permesso *Build* sui link di condivisione è esplicitamente gratuito** — non
serve Pro per l'automazione via CLI/MCP. Noi non usiamo comunque l'hosting di
Webstudio (pubblichiamo su GitHub/Cloudflare Pages), quindi anche i limiti del
piano gratuito su storage e domini non ci riguardano. **Lo stack Webstudio
costa zero**, indipendentemente dall'IA che eventualmente lo pilota.

## Un'alternativa gratuita a Pinegrow: GrapesJS

Nella scorsa iterazione avevo indicato Pinegrow (~50 €/anno) come unica opzione
per "un canvas visuale sui file HTML/CSS veri, senza ricostruire nulla".
Esiste anche un'alternativa **completamente gratuita e open source**:
[GrapesJS](https://github.com/GrapesJS/grapesjs) (licenza BSD-3, oltre 25.000
stelle su GitHub, versione 0.22 a metà 2026).

A differenza di Webstudio, GrapesJS è progettato apposta per **importare ed
editare HTML/CSS esistenti** — è la sua caratteristica distintiva. Gira
interamente in locale, nessun account richiesto. Il compromesso: è più uno
strumento da sviluppatore che un prodotto "no-code" rifinito come Webstudio o
Pinegrow — richiede un minimo di setup (è una libreria da incorporare in una
pagina, non un'app pronta all'uso). Esiste anche una versione più rifinita a
pagamento (*Studio SDK*, con un livello gratuito), ma il nucleo open source
basta per questo progetto.

Se in futuro il canvas di Webstudio dovesse stare stretto e Pinegrow sembrasse
troppo per un solo sito, GrapesJS è l'opzione da provare prima di pagare
qualcosa.

## Autoospitare Webstudio: cosa risolve e cosa no

Il builder di Webstudio stesso (non solo l'export) è open source (licenza
AGPL-3.0) e autoospitabile via Docker Compose + PostgreSQL — c'è anche una
guida della comunità: [webstudio-self-host](https://github.com/webstudio-community/webstudio-self-host).

**Ma attenzione a cosa risolve.** Autoospitare il builder significa far girare
tu stesso *lo stesso identico codice* che gira su webstudio.is, su un tuo
server. Non è un'altra versione con più funzioni: è la stessa applicazione.
Quindi **non aggiunge** una funzione di "importa HTML esistente" che nella
versione cloud non c'è — se quella funzione non c'è nel codice, non c'è
nemmeno autoospitato. Il limite "il canvas non importa HTML" è una scelta del
prodotto (il suo modello dati interno), non una restrizione della versione
cloud.

Autoospitare ha senso per altri motivi — indipendenza da webstudio.is,
controllo dei dati, uso come piattaforma multi-progetto — ma comporta gestire
un server, Docker, PostgreSQL e i backup: per un solo sito d'invito è
complessità aggiunta senza un beneficio corrispondente. Meglio l'account
gratuito su webstudio.is.

## Sicurezza

Il share link **è una credenziale**: chi ce l'ha può modificare il progetto.

- `.webstudio.json`, `webstudio.config.json`, `.mcp.json` sono in `.gitignore`.
- Lo script si rifiuta di finire se uno di questi non risulta ignorato.
- Se ti sfugge un push, **revoca il link** da Webstudio (Share → elimina) e
  rigenera: cambiare il file dopo non basta, resta nella cronologia git.
- Il repo è pubblico. Tienilo a mente ogni volta che aggiungi un file.

---

## Se qualcosa non va

| Sintomo | Causa quasi sempre |
|---|---|
| `init --link` fallisce | Accesso API non spuntato sul link |
| L'MCP non compare in Claude Code | Non hai riavviato dopo `connect` |
| `sync` dà errore di permessi | Link scaduto o revocato: rigeneralo |
| Sito online senza stili | Manca `.nojekyll` (lo script lo crea) |
| Build non trovata | Cartella di output cambiata: lo script te lo dice e puoi passarla a mano |

---

## I due percorsi convivono

Lo `scripts/importa-webstudio.sh` accetta sia una cartella compilata sia lo
**zip** scaricato dal builder (Publish → Export → Build and download static site).
Quindi lo stack CLI+MCP è comodo, ma se un giorno non funziona puoi sempre
esportare a mano dal browser e pubblicare lo stesso — nessun blocco.
