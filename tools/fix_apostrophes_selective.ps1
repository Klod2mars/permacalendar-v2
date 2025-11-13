# ============================================================
#   fix_apostrophes_selective.ps1
#   Repair only mojibake (\\') inside Dart string literals
#   Backup included - safe selective patch
# ============================================================

Write-Host "Scanning Dart files for mojibake (\\')..."

# 1) Backup
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupDir = "tools/backup_apostrophes_$timestamp"

New-Item -ItemType Directory -Path $backupDir | Out-Null
Copy-Item -Path "lib" -Destination "$backupDir/lib" -Recurse -Force

Write-Host "Backup created at: $backupDir"

# 2) Line fixer
function Fix-Line {
    param (
        [string]$line
    )

    # Replace \"' with a plain apostrophe
    if ($line -match "\\\\'") {
        $fixed = $line -replace "\\\\'", "'"
        return $fixed
    }

    return $line
}

# 3) Process all .dart files
$dartFiles = Get-ChildItem -Path "lib" -Recurse -Filter *.dart

foreach ($file in $dartFiles) {

    $originalContent = Get-Content $file.FullName -Raw -Encoding UTF8
    $lines = $originalContent -split "`n"

    $modified = $false
    $newLines = @()

    foreach ($line in $lines) {
        $fixedLine = Fix-Line -line $line
        if ($fixedLine -ne $line) { $modified = $true }
        $newLines += $fixedLine
    }

    if (-not $modified) {
        continue
    }

    $out = $newLines -join "`r`n"
    Set-Content -Path $file.FullName -Value $out -Encoding UTF8

    Write-Host "Fixed: $($file.FullName)"
}

Write-Host ""
Write-Host "Done."
Write-Host "Run: flutter clean ; flutter pub get ; flutter analyze"
Write-Host ""
