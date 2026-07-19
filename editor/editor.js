/* ═══════════════════════════════════════════════════════════════
   Editor locale (GrapesJS) — carica il sito VERO, non una demo.
   Nessun account, nessuna nuvola: gira tutto su questa macchina.
   ═══════════════════════════════════════════════════════════════ */

const stato = document.getElementById("stato");
const bottoneSalva = document.getElementById("salva");

function mostraStato(testo, tipo) {
  stato.textContent = testo;
  stato.className = tipo || "";
}

async function caricaSitoAttuale() {
  const [htmlRes, cssRes] = await Promise.all([
    fetch("../index.html"),
    fetch("../css/style.css"),
  ]);
  if (!htmlRes.ok || !cssRes.ok) {
    throw new Error(
      `Impossibile leggere i file del sito (index.html: ${htmlRes.status}, style.css: ${cssRes.status})`
    );
  }
  const htmlText = await htmlRes.text();
  const cssText = await cssRes.text();

  // Il parser prende solo struttura e stile: lo script (countdown, RSVP,
  // lightbox) resta un file a parte, non qualcosa che l'editor gestisce.
  const doc = new DOMParser().parseFromString(htmlText, "text/html");
  doc.querySelectorAll("script").forEach((el) => el.remove());

  return { html: doc.body.innerHTML, css: cssText };
}

(async function avvia() {
  mostraStato("Carico il sito attuale…");

  let contenuto;
  try {
    contenuto = await caricaSitoAttuale();
  } catch (errore) {
    mostraStato(`Errore nel caricamento: ${errore.message}`, "errore");
    return;
  }

  const pluginPreset = window["grapesjs-preset-webpage"];

  const editor = grapesjs.init({
    container: "#gjs",
    height: "100%",
    fromElement: false,
    components: contenuto.html,
    style: contenuto.css,
    storageManager: false, // niente autosave nel localStorage: il salvataggio è esplicito, verso /save
    canvas: {
      // Senza questo, il canvas non carica i font e tutto appare in Times New Roman
      styles: [
        "https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,500;1,300;1,400&family=Julius+Sans+One&family=Karla:wght@300;400;500&family=Pinyon+Script&display=swap",
      ],
    },
    plugins: pluginPreset ? [pluginPreset] : [],
    pluginsOpts: pluginPreset
      ? { [pluginPreset]: {} }
      : {},
  });

  mostraStato("Pronto.", "ok");

  window.__editor = editor; // utile per ispezionare/debuggare dalla console

  bottoneSalva.addEventListener("click", async () => {
    bottoneSalva.disabled = true;
    mostraStato("Salvo…");

    const html = editor.getHtml();
    const css = editor.getCss();

    try {
      const risposta = await fetch("/save", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ html, css }),
      });
      const dati = await risposta.json();

      if (!risposta.ok) {
        mostraStato(`Errore dal server: ${dati.errore || risposta.status}`, "errore");
      } else if (dati.avvisi && dati.avvisi.length) {
        mostraStato(
          `Salvato, ma mancano: ${dati.avvisi.join(", ")} — il countdown, l'RSVP o la galleria potrebbero smettere di funzionare.`,
          "avviso"
        );
      } else {
        mostraStato("Salvato. Ricarica index.html per vederlo, poi pubblica quando vuoi.", "ok");
      }
    } catch (errore) {
      mostraStato(`Salvataggio fallito: ${errore.message}`, "errore");
    } finally {
      bottoneSalva.disabled = false;
    }
  });
})();
