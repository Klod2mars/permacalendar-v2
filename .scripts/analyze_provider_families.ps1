# PowerShell: build provider_family_report.csv by cross-referencing provider_calls_report.csv and source definitions
$root = (Get-Location).Path
$callsCsv = Join-Path $root "provider_calls_report.csv"
if (!(Test-Path $callsCsv)) {
  Write-Host "provider_calls_report.csv not found. Run detect_provider_calls first."
  exit 1
}
$calls = Import-Csv $callsCsv
$grouped = $calls | Group-Object -Property match | ForEach-Object {
  [PSCustomObject]@{
    provider = ($_.Name -replace '\($','')
    usages    = $_.Count
  }
}
$out = @()
foreach ($g in $grouped) {
  $prov = $g.provider
  # find definition: search for NotifierProvider / Provider / FutureProvider / StreamProvider
  $def = Get-ChildItem -Recurse -Filter *.dart | Select-String -Pattern "final\s+$prov\s*=\s*([A-Za-z0-9_\.]+Provider)" -List -AllMatches | Select-Object -First 1
  if ($def -ne $null) {
    $file = $def.Path
    $line = $def.LineNumber
    $type = ($def.Matches[0].Groups[1].Value)
    $content = Get-Content -Path $file -Raw
    $isFamily = $content -match "$prov\s*=\s*.*\.family<" -or ($content -match "$prov\s*=\s*NotifierProvider\.family")
  } else {
    $file = ""
    $line = ""
    $type = ""
    $isFamily = $false
  }
  $out += [PSCustomObject]@{
    provider     = $prov
    usages       = $g.usages
    defined_in   = $file
    defined_line = $line
    defined_type = $type
    is_family    = $isFamily
  }
}
$out | Sort-Object -Property usages -Descending | Export-Csv -Path provider_family_report.csv -NoTypeInformation
Write-Host "Wrote provider_family_report.csv with $($out.Count) entries."

# Generate suggestions file
$md = "provider_family_suggestions.md"
Set-Content -Path $md -Value "# Provider family suggestions`n`n"
foreach ($r in $out | Sort-Object usages -Descending | Select-Object -First 40) {
  if ($r.is_family -eq $false) {
    Add-Content -Path $md -Value "## $($r.provider)`n"
    Add-Content -Path $md -Value "- usages: $($r.usages)`n- defined_in: $($r.defined_in):$($r.defined_line)`n"
    Add-Content -Path $md -Value "### Suggested transformation (example for NotifierProvider):`n"
    Add-Content -Path $md -Value '```dart'
    Add-Content -Path $md -Value "// Before:`n// final $($r.provider) = NotifierProvider<SomeController, SomeState>((ref) => SomeController());"
    Add-Content -Path $md -Value "// After:`n// final $($r.provider) = NotifierProvider.family<SomeController, SomeState, String?>((ref, param) => SomeController());"
    Add-Content -Path $md -Value '```'
    Add-Content -Path $md -Value "`n"
  }
}
Write-Host "Wrote provider_family_suggestions.md (top 40 suggestions)."

