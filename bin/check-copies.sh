#!/bin/sh
# The protocol text ships in five places, one per install path:
#
#   README.md                              copy-and-paste blocks, EN then PT
#   next-action.md                         portable always-loaded file, EN
#   pt/next-action.md                      portable always-loaded file, PT
#   omp/next-action.md                     the EN file as an OMP rule
#   skills/next-action-protocol/SKILL.md   the on-demand skill, EN
#
# Each paste block in the README MUST be byte-identical to the file it stands
# for, and the two EN derivatives MUST carry identical tag definitions. This
# fails loudly when one copy is edited and the others are not.
set -eu

cd "$(dirname "$0")/.."

# Nth fenced ````markdown block of the README, fence lines excluded.
paste_block() {
	awk -v want="$1" '
		/^````markdown$/ { seen++; if (seen == want) { inside = 1; next } }
		/^````$/         { if (inside) exit }
		inside           { print }
	' README.md
}

# A portable file without its optional trailing section.
file_core() {
	awk -v stop="$2" '$0 == stop { exit } { print }' "$1"
}

# Every tag definition, and nothing else, is a top-level list item opening with
# a bracketed tag in backticks.
tags() {
	sed -n '/^- `\[/p' "$1"
}

status=0

report() {
	echo "FAIL: $1"
	echo "--- $2"
	printf '%s\n' "$3"
	echo "--- $4"
	printf '%s\n' "$5"
	status=1
}

# 1. Each README paste block matches its file. Command substitution strips
#    trailing newlines on both sides, so only real content is compared.
en_block=$(paste_block 1)
en_file=$(file_core next-action.md "## Referencing a PR or issue")
[ "$en_block" = "$en_file" ] ||
	report "README.md EN paste block drifted from next-action.md" \
		"README.md" "$en_block" "next-action.md" "$en_file"

pt_block=$(paste_block 2)
pt_file=$(file_core pt/next-action.md "## Referenciando um PR ou issue")
[ "$pt_block" = "$pt_file" ] ||
	report "README.md PT paste block drifted from pt/next-action.md" \
		"README.md" "$pt_block" "pt/next-action.md" "$pt_file"

# 2. Every copy defines all four tags, and the EN derivatives agree verbatim.
expected=$(tags next-action.md)
for file in next-action.md pt/next-action.md omp/next-action.md skills/next-action-protocol/SKILL.md; do
	count=$(tags "$file" | wc -l | tr -d ' ')
	if [ "$count" -ne 4 ]; then
		echo "FAIL: $file defines $count tag(s), expected 4: [DONE] [DECIDE] [HUMAN] [WAIT]"
		status=1
	fi
done

for file in omp/next-action.md skills/next-action-protocol/SKILL.md; do
	actual=$(tags "$file")
	[ "$actual" = "$expected" ] ||
		report "$file drifted from next-action.md" \
			"next-action.md" "$expected" "$file" "$actual"
done

if [ "$status" -eq 0 ]; then
	echo "OK: 2 paste blocks match their files, 4 copies define all four tags"
fi
exit "$status"
