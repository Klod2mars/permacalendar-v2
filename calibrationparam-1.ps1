# ----- START: inject_calibration_section.ps1 -----
# Usage: coller/exécuter depuis la racine du repo (PowerShell)
# - Backup du fichier
# - Ajout d'un import si absent
# - Insertion de la CalibrationSettingsSection avant _buildAboutSection
# - Commit automatique

$path = "lib/shared/presentation/screens/settings_screen.dart"

if (-not (Test-Path $path)) {
  Write-Host "Erreur : fichier introuvable : $path" -ForegroundColor Red
  exit 1
}

# Backup (unique .bak, sinon horodaté)
$bak = "$path.bak"
if (-not (Test-Path $bak)) {
  Copy-Item -Path $path -Destination $bak -Force
  Write-Host "Backup créé : $bak" -ForegroundColor Green
} else {
  $ts = Get-Date -Format "yyyyMMdd_HHmmss"
  $bak2 = "$path.bak.$ts"
  Copy-Item -Path $path -Destination $bak2 -Force
  Write-Host "Backup existant trouvé — nouveau backup créé : $bak2" -ForegroundColor Yellow
}

# Lire le fichier en lignes UTF8
$lines = Get-Content -Encoding UTF8 $path

# ---- 1) Ajouter l'import si absent ----
$importLine = "import '../widgets/settings/calibration_settings_section.dart';"
$hasImport = $false
foreach ($l in $lines) {
  if ($l.Trim() -eq $importLine) { $hasImport = $true; break }
}

if (-not $hasImport) {
  # trouver dernier import
  $lastImportIndex = -1
  for ($i=0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match '^\s*import\s') { $lastImportIndex = $i }
  }
  if ($lastImportIndex -ge 0) {
    $before = $lines[0..$lastImportIndex]
    if ($lastImportIndex + 1 -le $lines.Count - 1) {
      $after = $lines[($lastImportIndex + 1)..($lines.Count - 1)]
    } else {
      $after = @()
    }
    $newLines = @()
    $newLines += $before
    $newLines += $importLine
    $newLines += $after
    $lines = $newLines
    Write-Host "Import ajouté après la dernière déclaration import." -ForegroundColor Green
  } else {
    # aucun import trouvé : insérer en tête
    $lines = @($importLine) + $lines
    Write-Host "Aucun import trouvé : import inséré en tête." -ForegroundColor Yellow
  }
} else {
  Write-Host "Import déjà présent : rien à faire." -ForegroundColor Cyan
}

# ---- 2) Insérer la CalibrationSettingsSection avant _buildAboutSection ----
$aboutIndex = -1
for ($i=0; $i -lt $lines.Count; $i++) {
  if ($lines[$i] -match '_buildAboutSection\s*\(') {
    $aboutIndex = $i
    break
  }
}

if ($aboutIndex -lt 0) {
  Write-Host "Erreur: impossible de trouver _buildAboutSection(context, theme) dans le fichier. Abandon." -ForegroundColor Red
  exit 1
}

# Préparer les lignes à insérer (respect des indentations observées)
$insertLines = @(
  "            // Calibration (nouveau)",
  "            const CalibrationSettingsSection(),",
  "            const SizedBox(height: 24),"
)

# Vérifier si notre section est déjà présente (idempotence)
$alreadyInserted = $false
$startSearch = [Math]::Max(0, $aboutIndex - 40) # zone précédente
for ($i=$startSearch; $i -lt $aboutIndex; $i++) {
  if ($lines[$i].Trim() -eq "const CalibrationSettingsSection(),") { $alreadyInserted = $true; break }
}

if ($alreadyInserted) {
  Write-Host "CalibrationSettingsSection déjà présente — insertion ignorée." -ForegroundColor Cyan
} else {
  # Construire nouveau contenu
  if ($aboutIndex -eq 0) {
    $newContentLines = $insertLines + $lines
  } else {
    $before = $lines[0..($aboutIndex - 1)]
    $after = $lines[$aboutIndex..($lines.Count - 1)]
    $newContentLines = @()
    $newContentLines += $before
    $newContentLines += $insertLines
    $newContentLines += $after
  }

  # Ecrire le fichier UTF8 sans BOM
  $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
  [System.IO.File]::WriteAllLines($path, $newContentLines, $utf8NoBom)
  Write-Host "CalibrationSettingsSection insérée avant _buildAboutSection." -ForegroundColor Green
}

# ---- 3) git add & commit ----
try {
  git add -- $path
  git commit -m "feat(settings): add CalibrationSettingsSection to SettingsScreen"
  Write-Host "Commit effectué : feat(settings): add CalibrationSettingsSection to SettingsScreen" -ForegroundColor Green
} catch {
  Write-Host "Commit automatique échoué. Vous pouvez committer manuellement." -ForegroundColor Yellow
  Write-Host $_
}

Write-Host "`nTerminé. Pour vérifier : flutter analyze $path ; puis rebuild : flutter clean && flutter pub get && flutter run"
# ----- END -----
