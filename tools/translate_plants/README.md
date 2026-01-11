# Permacalendar i18n Tools

## Setup
1. `npm install`
2. Copy `.env.example` to `.env` and fill in keys.

## Scripts
- `generate_glossary_from_input.js`: Extract seed glossary from massive JSON.
- `wikidata_fetch.js`: Fetch labels from Wikidata.
- `translate_with_glossary.js`: Translate localized fields using DeepL/Google + Glossary.
- `generate_packs.js`: Create zip packs.

## Env Vars
```
DEEPL_API_KEY=...
GOOGLE_API_KEY=...
MT_PROVIDER=deepl
INPUT_JSON=../../assets/data/plants_fr_massive.json
OUT_DIR=./out
GLOSSARY_PATH=glossary_seed.json
```
