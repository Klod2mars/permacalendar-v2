# .scripts/generate_provider_patch_files.ps1
# Create concrete patch suggestions (non-destructive) from .ai-doc/patches/*.md

$ErrorActionPreference = 'Stop'
$root = (Get-Location).Path
$patchesDir = Join-Path $root ".ai-doc/patches"
$outDir = Join-Path $root ".ai-doc/applied_patches"

if (!(Test-Path $patchesDir)) {
  Write-Error ".ai-doc/patches does not exist. Run M006 first."
  exit 1
}

if (!(Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

$patchFiles = Get-ChildItem -Path $patchesDir -Filter "*.md" | Sort-Object Name

$indexPath = Join-Path $outDir "applied_patches_index.md"
Set-Content -Path $indexPath -Value "# Applied Patch Suggestions`n`n" -Encoding UTF8

foreach ($pf in $patchFiles) {
  $name = $pf.BaseName
  Write-Host "Processing suggestion: $name"
  $content = Get-Content -Raw -Path $pf.FullName -Encoding UTF8

  # Try to extract provider_type
  $providerType = ""
  if ($content -match 'provider_type:\s*([A-Za-z0-9_]+)') { $providerType = $Matches[1].Trim() }

  # Extract BEFORE excerpt: look for markdown section "### Before (excerpt)" followed by ```dart ... ```
  $before = "// Couldn't find before excerpt in suggestion."
  if ($content -match '### Before \(excerpt\)\s*```dart\s*([\s\S]*?)```') {
    $before = $Matches[1].Trim()
  } elseif ($content -match '```dart\s*([\s\S]*?)```') {
    $before = $Matches[1].Trim()
  }

  # Build AFTER snippet template based on provider_type
  switch ($providerType) {
    "NotifierProvider" {
      $after = @"
```dart
// After (example)
final $name = NotifierProvider.family<YourController, YourState, String?>(
  (ref, scopeKey) => YourController(),
);
