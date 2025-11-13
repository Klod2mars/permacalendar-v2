# Safe fixer for mojibake in ./lib Dart files
# This script builds mojibake keys programmatically (no non-ASCII literals in the source file).
$ErrorActionPreference = "Stop"

# Backup folder
$timestamp = (Get-Date).ToString("yyyyMMddHHmmss")
$backupDir = Join-Path -Path (Join-Path -Path (Get-Location) -ChildPath "tools") -ChildPath ("backup_mojibake_$timestamp")
if (-not (Test-Path $backupDir)) { New-Item -ItemType Directory -Path $backupDir | Out-Null }
Write-Host "Backup dir: $backupDir"

# Encodings
$enc1252 = [System.Text.Encoding]::GetEncoding(1252)
$utf8 = [System.Text.Encoding]::UTF8

# Build a list of correct (target) strings using char codes and concatenation (no non-ASCII literal)
$singleChars = @(
    [char]0x00E9, # é
    [char]0x00E8, # è
    [char]0x00EA, # ê
    [char]0x00F4, # ô
    [char]0x00FB, # û
    [char]0x00E2, # â
    [char]0x00E7, # ç
    [char]0x00C9, # É
    [char]0x00C0, # À
    [char]0x00E0, # à
    [char]0x2022, # bullet •
    [char]0x2019, # right single quote ’
    [char]0x2013, # en dash –
    [char]0x2014, # em dash —
    [char]0x201C, # left double quote “
    [char]0x201D, # right double quote ”
    [char]0x2026  # ellipsis …
)

# Some phrase-level replacements
$phrases = @(
    ("Cr" + [char]0x00E9 + "er"),           # Créer
    ("Cr" + [char]0x00E9 + "ez"),           # Créez
    ("Cr" + [char]0x00E9),                  # Cré
    ("mise " + [char]0x00E0),               # mise à
    ("supprim" + [char]0x00E9 + "e"),       # supprimée
    ("calcul" + [char]0x00E9 + "e"),        # calculée
    ("D" + [char]0x00C9 + "crivez"),        # Décrivez
    ("Cr" + [char]0x00E9 + "er le jardin")  # Créer le jardin
)

# Build replacements hashtable: mojibakeKey (CP1252 decode of UTF8 bytes) -> correct Unicode string
$replacements = @{}

foreach ($c in $singleChars) {
    $correct = [string]$c
    $moj = $enc1252.GetString($utf8.GetBytes($correct))
    if (-not $replacements.ContainsKey($moj)) { $replacements[$moj] = $correct }
}
foreach ($p in $phrases) {
    $correct = $p
    $moj = $enc1252.GetString($utf8.GetBytes($correct))
    if (-not $replacements.ContainsKey($moj)) { $replacements[$moj] = $correct }
}

# Additional explicit replacements (common cases)
$extra = @{
    # key generated from UTF8 bytes of the correct string decoded as CP1252:
    # these mirror the intention of the original script but are generated safely
    # (no non-ASCII literal in source)
}
# merge extras if any (kept for future extension)
foreach ($k in $extra.Keys) { $replacements[$k] = $extra[$k] }

# Find .dart files
if (-not (Test-Path ".\lib")) {
    Write-Host "./lib not found — aborting."
    exit 1
}
$dartFiles = Get-ChildItem -Path .\lib -Filter *.dart -Recurse -File -ErrorAction SilentlyContinue
if ($null -eq $dartFiles -or $dartFiles.Count -eq 0) {
    Write-Host "No .dart files found under ./lib — aborting."
    exit 0
}

foreach ($file in $dartFiles) {
    $path = $file.FullName
    Write-Host "Processing: $path"
    # Backup original
    $rel = $path.Substring((Get-Location).Path.Length).TrimStart('\','/')
    $destBackup = Join-Path $backupDir $rel
    $destDir = Split-Path $destBackup -Parent
    if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
    Copy-Item -Path $path -Destination $destBackup -Force

    # Read as CP1252 (common mojibake source)
    $bytes = [System.IO.File]::ReadAllBytes($path)
    $text = $enc1252.GetString($bytes)

    # Apply replacements
    foreach ($k in $replacements.Keys) {
        $v = $replacements[$k]
        if ($text -like "*$k*") {
            $text = $text -replace [regex]::Escape($k), $v
        }
    }

    # Fix double-escaped single quotes (\\') -> \'
    $text = $text -replace "\\\\'", "\\'"

    # Normalize newlines to CRLF
    $text = $text -replace "`r?`n", "`r`n"

    # Write back as UTF8 with proper encoding (will write BOM as we use UTF8Encoding with BOM)
    $utf8WithBom = New-Object System.Text.UTF8Encoding $true
    [System.IO.File]::WriteAllText($path, $text, $utf8WithBom)
}

Write-Host "Done. All modified files were backed up to: $backupDir"
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1) Run your 'Yellow' BAT (Clean Run) or at least: flutter clean && flutter pub get"
Write-Host "  2) Run: flutter analyze"
Write-Host "If analyzer still shows parsing errors, paste the new analyzer output here and I will iterate."