#! PowerShell: generate provider patch suggestion markdown files for manual review
$ErrorActionPreference = "Stop"

$root = (Get-Location).Path
$csv = Join-Path $root "provider_family_report.csv"
if (!(Test-Path $csv)) {
  Write-Error "provider_family_report.csv missing. Run analyze_provider_families first."
  exit 1
}

$rows = Import-Csv $csv | Where-Object { $_.is_family -eq "False" -and $_.defined_in -ne "" } | Sort-Object -Property usages -Descending
if ($rows.Count -eq 0) {
  Write-Host "No provider entries require patch suggestions."
  exit 0
}

$callsCsv = Join-Path $root "provider_calls_report.csv"
$callLookup = @{}
if (Test-Path $callsCsv) {
  Import-Csv $callsCsv | ForEach-Object {
    $name = ($_.match -replace '\($', '')
    if ($callLookup.ContainsKey($name)) {
      $callLookup[$name] += ,$_
    } else {
      $callLookup[$name] = @($_)
    }
  }
}

$outDir = Join-Path $root ".ai-doc/patches"
if (!(Test-Path $outDir)) {
  New-Item -ItemType Directory -Path $outDir | Out-Null
}

$summary = Join-Path $root ".ai-doc/provider_family_patches.md"
Set-Content -Path $summary -Encoding UTF8 -Value "# Provider family patch suggestions`n`n"

function Get-RelativePath {
  param(
    [Parameter(Mandatory = $true)][string]$BasePath,
    [Parameter(Mandatory = $true)][string]$TargetPath
  )
  if ([string]::IsNullOrWhiteSpace($TargetPath)) { return $TargetPath }
  $baseWithSep = if ($BasePath.EndsWith([System.IO.Path]::DirectorySeparatorChar)) { $BasePath } else { $BasePath + [System.IO.Path]::DirectorySeparatorChar }
  if ($TargetPath.StartsWith($baseWithSep, [System.StringComparison]::OrdinalIgnoreCase)) {
    return $TargetPath.Substring($baseWithSep.Length)
  }
  return $TargetPath
}

$count = 0
foreach ($r in $rows) {
  if ($count -ge 10) { break }

  $prov = $r.provider
  $defFile = $r.defined_in
  if (!(Test-Path $defFile)) {
    Add-Content -Path $summary -Encoding UTF8 -Value "## $prov - definition file not found: $defFile`n"
    continue
  }

  $defs = Select-String -Path $defFile -Pattern "final\s+$prov\s*=" -List
  if ($defs.Count -ne 1) {
    Add-Content -Path $summary -Encoding UTF8 -Value "## $prov - skipped (multiple or zero definitions found).`n"
    continue
  }

  $lineNo = $defs.LineNumber
  $content = Get-Content -Path $defFile
  $start = [Math]::Max(1, $lineNo - 4)
  $end = [Math]::Min($content.Length, $lineNo + 8)
  $snippetLines = $content[($start-1)..($end-1)]
  $snippet = $snippetLines -join "`n"

  $relDefFile = Get-RelativePath -BasePath $root -TargetPath $defFile
  $providerType = if ([string]::IsNullOrWhiteSpace($r.defined_type)) { "<ProviderType>" } else { $r.defined_type }
  $familyType = if ($providerType -eq "<ProviderType>") { "<ProviderType>.family" } else { "$providerType.family" }

  $callSnippet = $null
  $callFile = $null
  $callLine = $null
  if ($callLookup.ContainsKey($prov)) {
    $sample = $callLookup[$prov][0]
    $callFile = $sample.file
    $callLine = [int]$sample.line
    if (Test-Path $callFile) {
      $callContent = Get-Content -Path $callFile
      $callStart = [Math]::Max(1, $callLine - 2)
      $callEnd = [Math]::Min($callContent.Length, $callLine + 3)
      $callSnippet = ($callContent[($callStart-1)..($callEnd-1)]) -join "`n"
    }
  }

  $relCallFile = $null
  if ($callFile) {
    $relCallFile = Get-RelativePath -BasePath $root -TargetPath $callFile
  }

  $lines = @()
  $lines += "## $prov"
  $lines += "defined_in: ${relDefFile}:$lineNo"
  $lines += "usages: $($r.usages)"
  if (-not [string]::IsNullOrWhiteSpace($r.defined_type)) {
    $lines += "provider_type: $($r.defined_type)"
  }
  $lines += ""
  $lines += "### Before (excerpt)"
  $lines += "```dart"
  $lines += $snippet
  $lines += "```"
  $lines += ""

  if ($callSnippet) {
    $lines += "### Sample call site"
    $location = if ($relCallFile) { "${relCallFile}:$callLine" } else { "${callFile}:$callLine" }
    $lines += "_first call_: $location"
    $lines += "```dart"
    $lines += $callSnippet
    $lines += "```"
    $lines += ""
  }

  $lines += "### Suggested manual patch (outline)"
  $lines += "1. Convert the provider definition to `$familyType` and add a positional parameter in the closure: `(ref, param) => ...`."
  $lines += "2. Thread the new parameter through the provider logic (state, repository lookups, keys) so each invocation is scoped correctly."
  $lines += "3. Update every `ref.watch`/`ref.read` call to pass the parameter explicitly (e.g. `ref.watch($prov(param))`)."
  $lines += "4. Adjust any helper methods or widgets that previously consumed `$prov` to accept and forward the parameter."
  $lines += "5. Add or update tests that cover at least two parameter values to confirm the `.family` conversion."
  $lines += ""
  $lines += "### Review checklist"
  $lines += "- [ ] Ensure the parameter type is explicit in the `.family` generics."
  $lines += "- [ ] Confirm no lingering zero-argument usages remain."
  $lines += "- [ ] Consider memoization or caching impacts after `.family` migration."
  $lines += ""

  $suggestion = $lines -join "`n"
  $suggestFile = Join-Path $outDir "$prov.md"
  Set-Content -Path $suggestFile -Encoding UTF8 -Value $suggestion

  Add-Content -Path $summary -Encoding UTF8 -Value @"
## $prov
- defined_in: ${relDefFile}:$lineNo
- usages: $($r.usages)
- suggestion: patches/$prov.md

"@

  $count += 1
}

Add-Content -Path $summary -Encoding UTF8 -Value "Generated $count suggestion file(s) in patches/.`n"
Write-Host "Generated $count suggestion file(s) under $outDir."

