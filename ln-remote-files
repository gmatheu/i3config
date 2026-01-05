#!/bin/bash

set -e

if command -v gum >/dev/null 2>&1; then
    green_echo() { gum style --foreground 2 "$1"; }
    yellow_echo() { gum style --foreground 3 "$1"; }
else
    green_echo() { echo "$1"; }
    yellow_echo() { echo "$1"; }
fi

dry_run=false
if [ "$1" = "--dry-run" ]; then
	dry_run=true
fi

while read -r line; do
	if [ -z "$line" ]; then
		continue
	fi

	target=$(echo "$line" | cut -d',' -f1)
	url=$(echo "$line" | cut -d',' -f2)
	mode=$(echo "$line" | cut -d',' -f3)

	if [ -z "$target" ] || [ -z "$url" ]; then
		continue
	fi

	echo "Processing: $target from $url"

	if [ "$dry_run" = true ]; then
		echo "Would create directory: $(dirname "$target")"
		echo "Would download $url to $target"
		if [ "$mode" = "+x" ]; then
			echo "Would set executable permission on $target"
		fi
		green_echo "Would create: $target"
	else
		mkdir -p "$(dirname "$target")"

		if [ -f "$target" ]; then
			cp "$target" "${target}.old"
		else
			yellow_echo "Warning: $target did not exist before download"
		fi

		curl -s "$url" -o "$target"

		if [ "$mode" = "+x" ]; then
			chmod +x "$target"
		fi

		green_echo "Created: $target"
	fi
done <.linked-files

if [ "$dry_run" = true ]; then
	echo "Dry run completed. No files created."
else
	echo "All files processed."
fi
