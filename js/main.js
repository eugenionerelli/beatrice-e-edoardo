/* ═══════════════════════════════════════════════════════════════
   INVITO DI NOZZE — script
   Conto alla rovescia, animazioni allo scroll, galleria, RSVP.
   ═══════════════════════════════════════════════════════════════ */

/* PERSONALIZZA: data e ora della cerimonia (usata dal conto alla
   rovescia). Il "+02:00" è il fuso orario italiano in estate. */
const DATA_MATRIMONIO = new Date("2027-06-12T16:00:00+02:00");

/* PERSONALIZZA: l'indirizzo email a cui arrivano le conferme
   quando il modulo usa la modalità "mailto" (quella di default). */
const EMAIL_SPOSI = "beatrice.edoardo@example.com";

/* ── Conto alla rovescia ──────────────────────────────────────── */

const cd = {
  giorni: document.getElementById("cd-giorni"),
  ore: document.getElementById("cd-ore"),
  minuti: document.getElementById("cd-minuti"),
  secondi: document.getElementById("cd-secondi"),
};

function aggiornaCountdown() {
  const diff = DATA_MATRIMONIO - new Date();

  if (diff <= 0) {
    document.getElementById("countdown").innerHTML =
      '<p class="cd-oggi" style="font-style:italic">Oggi è il grande giorno!</p>';
    clearInterval(timerCountdown);
    return;
  }

  const sec = Math.floor(diff / 1000);
  cd.giorni.textContent = Math.floor(sec / 86400);
  cd.ore.textContent = String(Math.floor((sec % 86400) / 3600)).padStart(2, "0");
  cd.minuti.textContent = String(Math.floor((sec % 3600) / 60)).padStart(2, "0");
  cd.secondi.textContent = String(sec % 60).padStart(2, "0");
}

const timerCountdown = setInterval(aggiornaCountdown, 1000);
aggiornaCountdown();

/* ── Comparsa delicata delle sezioni allo scroll ──────────────── */

const osservatore = new IntersectionObserver(
  (voci) => {
    voci.forEach((voce) => {
      if (voce.isIntersecting) {
        voce.target.classList.add("visibile");
        osservatore.unobserve(voce.target);
      }
    });
  },
  { threshold: 0.15 }
);

document.querySelectorAll(".reveal").forEach((el) => osservatore.observe(el));

/* ── Galleria: lightbox ───────────────────────────────────────── */

const lightbox = document.getElementById("lightbox");
const lightboxImg = lightbox.querySelector("img");

document.querySelectorAll(".galleria-griglia img").forEach((img) => {
  img.addEventListener("click", () => {
    lightboxImg.src = img.src;
    lightboxImg.alt = img.alt;
    lightbox.showModal();
  });
});

lightbox.addEventListener("click", () => lightbox.close());

/* ── RSVP ─────────────────────────────────────────────────────── */

/* Il sito è statico, quindi il modulo di default prepara un'email
   nel programma di posta dell'ospite. Nel README trovi come
   collegarlo invece a Formspree / Tally / Google Form per ricevere
   le risposte in automatico, senza email. */

const form = document.getElementById("rsvp-form");
const nota = document.getElementById("rsvp-nota");

form.addEventListener("submit", (evento) => {
  evento.preventDefault();

  const dati = new FormData(form);
  const nome = (dati.get("nome") || "").toString().trim();
  const cognome = (dati.get("cognome") || "").toString().trim();

  if (!nome || !cognome) {
    nota.textContent = "Ti manca solo nome e cognome!";
    nota.hidden = false;
    return;
  }

  const righe = [
    `Nome: ${nome} ${cognome}`,
    `Presenza: ${dati.get("presenza")}`,
    `Ospiti con me: ${dati.get("ospiti") || 0}`,
    `Nomi degli ospiti: ${dati.get("nomi-ospiti") || "—"}`,
    "",
    `${dati.get("messaggio") || ""}`,
  ];

  const oggetto = `RSVP matrimonio — ${nome} ${cognome}`;
  window.location.href =
    `mailto:${EMAIL_SPOSI}` +
    `?subject=${encodeURIComponent(oggetto)}` +
    `&body=${encodeURIComponent(righe.join("\n"))}`;

  nota.textContent =
    "Si sta aprendo il tuo programma di posta con la conferma già scritta: ti basta inviarla. Grazie!";
  nota.hidden = false;
});
