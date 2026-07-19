# Contenuti da incollare in Webstudio

Tutti i testi del sito, in ordine, pronti da copiare nel canvas.
Sostituiscili con quelli veri quando li hai — questi sono i segnaposto della demo.

---

## Copertina

**Monogramma:** `B` + `E` (sovrapposte, vedi [spec.html](spec.html))

**Nomi:** `BEATRICE & EDOARDO`
→ la `&` va in Pinyon Script, il resto in Julius Sans One maiuscolo.

**Data:** `12 . 06 . 2027`
→ spazi attorno ai punti, spaziatura lettere `0.45em`.

---

## La nostra storia

> Tutto è cominciato per caso, un pomeriggio di pioggia e un ombrello prestato alla
> persona sbagliata — o forse a quella giusta. Da quel giorno ogni strada percorsa
> insieme ci ha portato un po' più vicini, tra risate, viaggi e domeniche lente.

> Dopo otto anni fianco a fianco, con il cuore pieno di gratitudine, vogliamo
> condividere con voi il momento più importante del nostro cammino

**— L'INIZIO DEL NOSTRO «PER SEMPRE».**
→ maiuscolo, Julius Sans One, spaziatura `0.22em`.

---

## Conto alla rovescia

**Titolo:** `manca poco...` (Pinyon Script)

**Data e ora di riferimento:** 12 giugno 2027, ore 16:00, fuso `+02:00`

**Etichette:** `GIORNI` · `ORE` · `MINUTI` · `SECONDI`

> Webstudio non ha un countdown nativo. Due strade: un blocco di codice
> personalizzato (il JS è in [`js/main.js`](../js/main.js), funzione
> `aggiornaCountdown`), oppure togli del tutto la sezione — non è essenziale.

---

## Il nostro giorno

**Titolo:** `il nostro giorno...` (Pinyon Script)

### 1 — Ritrovo
- **Orario:** `15:00`
- **Evento:** `RITROVO DEGLI OSPITI`
- **Luogo:** `VILLA CIPRESSI`
- **Indirizzo:** `VIA IV NOVEMBRE 22, VARENNA (LC)`
- **Bottone:** `MOSTRA LA POSIZIONE`
- **Link:** `https://www.google.com/maps/search/?api=1&query=Villa+Cipressi+Varenna`

### 2 — Cerimonia
- **Orario:** `16:00`
- **Evento:** `CERIMONIA`
- **Luogo:** `CHIESA DI SAN GIORGIO`
- **Indirizzo:** `PIAZZA SAN GIORGIO, VARENNA (LC)`
- **Bottone:** `MOSTRA LA POSIZIONE`
- **Link:** `https://www.google.com/maps/search/?api=1&query=Chiesa+di+San+Giorgio+Varenna`

### 3 — Ricevimento
- **Orario:** `18:30`
- **Evento:** `RICEVIMENTO`
- **Luogo:** `GIARDINI DI VILLA CIPRESSI`
- **Indirizzo:** `VIA IV NOVEMBRE 22, VARENNA (LC)`
- **Bottone:** `MOSTRA LA POSIZIONE`
- **Link:** `https://www.google.com/maps/search/?api=1&query=Villa+Cipressi+Varenna`

**Dress code:** `DRESS CODE ·` + `black tie` (in Pinyon Script)

> **Come si fanno i link Maps.** Il formato
> `https://www.google.com/maps/search/?api=1&query=NOME+LUOGO+CITTÀ` funziona sempre
> e non scade. In alternativa: cerca il posto su Google Maps → *Condividi* → *Copia
> link*. Imposta i bottoni per aprirsi in una **nuova scheda** (`target="_blank"`),
> così l'ospite non perde l'invito.

---

## I nostri momenti (galleria)

**Titolo:** `i nostri momenti...` (Pinyon Script)

Sei foto in formato verticale `3/4`. Quelle attuali sono segnaposto Unsplash a
licenza libera — in Webstudio caricherai direttamente le vostre.

| # | Descrizione (testo alternativo) | URL segnaposto |
|---|---|---|
| 1 | Gli sposi mano nella mano | `https://images.unsplash.com/photo-1519741497674-611481863552` |
| 2 | Passeggiata sotto la pioggia | `https://images.unsplash.com/photo-1511285560929-80b456fea0bc` |
| 3 | Scintille di festa | `https://images.unsplash.com/photo-1465495976277-4387d4b0b4c6` |
| 4 | L'uscita degli sposi | `https://images.unsplash.com/photo-1520854221256-17451cc331bf` |
| 5 | La tavola della festa | `https://images.unsplash.com/photo-1469371670807-013ccf25f16a` |
| 6 | Mani intrecciate | `https://images.unsplash.com/photo-1522673607200-164d1b6ce486` |

> Scrivi sempre il testo alternativo: lo leggono i lettori di schermo e compare se
> la foto non carica. Esporta le foto vere larghe ~1600px e sotto i 500 KB.

---

## Conferma di presenza (RSVP)

**Titolo:** `CONFERMA LA TUA PRESENZA`

**Sottotitolo:**
> Ti chiediamo di confermare entro il 12 maggio 2027 — e di unirti a noi in un
> giorno di festa, musica e gioia!

**Campi:**
| Campo | Tipo |
|---|---|
| `NOME` | testo |
| `COGNOME` | testo |
| `SARAI DEI NOSTRI?` | scelta `SÌ` / `NO` |
| `NUMERO DI OSPITI INSIEME A ME` | numero, 0–10 |
| `NOMI DEGLI OSPITI INSIEME A ME` | testo |
| `MESSAGGIO` | testo lungo |

**Bottone:** `CONFERMA` (fondo `#2E2E2B`, testo carta)

> **Vantaggio di Webstudio qui:** ha una gestione dei moduli integrata, quindi le
> risposte ti arrivano senza passare da Formspree o dal client di posta. È il punto
> in cui guadagni di più rispetto al sito attuale.

---

## Citazione finale

> «E poi scegliersi, ogni giorno,
> come la prima volta.»

→ corsivo, Cormorant Garamond 300, a capo dopo la virgola.

---

## Piè di pagina

- **Nomi:** `Beatrice & Edoardo` (Pinyon Script)
- **Data e luogo:** `12 . 06 . 2027 · VARENNA, LAGO DI COMO`
- **Nota demo:** `SITO DEMO — NOMI DI FANTASIA, FOTO UNSPLASH`
  → da togliere quando metti i contenuti veri.

---

## Impostazioni della pagina

| Voce | Valore |
|---|---|
| Titolo | `Beatrice & Edoardo · 12 giugno 2027` |
| Descrizione | `Ci sposiamo! Sabato 12 giugno 2027, Varenna — Lago di Como. Tutti i dettagli e la conferma di presenza.` |
| Immagine anteprima | la foto più bella — è quella che si vede su WhatsApp |
| Indicizzazione | **disattiva** (`noindex`): un invito non deve finire su Google |
| Lingua | `it` |

> Ricorda: `noindex` tiene il sito fuori dai motori di ricerca, ma **chiunque abbia
> il link può aprirlo**. Non metterci indirizzi di casa o numeri di telefono privati.
