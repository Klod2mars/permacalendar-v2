# apply_custom_travaux_patch.ps1
# Usage: powershell -ExecutionPolicy Bypass -File .\apply_custom_travaux_patch.ps1

$patchPath = Join-Path (Get-Location) 'travaux.patch'
if (-not (Test-Path $patchPath)) {
  Write-Error "travaux.patch introuvable à la racine. Place le patch et relance."
  exit 1
}

# Lire patch et normaliser les fins de ligne en \n pour faciliter le parsing
$patchRaw = Get-Content -Raw -LiteralPath $patchPath
$patch = $patchRaw -replace "`r`n", "`n"

# Séparer les sections "Update File"
$sections = $patch -split "(?m)^\*\*\* Update File: "
$nl = "`n"

foreach ($sec in $sections) {
  $secTrim = $sec.Trim()
  if ([string]::IsNullOrWhiteSpace($secTrim)) { continue }

  # le premier saut de ligne sépare le chemin de fichier et le contenu du hunks
  $firstLineEnd = $sec.IndexOf("`n")
  if ($firstLineEnd -lt 0) { continue }
  $filePath = $sec.Substring(0, $firstLineEnd).Trim()
  $rest = $sec.Substring($firstLineEnd + 1)

  if (-not (Test-Path $filePath)) {
    Write-Warning "Fichier cible non trouvé : $filePath — saut de cette section."
    continue
  }

  # récupérer les lignes du bloc
  $restLines = $rest -split "`n"
  $i = 0
  $chunks = @()

  while ($i -lt $restLines.Count) {
    # sauter jusqu'à rencontrer une ligne qui commence par '-'
    if (-not $restLines[$i].StartsWith('-')) { $i++; continue }

    # collecter le bloc ancien (- lines)
    $oldLines = @()
    while ($i -lt $restLines.Count -and $restLines[$i].StartsWith('-')) {
      $line = $restLines[$i].Substring(1)  # retirer le '-'
      $oldLines += $line
      $i++
    }

    # collecter bloc nouveau (+ lines) (optionnellement)
    $newLines = @()
    while ($i -lt $restLines.Count -and $restLines[$i].StartsWith('+')) {
      $line = $restLines[$i].Substring(1)  # retirer le '+'
      $newLines += $line
      $i++
    }

    if ($oldLines.Count -gt 0 -and $newLines.Count -gt 0) {
      $oldText = ($oldLines -join $nl)
      $newText = ($newLines -join $nl)
      $chunks += ,@{'old'=$oldText; 'new'=$newText}
    }
  }

  # lecture du fichier cible (normaliser)
  $fileRaw = Get-Content -Raw -LiteralPath $filePath
  $fileNorm = $fileRaw -replace "`r`n", "`n"
  $orig = $fileNorm
  $appliedAny = $false

  foreach ($chunk in $chunks) {
    $oldText = $chunk['old']
    $newText = $chunk['new']

    if ($fileNorm.Contains($oldText)) {
      $fileNorm = $fileNorm.Replace($oldText, $newText)
      $appliedAny = $true
      Write-Host "Applied replacement in $filePath (a chunk)"
    } else {
      Write-Warning "Chunk not found in $filePath — skipped one chunk (old text not matched)."
    }
  }

  if ($appliedAny) {
    # rétablir les fins de ligne Windows
    $final = $fileNorm -replace "`n", [Environment]::NewLine
    # sauvegarder le fichier
    Set-Content -LiteralPath $filePath -Value $final -Encoding utf8
    Write-Host "Updated file: $filePath"
  } else {
    Write-Host "No changes applied to $filePath"
  }
}

Write-Host "apply_custom_travaux_patch.ps1: done. Vérifie les fichiers modifiés, puis git add/commit."
