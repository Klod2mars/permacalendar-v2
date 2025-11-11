function git-apply-activegarden-fix {
  [CmdletBinding()]
  param(
    [string]$RepoRoot = ".",
    [switch]$NoCommit
  )

  try { $repo = (Resolve-Path $RepoRoot).Path } catch {
    Write-Error "RepoRoot invalide: $RepoRoot"
    return 1
  }

  $providerRel = "lib/core/providers/active_garden_provider.dart"
  $providerPath = Join-Path $repo $providerRel
  $pubspecPath = Join-Path $repo "pubspec.yaml"

  # provider content
  $providerContent = @"
import 'package:riverpod/riverpod.dart';

/// Notifier qui garde l'ID du jardin "actif".
/// Usage attendu :
///   ref.watch(activeGardenIdProvider);
///   ref.read(activeGardenIdProvider.notifier).setActiveGarden(gardenId);
class ActiveGardenIdNotifier extends Notifier<String?> {
  @override
  String? build() {
    return null;
  }

  /// Définit le jardin actif (ID)
  void setActiveGarden(String gardenId) {
    state = gardenId;
  }

  /// Efface la sélection
  void clear() {
    state = null;
  }
}

/// Provider exposant l'ID du jardin actif (String?).
final activeGardenIdProvider = NotifierProvider<ActiveGardenIdNotifier, String?>(ActiveGardenIdNotifier.new);
"@

  # ensure dir
  $dir = Split-Path $providerPath -Parent
  if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }

  # backup existing provider if present
  if (Test-Path $providerPath) {
    $bak = "$providerPath.bak.$((Get-Date).ToString('yyyyMMdd_HHmmss'))"
    Copy-Item $providerPath $bak -Force
    Write-Host "Sauvegarde provider: $bak" -ForegroundColor Cyan
  }

  # write provider file
  Set-Content -Path $providerPath -Value $providerContent -Encoding UTF8
  Write-Host "Fichier créé/modifié: $providerRel" -ForegroundColor Green

  # update pubspec to add audioplayers if missing
  if (-not (Test-Path $pubspecPath)) {
    Write-Warning "pubspec.yaml non trouvé : $pubspecPath. Saut de l'ajout de la dépendance audioplayers."
  } else {
    $pubspec = Get-Content $pubspecPath -Raw -Encoding UTF8
    if ($pubspec -match '^\s*audioplayers\s*:\s*') {
      Write-Host "Dépendance 'audioplayers' déjà présente dans pubspec.yaml" -ForegroundColor Yellow
    } else {
      $pattern = '(?m)^\s*dependencies\s*:\s*$'
      if ($pubspec -match $pattern) {
        $lines = $pubspec -split "`r?`n"
        $newLines = @()
        $inserted = $false
        for ($i=0; $i -lt $lines.Length; $i++) {
          $newLines += $lines[$i]
          if ($lines[$i] -match '^\s*dependencies\s*:\s*$' -and -not $inserted) {
            $indent = "  "
            $depLine = "$indent" + "audioplayers: ^1.1.1"
            $newLines += $depLine
            $inserted = $true
          }
        }
        if (-not $inserted) {
          $newLines += ""
          $newLines += "dependencies:"
          $newLines += "  audioplayers: ^1.1.1"
        }
        $bakPub = "$pubspecPath.bak.$((Get-Date).ToString('yyyyMMdd_HHmmss'))"
        Copy-Item $pubspecPath $bakPub -Force
        Set-Content -Path $pubspecPath -Value ($newLines -join "`r`n") -Encoding UTF8
        Write-Host "pubspec.yaml mis à jour : audioplayers ajouté." -ForegroundColor Green
        Write-Host "Sauvegarde pubspec: $bakPub" -ForegroundColor Cyan
      } else {
        Write-Warning "Impossible de trouver le bloc 'dependencies:' dans pubspec.yaml. Ajoute manuellement 'audioplayers: ^1.1.1'."
      }
    }
  }

  # git add & commit (optionnel)
  if (-not $NoCommit) {
    try {
      git add -- $providerRel
      if (Test-Path $pubspecPath) { git add -- pubspec.yaml }
      $commitMsg = "chore: add activeGardenIdProvider and audioplayers dependency (for insect awakening)"
      git commit -m $commitMsg
      Write-Host "Commit local créé: $commitMsg" -ForegroundColor Green
    } catch {
      Write-Warning "Erreur lors du commit automatique (peut-être aucun changement à committer)."
    }
  } else {
    Write-Host "NoCommit: commit automatique désactivé." -ForegroundColor Yellow
  }

  Write-Host "Terminé. Actions effectuées:" -ForegroundColor Cyan
  Write-Host " - created/updated $providerRel"
  Write-Host " - ensured 'audioplayers' exists in pubspec.yaml (if present)"
  Write-Host "Note: exécute 'flutter pub get' puis 'analyze-limited -OnlyErrors'." -ForegroundColor Gray

  return 0
}
# run it now (change to -NoCommit if you prefer no commit)
git-apply-activegarden-fix
