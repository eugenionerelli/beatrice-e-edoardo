#!/usr/bin/env bash
#
# Dal progetto Webstudio al sito online, in un comando.
#
#   ./scripts/build-e-pubblica.sh            → compila, mostra il risultato, si ferma
#   ./scripts/build-e-pubblica.sh --pubblica → compila e fa anche commit + push
#
# Richiede che ./scripts/setup-webstudio.sh sia già stato eseguito una volta.

set -euo pipefail

if [ -t 1 ]; then
  R=$'\e[31m'; V=$'\e[32m'; G=$'\e[33m'; B=$'\e[1m'; N=$'\e[0m'
else
  R=""; V=""; G=""; B=""; N=""
fi
ok(){   printf "%s✓%s %s\n" "$V" "$N" "$1"; }
info(){ printf "%s→%s %s\n" "$G" "$N" "$1"; }
err(){  printf "%s✗ %s%s\n" "$R" "$1" "$N" >&2; }

RADICE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$RADICE"

PUBBLICA=false
[ "${1:-}" = "--pubblica" ] && PUBBLICA=true

# ── 1. Il progetto è collegato? ──────────────────────────────────────────────

if [ ! -f .webstudio.json ] && [ ! -d .webstudio ]; then
  err "Progetto non collegato a Webstudio."
  echo "  Esegui prima:  ${B}./scripts/setup-webstudio.sh${N}"
  exit 1
fi

# ── 2. Scarica le ultime modifiche fatte nel canvas ──────────────────────────

info "Scarico le modifiche da Webstudio…"
npx -y webstudio@latest sync || { err "Sync fallito: link scaduto o revocato?"; exit 1; }
ok "Sincronizzato."

# ── 3. Compila come sito statico ─────────────────────────────────────────────

info "Compilo (template ssg)…"
npx -y webstudio@latest build --template ssg || { err "Build fallita."; exit 1; }

# Il CLI può cambiare la cartella di output fra le versioni: invece di darla per
# scontata, la cerchiamo. Cerchiamo la più recente fra quelle plausibili che
# contenga davvero un index.html.
USCITA=""
for c in dist build out .webstudio/dist .webstudio/build; do
  if [ -f "$c/index.html" ]; then USCITA="$c"; break; fi
done

if [ -z "$USCITA" ]; then
  err "Non trovo la cartella compilata (cercate: dist, build, out)."
  echo
  echo "Cartelle presenti ora:"
  find . -maxdepth 2 -type d -not -path './.git/*' -not -path './node_modules/*' \
       -newer package.json 2>/dev/null | head -15 || ls -d */ 2>/dev/null | head -15
  echo
  echo "Trovala e passala a mano:"
  echo "  ${B}./scripts/importa-webstudio.sh <cartella>${N}"
  exit 1
fi
ok "Compilato in ${B}$USCITA${N} ($(find "$USCITA" -type f | wc -l | tr -d ' ') file)."

# ── 4. Porta in produzione (riusa lo script collaudato) ──────────────────────

./scripts/importa-webstudio.sh "$USCITA"

# ── 5. Pubblica, se richiesto ────────────────────────────────────────────────

if [ "$PUBBLICA" = true ]; then
  if [ -z "$(git status --porcelain)" ]; then
    info "Nessuna modifica da pubblicare: il sito è già aggiornato."
    exit 0
  fi
  info "Pubblico…"
  git add -A
  git commit -q -m "Aggiornamento del design da Webstudio"
  git push -q origin main
  ok "Inviato. Il sito si aggiorna in circa un minuto:"
  echo "    https://eugenionerelli.github.io/beatrice-e-edoardo/"
else
  cat <<EOF

${B}Non ho pubblicato.${N} Prima guarda il risultato:

    ${B}python3 -m http.server 8000${N}   → http://localhost:8000

  Poi, se convince:   ${B}./scripts/build-e-pubblica.sh --pubblica${N}
  Se non convince:    ${B}git checkout . && git clean -fd${N}

EOF
fi
