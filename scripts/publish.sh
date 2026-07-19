#!/usr/bin/env bash
#
# Pubblica quello che c'è ora sul disco, qualunque strumento tu abbia usato
# per modificarlo (editor locale, Webstudio, o a mano).
#
#   ./scripts/publish.sh "Aggiornato il programma"
#
# Non fa nulla di magico: guarda cosa cambia, chiede conferma, poi
# commit + push. Il sito si aggiorna da solo in circa un minuto.

set -euo pipefail

if [ -t 1 ]; then
  R=$'\e[31m'; V=$'\e[32m'; G=$'\e[33m'; B=$'\e[1m'; N=$'\e[0m'
else
  R=""; V=""; G=""; B=""; N=""
fi
ok(){ printf "%s✓%s %s\n" "$V" "$N" "$1"; }
err(){ printf "%s✗ %s%s\n" "$R" "$1" "$N" >&2; }

RADICE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$RADICE"

MESSAGGIO="${1:-}"
if [ -z "$MESSAGGIO" ]; then
  err "Serve un messaggio: ./scripts/publish.sh \"cosa hai cambiato\""
  exit 1
fi

if [ -z "$(git status --porcelain)" ]; then
  echo "Niente da pubblicare: il sito online è già aggiornato."
  exit 0
fi

echo "Modifiche da pubblicare:"
git status --short
echo
read -r -p "Procedo? [s/N] " risposta || risposta=""
case "$risposta" in
  s|S|si|SI|sì|Sì|y|Y) ;;
  *) echo "Annullato."; exit 0 ;;
esac

git add -A
git commit -q -m "$MESSAGGIO"
git push -q origin main

ok "Pubblicato. Online tra circa un minuto:"
echo "    https://eugenionerelli.github.io/beatrice-e-edoardo/"
