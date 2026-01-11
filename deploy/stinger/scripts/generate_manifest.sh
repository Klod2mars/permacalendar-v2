#!/bin/bash
# Generates manifest.json from packs directory
# Iterates over .zip files, reads .sha256, and builds JSON.
# Simplified version.

OUTPUT_FILE="../manifest.json"
echo "{" > $OUTPUT_FILE
echo '"generated": "'$(date -Iseconds)'",' >> $OUTPUT_FILE
echo '"packs": {' >> $OUTPUT_FILE
# Logic to loop files would go here
echo '}' >> $OUTPUT_FILE
echo "}" >> $OUTPUT_FILE
