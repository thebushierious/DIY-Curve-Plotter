#!/usr/bin/env bash
# Usage: bash tools/init.sh "My Project Name"
# Run once after creating a repo from this template. Replaces the placeholders
# PROJECT_NAME, OWNER/REPO and DATE_TODAY in the template files.
set -eu

NAME=${1:?Usage: bash tools/init.sh "My Project Name"}
REMOTE=$(git config --get remote.origin.url || true)
SLUG=$(printf '%s' "$REMOTE" | sed -E 's#^(git@github.com:|https://github.com/)##; s#\.git$##')
[ -z "$SLUG" ] && SLUG="OWNER/REPO" && echo "No git remote found, leaving OWNER/REPO in place."

esc() { printf '%s' "$1" | sed 's/[&#\\]/\\&/g'; }
N=$(esc "$NAME"); S=$(esc "$SLUG"); D=$(date +%F)

FILES=$(grep -rlI --exclude-dir=.git --exclude=init.sh --exclude=USING_THIS_TEMPLATE.md \
  -e 'PROJECT_NAME' -e 'OWNER/REPO' -e 'DATE_TODAY' . || true)

for F in $FILES; do
  sed -i "s#PROJECT_NAME#$N#g; s#OWNER/REPO#$S#g; s#DATE_TODAY#$D#g" "$F"
  echo "updated $F"
done

echo
echo "Done: \"$NAME\" ($SLUG). Next: put your KiCad project in hardware/v1/kicad/,"
echo "then delete USING_THIS_TEMPLATE.md and any folders you don't need."
