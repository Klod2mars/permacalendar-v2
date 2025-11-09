$ErrorActionPreference = 'Stop'

$root = (Get-Location).Path
$testDir = Join-Path $root 'test'
$stubPath = Join-Path $testDir 'test_setup_stub.dart'

if (-not (Test-Path $testDir)) {
  Write-Host "Test directory not found at $testDir."
  exit 1
}

Write-Host 'Prepending test/test_setup_stub import to test files...'
$testFiles = Get-ChildItem -Path $testDir -Recurse -Filter '*.dart'

foreach ($file in $testFiles) {
  if ($file.FullName.EndsWith('test_setup_stub.dart')) {
    Write-Host "Skipping bootstrap file: $($file.FullName)"
    continue
  }

  if ($file.FullName.EndsWith("helpers\register_hive_adapters.dart")) {
    Write-Host "Skipping generated helpers/register_hive_adapters.dart: $($file.FullName)"
    continue
  }

  $relativeUri = (New-Object System.Uri($file.DirectoryName + [IO.Path]::DirectorySeparatorChar)).
    MakeRelativeUri((New-Object System.Uri($stubPath)))
  $relativePath = [System.Uri]::UnescapeDataString($relativeUri.ToString())
  $relativePath = $relativePath -replace '\\','/'
  $importLine = "import '$relativePath';"

  $lines = Get-Content -LiteralPath $file.FullName

  $existingImportIndex = $null
  for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i].Trim() -eq $importLine -or $lines[$i].Trim() -eq "import 'test/test_setup_stub.dart';") {
      $existingImportIndex = $i
      break
    }
  }

  $filteredLines = @()
  foreach ($line in $lines) {
    $trimmedLine = $line.Trim()
    if ($trimmedLine -eq $importLine -or $trimmedLine -eq "import 'test/test_setup_stub.dart';") {
      continue
    }
    $filteredLines += $line
  }

  $lines = $filteredLines

  $insertIndex = 0
  $inBlockComment = $false

  for ($i = 0; $i -lt $lines.Length; $i++) {
    $current = $lines[$i]
    $trimmed = $current.Trim()

    if ($inBlockComment) {
      $insertIndex = $i + 1
      if ($trimmed.Contains('*/')) {
        $inBlockComment = $false
      }
      continue
    }

    if ($trimmed -eq '' -or $trimmed.StartsWith('//') -or $trimmed.StartsWith('#!')) {
      $insertIndex = $i + 1
      continue
    }

    if ($trimmed.StartsWith('/*')) {
      $insertIndex = $i + 1
      if (-not $trimmed.Contains('*/')) {
        $inBlockComment = $true
      }
      continue
    }

    if ($trimmed.StartsWith('library ')) {
      $insertIndex = $i + 1
      continue
    }

    if ($trimmed.StartsWith('part of ')) {
      $insertIndex = $i + 1
      continue
    }

    break
  }

  $newLines = @()
  if ($insertIndex -gt 0) {
    $newLines += $lines[0..($insertIndex - 1)]
  }

  $newLines += $importLine

  if ($insertIndex -lt $lines.Length -and $lines[$insertIndex].Trim() -ne '') {
    $newLines += ''
  }

  if ($insertIndex -lt $lines.Length) {
    $newLines += $lines[$insertIndex..($lines.Length - 1)]
  }

  Set-Content -Path $file.FullName -Value $newLines -Encoding UTF8
  if ($existingImportIndex -ne $null) {
    Write-Host "Updated bootstrap import position: $($file.FullName)"
  } else {
    Write-Host "Prepended to $($file.FullName)"
  }
}

