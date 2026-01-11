#!/bin/bash
# Server-side build script
# Usage: ./build_pack.sh <locale> <input_dir> <output_dir> <version>
LOCALE=$1
INPUT=$2
OUTPUT=$3
VERSION=$4

echo "Building pack for $LOCALE v$VERSION..."
zip -r "$OUTPUT/plants_${LOCALE}_v${VERSION}.zip" "$INPUT"
cd "$OUTPUT"
sha256sum "plants_${LOCALE}_v${VERSION}.zip" > "plants_${LOCALE}_v${VERSION}.zip.sha256"
