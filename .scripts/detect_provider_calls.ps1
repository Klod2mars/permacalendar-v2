# PowerShell script: detect provider(...) calls in Dart files and write CSV report
$outCsv = "provider_calls_report.csv"
if (Test-Path $outCsv) { Remove-Item $outCsv -Force }
$pattern = '\b([A-Za-z0-9_]+Provider)\s*\('
Write-Host "Scanning .dart files for provider(...) calls..."
$results = @()
Get-ChildItem -Recurse -Filter *.dart | ForEach-Object {
  $path = $_.FullName
  Select-String -Path $path -Pattern $pattern -AllMatches | ForEach-Object {
    foreach ($m in $_.Matches) {
      $results += [PSCustomObject]@{
        file = $path
        line = $_.LineNumber
        match = $m.Value.Trim()
      }
    }
  }
}
if ($results.Count -eq 0) {
  Write-Host "No provider(...) calls found."
  "" | Out-File $outCsv
} else {
  $results | Sort-Object file,line | Export-Csv -Path $outCsv -NoTypeInformation
  Write-Host "Wrote $($results.Count) matches to $outCsv"
}


