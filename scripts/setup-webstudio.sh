#!/usr/bin/env bash
#
# Collega questa cartella al tuo progetto Webstudio e configura l'MCP,
# così Claude Code (o Codex) può modificare il design al posto tuo.
#
#   ./scripts/setup-webstudio.sh                      → chiede il link
#   ./scripts/setup-webstudio.sh "<share-link>"       → link come argomento
#   ./scripts/setup-webstudio.sh "<share-link>" codex → client diverso
#
# Da eseguire UNA VOLTA SOLA. Poi bastano `webstudio sync` e i comandi MCP.

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

CLIENT="${2:-claude}"
case "$CLIENT" in
  claude|codex|cursor|vscode) ;;
  *) err "Client non valido: $CLIENT (ammessi: claude, codex, cursor, vscode)"; exit 1 ;;
esac

# ── 1. Node ──────────────────────────────────────────────────────────────────

if ! command -v node >/dev/null 2>&1; then
  err "Serve Node.js. Installalo con:  brew install node"
  exit 1
fi
NODE_MAJ="$(node -p 'process.versions.node.split(".")[0]')"
if [ "$NODE_MAJ" -lt 20 ]; then
  err "Node $(node -v) è troppo vecchio: serve almeno la 20."
  echo "  brew upgrade node"
  exit 1
fi
ok "Node $(node -v)"

# ── 2. Share link ────────────────────────────────────────────────────────────

LINK="${1:-}"
if [ -z "$LINK" ]; then
  cat <<EOF

${B}Serve il link di condivisione del progetto Webstudio.${N}

Come ottenerlo:
  1. Apri il progetto su ${B}webstudio.is${N}
  2. In alto a destra: ${B}Share${N}
  3. Crea un link con permesso ${B}Build${N} (o superiore) e
     ${B}spunta l'accesso via API${N} — senza quello il CLI non può entrare
  4. Copia il link

EOF
  read -r -p "Incolla qui il link: " LINK || LINK=""
fi

if [ -z "$LINK" ]; then
  err "Nessun link fornito."
  exit 1
fi

case "$LINK" in
  https://*webstudio*) ;;
  *) err "Non sembra un link Webstudio: $LINK"; exit 1 ;;
esac

# ── 3. Collega e scarica ─────────────────────────────────────────────────────

info "Collego il progetto (template ssg, cioè sito statico)…"
if ! npx -y webstudio@latest init --link "$LINK" --template ssg; then
  err "Collegamento fallito."
  echo
  echo "Cause tipiche:"
  echo "  · il link non ha l'${B}accesso API${N} attivo → rigeneralo su Webstudio"
  echo "  · il link è scaduto o è stato revocato"
  echo "  · permesso insufficiente: serve almeno ${B}Build${N}"
  exit 1
fi
ok "Progetto collegato."

info "Scarico il progetto…"
npx -y webstudio@latest sync
ok "Sincronizzato."

# ── 4. Verifica i permessi effettivi del token ───────────────────────────────

info "Controllo cosa permette il token…"
npx -y webstudio@latest permissions 2>&1 | sed 's/^/    /' || true

# ── 5. Configura il client MCP ───────────────────────────────────────────────

info "Configuro l'MCP per ${B}$CLIENT${N}…"
if ! npx -y webstudio@latest connect "$CLIENT"; then
  err "Configurazione MCP fallita."
  exit 1
fi
ok "MCP configurato."

# ── 6. Prova che l'MCP risponda davvero ──────────────────────────────────────

info "Verifico che il server MCP risponda…"
if npx -y webstudio@latest mcp single-op-call meta.index >/dev/null 2>&1; then
  ok "Il server MCP risponde."
else
  err "Il server MCP non risponde. Il progetto è collegato ma l'automazione no."
  echo "  Prova a mano:  npx webstudio mcp single-op-call meta.index"
fi

# ── 7. Controllo che i segreti non finiscano su GitHub ───────────────────────

ESPOSTI=""
for f in .webstudio.json webstudio.config.json .mcp.json; do
  [ -f "$f" ] || continue
  if ! git check-ignore -q "$f" 2>/dev/null; then
    ESPOSTI="$ESPOSTI $f"
  fi
done

if [ -n "$ESPOSTI" ]; then
  err "ATTENZIONE: questi file contengono il token e NON sono ignorati da git:"
  for f in $ESPOSTI; do echo "     $f"; done
  echo "  Aggiungili a .gitignore ${B}prima${N} di fare commit."
  exit 1
fi
ok "I file col token sono ignorati da git."

cat <<EOF

${B}Fatto.${N}

  Da ora, in Claude Code puoi chiedere cose come:
    «cambia la palette del sito in verde salvia»
    «aggiungi una sezione con le indicazioni per l'hotel»
    «fammi vedere come viene su mobile»

  Comandi utili a mano:
    ${B}npx webstudio sync${N}                        scarica le modifiche fatte nel canvas
    ${B}npx webstudio mcp list-tools${N}              cosa sa fare l'MCP
    ${B}npx webstudio preview${N}                     anteprima locale
    ${B}./scripts/build-e-pubblica.sh${N}             compila e manda online

EOF
