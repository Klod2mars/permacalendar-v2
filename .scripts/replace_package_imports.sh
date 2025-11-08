#!/usr/bin/env bash
# usage: ./replace_package_imports.sh
set -e
echo "Replacing package:permacalendarv2 -> package:permacalendar in all .dart files..."
git ls-files '*.dart' | xargs sed -i.bak 's/package:permacalendarv2/package:permacalendar/g' || true
# remove backups
git ls-files '*.bak' | xargs rm -f || true
echo "Done."

