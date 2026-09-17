#!/bin/sh
# The protocol text ships in four places, one per install path:
#
#   README.md                              the copy-and-paste block
#   next-action.md                         the portable always-loaded file
#   omp/next-action.md                     the same file as an OMP rule
#   skills/next-action-protocol/SKILL.md   the on-demand skill
#
# The four tag definitions MUST be identical in all of them. This fails loudly
# when one copy is edited and the others are not.
set -eu

cd "$(dirname "$0")/.."

FILES="README.md next-action.md omp/next-action.md skills/next-action-protocol/SKILL.md"
REFERENCE="README.md"

# Every tag definition, and nothing else, is a top-level list item opening with
# a bracketed tag in backticks.
tags() {
	sed -n '/^- `\[/p' "$1"
}

expected=$(tags "$REFERENCE")
count=$(printf '%s\n' "$expected" | wc -l | tr -d ' ')
if [ "$count" -ne 4 ]; then
	echo "FAIL: $REFERENCE defines $count tag(s), expected 4: [DONE] [DECIDE] [HUMAN] [WAIT]"
	exit 1
fi

status=0
for file in $FILES; do
	actual=$(tags "$file")
	if [ "$actual" != "$expected" ]; then
		echo "FAIL: $file drifted from $REFERENCE"
		echo "--- $REFERENCE"
		printf '%s\n' "$expected"
		echo "--- $file"
		printf '%s\n' "$actual"
		status=1
	fi
done

if [ "$status" -eq 0 ]; then
	echo "OK: 4 copies carry identical tag definitions"
fi
exit "$status"
