#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="reports/weather_audit"
mkdir -p "$OUT_DIR"

TOKENS=(weather meteo openmeteo open_meteo open-meteo forecast Weather weatherBox weather_repository WeatherService current_weather weather_widget WeatherBloc WeatherCubit)

# choose rg or grep
SEARCHER=""
if command -v rg >/dev/null 2>&1; then
  SEARCHER="rg -n --no-heading"
else
  SEARCHER="grep -RInE"
fi

RAW="$OUT_DIR/audit_raw_results.txt"
TABLE_CSV="$OUT_DIR/audit_table.csv"
TABLE_MD="$OUT_DIR/audit_table.md"
ENDPOINTS="$OUT_DIR/network_endpoints.txt"

# 1) Raw hits
: > "$RAW"
for t in "${TOKENS[@]}"; do
  echo "### TOKEN: $t" >> "$RAW"
  $SEARCHER "$t" lib/ android/ ios/ test/ >> "$RAW" || true
  echo "" >> "$RAW"
done

# 2) Endpoints (common weather vendors; adjust as needed)
$SEARCHER "http[s]?://[a-zA-Z0-9./_:-]+" lib/ | sort -u | grep -Ei "weather|meteo|open|forecast|api" || true > "$ENDPOINTS"

# 3) Build table CSV & MD
echo "path,role,notes" > "$TABLE_CSV"
while IFS= read -r line; do
  # format: path:line:match
  f="${line%%:*}"
  role="unknown"
  notes=""
  if [[ "$f" == *"features/weather"* ]] || [[ "$f" == *"/weather/"* ]]; then role="feature"; fi
  if [[ "$f" == *"/data/"* ]] || [[ "$f" == *"_datasource"* ]]; then role="data_source"; fi
  if [[ "$f" == *"/providers/"* ]] || [[ "$f" == *"Repository"* ]]; then role="repository"; fi
  if [[ "$f" == *"/ui/"* ]] || [[ "$f" == *"Widget"* ]]; then role="ui"; fi
  if [[ "$f" == *"/test/"* ]]; then role="test"; fi
  echo "\"$f\",\"$role\",\"auto-detected\"" >> "$TABLE_CSV"
done < <(grep -E "^[^#].+:" "$RAW" | cut -d: -f1-1 | sort -u)

# Markdown table
{
  echo "| path | role | notes |"
  echo "|------|------|-------|"
  tail -n +2 "$TABLE_CSV" | while IFS=, read -r p r n; do
    echo "| ${p//\"/} | ${r//\"/} | ${n//\"/} |"
  done
} > "$TABLE_MD"

echo "Audit complete → $RAW, $TABLE_CSV, $TABLE_MD, $ENDPOINTS"
