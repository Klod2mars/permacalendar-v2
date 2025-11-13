<#
S'assure que analysis_options.yaml contient l'exclusion pour tools/backup_**/**
Fait un backup horodaté avant modification.
Usage: .\tools\ensure_analysis_exclude.ps1
#>
param()

$path = "analysis_options.yaml"
if (-not (Test-Path $path)) {
    $content = "analyzer:`n  exclude:`n    - tools/backup_**/**`n"
    $content = $content -replace "`n","`r`n"
    Set-Content -Path $path -Value $content -Encoding UTF8
    Write-Host "Created $path with analyzer.exclude"
    exit 0
}

$allLines = Get-Content $path -Encoding UTF8
if (($allLines -join "`n") -match "tools/backup_") {
    Write-Host "analysis_options.yaml already excludes tools/backup_*"
    exit 0
}

Copy-Item $path "$path.bak_$(Get-Date -Format s)"

# Cherche la ligne 'analyzer:' si elle existe
$foundAnalyzer = $null
for ($i=0; $i -lt $allLines.Length; $i++) {
    if ($allLines[$i] -match '^\s*analyzer\s*:') { $foundAnalyzer = $i; break }
}

if ($foundAnalyzer -ne $null) {
    # position d'insertion après la block analyzer (jusqu'à la prochaine clé top-level)
    $insertAt = $foundAnalyzer + 1
    while ($insertAt -lt $allLines.Length -and $allLines[$insertAt] -match '^\s') { $insertAt++ }
    $before = $allLines[0..($insertAt-1)]
    if ($insertAt -lt $allLines.Length) {
        $after = $allLines[$insertAt..($allLines.Length-1)]
    } else {
        $after = @()
    }
    $inject = @("  exclude:","    - tools/backup_**/**")
    $newLines = $before + $inject + $after
    $newLines | Set-Content -Path $path -Encoding UTF8
    Write-Host "Inserted exclude under existing analyzer:"
} else {
    $append = @("","analyzer:","  exclude:","    - tools/backup_**/**")
    ($allLines + $append) | Set-Content -Path $path -Encoding UTF8
    Write-Host "Appended analyzer.exclude to end of file"
}
