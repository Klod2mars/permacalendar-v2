Param(
  [string]$OutDir = "reports/weather_audit"
)
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$tokens = @("weather","meteo","openmeteo","open_meteo","open-meteo","forecast","Weather","weatherBox","weather_repository","WeatherService","current_weather","weather_widget","WeatherBloc","WeatherCubit")

$RAW = Join-Path $OutDir "audit_raw_results.txt"
$CSV = Join-Path $OutDir "audit_table.csv"
$MD  = Join-Path $OutDir "audit_table.md"
$ENDPOINTS = Join-Path $OutDir "network_endpoints.txt"

"" > $RAW

foreach ($t in $tokens) {
  Add-Content -Path $RAW -Value "### TOKEN: $t"
  Select-String -Path lib/*,android/*,ios/*,test/* -Pattern $t -Encoding utf8 -CaseSensitive:$false -SimpleMatch | ForEach-Object {
    Add-Content -Path $RAW -Value "$($_.Path):$($_.LineNumber):$($_.Line)"
  }
  Add-Content -Path $RAW -Value ""
}

# endpoints
Select-String -Path lib/* -Pattern "http[s]?://[a-zA-Z0-9./_:-]+" -Encoding utf8 -AllMatches | `
  ForEach-Object { $_.Matches.Value } | Sort-Object -Unique | `
  Select-String -Pattern "weather|meteo|open|forecast|api" -AllMatches | `
  ForEach-Object { $_.Line } > $ENDPOINTS

# CSV
"path,role,notes" | Out-File -FilePath $CSV -Encoding utf8
Get-Content $RAW | Select-String -Pattern "^[^#].+:" | ForEach-Object {
  $file = ($_ -split ":")[0]
  $role = "unknown"
  if ($file -like "*features/weather*") { $role = "feature" }
  elseif ($file -like "*/weather/*") { $role = "feature" }
  elseif ($file -like "*/data/*" -or $file -like "*_datasource*") { $role = "data_source" }
  elseif ($file -like "*/providers/*" -or $file -like "*Repository*") { $role = "repository" }
  elseif ($file -like "*/ui/*" -or $file -like "*Widget*") { $role = "ui" }
  elseif ($file -like "*/test/*") { $role = "test" }
  Add-Content -Path $CSV -Value ('"{0}","{1}","{2}"' -f $file,$role,"auto-detected")
}

# MD table
"| path | role | notes |" | Out-File -FilePath $MD -Encoding utf8
"|------|------|-------|" | Out-File -Append -FilePath $MD -Encoding utf8
Get-Content $CSV | Select-Object -Skip 1 | ForEach-Object {
  $parts = $_ -split ","
  $p = $parts[0].Trim('"')
  $r = $parts[1].Trim('"')
  $n = $parts[2].Trim('"')
  "| $p | $r | $n |" | Out-File -Append -FilePath $MD -Encoding utf8
}
Write-Host "Audit complete → $RAW, $CSV, $MD, $ENDPOINTS"
