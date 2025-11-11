function git-upgrade-audioplayers {
  [CmdletBinding()]
  param(
    [string]$RepoRoot = ".",
    [string]$NewVersion = "^6.5.1",
    [switch]$NoCommit
  )

  try { $repo = (Resolve-Path $RepoRoot).Path } catch {
    Write-Error "RepoRoot invalide: $RepoRoot"
    return 1
  }

  $pubspec = Join-Path $repo "pubspec.yaml"
  if (-not (Test-Path $pubspec)) {
    Write-Error "pubspec.yaml introuvable dans $repo"
    return 1
  }

  $content = Get-Content $pubspec -Raw -Encoding UTF8

  # Si audioplayers déjà présent -> remplacer la version
  if ($content -match '^\s*audioplayers\s*:') {
    $newContent = [System.Text.RegularExpressions.Regex]::Replace(
      $content,
      '(?m)^[ \t]*audioplayers\s*:\s*.*$',
      "  audioplayers: $NewVersion"
    )
    Write-Host "Remplacement de la version existante d'audioplayers par $NewVersion" -ForegroundColor Green
  } else {
    # On insère sous le bloc dependencies:
    $pattern = '(?m)^\s*dependencies\s*:\s*$'
    if ($content -match $pattern) {
      $lines = $content -split "`r?`n"
      $newLines = @()
      $inserted = $false
      for ($i=0; $i -lt $lines.Length; $i++) {
        $newLines += $lines[$i]
        if ($lines[$i] -match '^\s*dependencies\s*:\s*$' -and -not $inserted) {
          $indent = "  "
          $newLines += "$indent" + "audioplayers: $NewVersion"
          $inserted = $true
        }
      }
      if (-not $inserted) {
        $newLines += ""
        $newLines += "dependencies:"
        $newLines += "  audioplayers: $NewVersion"
      }
      $newContent = $newLines -join "`r`n"
      Write-Host "Ajout de la dépendance audioplayers: $NewVersion sous dependencies:" -ForegroundColor Green
    } else {
      Write-Warning "Impossible de trouver le bloc 'dependencies:' dans pubspec.yaml. Ajoute manuellement 'audioplayers: $NewVersion'."
      return 1
    }
  }

  if ($newContent -eq $content) {
    Write-Host "Aucune modification nécessaire : la version demandée semble déjà en place." -ForegroundColor Yellow
    return 0
  }

  # Sauvegarde
  $bak = "$pubspec.bak.$((Get-Date).ToString('yyyyMMdd_HHmmss'))"
  Copy-Item $pubspec $bak -Force
  Write-Host "Sauvegarde pubspec: $bak" -ForegroundColor Cyan

  # Écrire le fichier mis à jour
  Set-Content -Path $pubspec -Value $newContent -Encoding UTF8
  Write-Host "pubspec.yaml mis à jour." -ForegroundColor Green

  # Commit local optionnel
  if (-not $NoCommit) {
    try {
      git add -- pubspec.yaml
      git commit -m "chore(deps): upgrade audioplayers to $NewVersion to resolve uuid conflict"
      Write-Host "Commit créé pour la mise à jour de pubspec.yaml." -ForegroundColor Green
    } catch {
      Write-Warning "Erreur pendant le commit automatique (peut-être aucun changement à committer)."
    }
  } else {
    Write-Host "NoCommit: commit automatique désactivé." -ForegroundColor Yellow
  }

  Write-Host "Terminé. Exécute 'flutter pub get' puis 'analyze-limited -OnlyErrors'." -ForegroundColor Cyan
  return 0
}
# Exécuter la fonction maintenant (change en -NoCommit si tu veux tester sans commit)
git-upgrade-audioplayers
