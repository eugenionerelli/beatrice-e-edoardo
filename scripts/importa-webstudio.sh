#!/usr/bin/env bash
#
# Porta in produzione un export statico di Webstudio.
#
#   ./scripts/importa-webstudio.sh                 → usa lo zip più recente in ~/Downloads
#   ./scripts/importa-webstudio.sh percorso.zip    → usa lo zip indicato
#
# Cosa fa: svuota la radice del sito e ci mette dentro l'export, lasciando intatti
# README, design/, scripts/, .gitignore e la cronologia git.
#
# NON fa commit e NON fa push: prima guardi il risultato, poi decidi tu.
#
# La rete di sicurezza è git: lo script si rifiuta di partire se hai modifiche non
# salvate, così `git checkout .` ti riporta sempre indietro.

set -euo pipefail

# ── Colori (solo se siamo in un terminale vero) ───────────────────────────────
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

# Cartelle e file da NON toccare mai
declare -a PROTETTI=(".git" ".gitignore" "README.md" "design" "scripts" "CNAME" ".nojekyll")

# ── 1. Controlli preliminari ─────────────────────────────────────────────────

if [ ! -d .git ]; then
  err "Qui non c'è un repository git. Sei nella cartella giusta?"
  exit 1
fi

if ! command -v unzip >/dev/null 2>&1; then
  err "Manca 'unzip'. Installalo con:  brew install unzip"
  exit 1
fi

if [ -n "$(git status --porcelain)" ]; then
  err "Ci sono modifiche non salvate nel repository."
  echo
  git status --short
  echo
  echo "Prima salvale o annullale, così puoi sempre tornare indietro:"
  echo "  ${B}git add . && git commit -m \"lavoro in corso\"${N}   (per tenerle)"
  echo "  ${B}git checkout .${N}                                (per buttarle)"
  exit 1
fi
ok "Repository pulito: puoi sempre annullare con  git checkout ."

# ── 2. Trova lo zip ──────────────────────────────────────────────────────────

if [ $# -ge 1 ]; then
  ZIP="$1"
  [ -f "$ZIP" ] || { err "File non trovato: $ZIP"; exit 1; }
else
  info "Cerco l'export più recente in ~/Downloads…"
  ZIP="$(find "$HOME/Downloads" -maxdepth 1 -name '*.zip' -type f -print0 2>/dev/null \
         | xargs -0 ls -t 2>/dev/null | head -1 || true)"
  if [ -z "$ZIP" ]; then
    err "Nessuno zip trovato in ~/Downloads."
    echo "Indica il file a mano:  ./scripts/importa-webstudio.sh ~/percorso/export.zip"
    exit 1
  fi
fi

ok "Export: ${B}$(basename "$ZIP")${N}  ($(du -h "$ZIP" | cut -f1))"

# ── 3. Verifica che sia davvero un sito statico ──────────────────────────────

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

unzip -q "$ZIP" -d "$TMP" || { err "Zip illeggibile o danneggiato."; exit 1; }

# L'export può stare nella radice dello zip o dentro una cartella: troviamo index.html.
# ATTENZIONE: cercare index.html e poi fare dirname del risultato vuoto darebbe ".",
# cioè la cartella del repository — che finirebbe per essere copiata su se stessa.
# Perciò il caso "non trovato" va intercettato PRIMA di calcolare la sorgente.
INDEX="$(find "$TMP" -name index.html -not -path '*/__MACOSX/*' -print 2>/dev/null | head -1)"

if [ -z "$INDEX" ]; then
  err "Nello zip non c'è nessun index.html: non è un sito statico."
  echo
  echo "Contenuto dello zip:"
  find "$TMP" -maxdepth 2 -mindepth 1 -not -path '*__MACOSX*' | sed "s|$TMP|  |" | head -20
  echo
  if find "$TMP" -name package.json -not -path '*/node_modules/*' | grep -q .; then
    echo "C'è un package.json: sembra un export come ${B}applicazione JavaScript${N}."
    echo "GitHub Pages serve solo file statici."
  fi
  echo "Su Webstudio scegli ${B}Publish → Export → Build and download static site${N}."
  exit 1
fi

SORGENTE="$(cd "$(dirname "$INDEX")" && pwd)"

# Cintura di sicurezza: la sorgente deve stare nella cartella temporanea, mai nel repo
case "$SORGENTE" in
  "$TMP"/*|"$TMP") ;;
  *) err "Sorgente inattesa ($SORGENTE): interrompo per sicurezza."; exit 1 ;;
esac

NFILE=$(find "$SORGENTE" -type f | wc -l | tr -d ' ')
ok "Sito statico valido: $NFILE file, index.html presente."

# ── 4. Anteprima delle modifiche ─────────────────────────────────────────────

echo
printf "%sVerranno RIMOSSI dalla radice:%s\n" "$B" "$N"
RIMOSSI=0
while IFS= read -r voce; do
  nome="$(basename "$voce")"
  saltare=false
  for p in "${PROTETTI[@]}"; do [ "$nome" = "$p" ] && saltare=true && break; done
  $saltare && continue
  echo "    $nome"
  RIMOSSI=$((RIMOSSI+1))
done < <(find . -maxdepth 1 -mindepth 1)
[ "$RIMOSSI" -eq 0 ] && echo "    (niente)"

echo
printf "%sVerranno CONSERVATI:%s  %s\n" "$B" "$N" "${PROTETTI[*]}"
echo

# Il '|| risposta=""' evita che set -e faccia uscire lo script quando non c'è
# un terminale interattivo (input da /dev/null): in quel caso vale il "no".
read -r -p "Procedo? [s/N] " risposta || risposta=""
case "$risposta" in
  s|S|si|SI|sì|Sì|y|Y) ;;
  *) info "Annullato. Non ho toccato niente."; exit 0 ;;
esac

# ── 5. Sostituzione ──────────────────────────────────────────────────────────

while IFS= read -r voce; do
  nome="$(basename "$voce")"
  saltare=false
  for p in "${PROTETTI[@]}"; do [ "$nome" = "$p" ] && saltare=true && break; done
  $saltare && continue
  rm -rf "$voce"
done < <(find . -maxdepth 1 -mindepth 1)

cp -R "$SORGENTE"/. .
rm -rf ./__MACOSX

# GitHub Pages passa i file per Jekyll, che ignora tutto ciò che inizia con "_".
# Webstudio genera spesso cartelle tipo _astro/: senza questo file spariscono.
touch .nojekyll

ok "Export installato nella radice."

# ── 6. Riepilogo ─────────────────────────────────────────────────────────────

echo
printf "%sModifiche:%s\n" "$B" "$N"
git status --short | head -30
TOT=$(git status --porcelain | wc -l | tr -d ' ')
[ "$TOT" -gt 30 ] && echo "    …e altri $((TOT-30)) file"

cat <<EOF

${B}Prossimi passi${N}

  1. Guarda il risultato in locale:
       ${B}python3 -m http.server 8000${N}   → http://localhost:8000

  2. Se ti convince, pubblica:
       ${B}git add . && git commit -m "Nuovo design da Webstudio" && git push${N}

     Il sito si aggiorna da solo in circa un minuto:
       https://eugenionerelli.github.io/beatrice-e-edoardo/

  3. Se non ti convince, torna indietro senza lasciare traccia:
       ${B}git checkout . && git clean -fd${N}

EOF
