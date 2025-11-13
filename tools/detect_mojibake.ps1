<#
Detecte BOM et motifs de mojibake dans les fichiers courants (.dart/.yaml/.md/.txt/.ps1)
Génère tools/mojibake_report.txt
Usage: .\tools\detect_mojibake.ps1
#>
param(
    [string[]]$Paths = @("lib","tools"),
    [string]$Report = "tools/mojibake_report.txt"
)

$patterns = @("ï»¿", "\\'", "Ã©", "Ã¨", "Ãª", "Ã€", "Ã‚", "Ã¶", "Unexpected text ';'")
$exts = @("*.dart","*.yaml","*.yml","*.md","*.txt","*.ps1")

$reportLines = @()
$reportLines += "Mojibake detection report - $(Get-Date -Format s)"
$reportLines += ""

foreach ($p in $Paths) {
    if (-not (Test-Path $p)) { continue }
    Get-ChildItem -Path $p -Recurse -Include $exts -File -ErrorAction SilentlyContinue | ForEach-Object {
        $path = $_.FullName
        $hasBom = $false
        try {
            $bytes = [System.IO.File]::ReadAllBytes($path)
            if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) { $hasBom = $true }
        } catch {}
        $content = ""
        try {
            $content = Get-Content -Raw -Encoding UTF8 -ErrorAction SilentlyContinue -Path $path
        } catch {
            try { $content = Get-Content -Raw -Encoding Default -ErrorAction SilentlyContinue -Path $path } catch {}
        }
        $found = @()
        foreach ($pat in $patterns) {
            if ($content -and ($content -match [regex]::Escape($pat))) { $found += $pat }
        }
        if ($hasBom -or $found.Count -gt 0) {
            $reportLines += "FILE: $path"
            if ($hasBom) { $reportLines += "  - BOM: YES" } else { $reportLines += "  - BOM: NO" }
            if ($found.Count -gt 0) { $reportLines += "  - Matches: " + ($found -join ", ") } else { $reportLines += "  - Matches: none" }
            $reportLines += ""
        }
    }
}

$reportLines += "End of report"
# assure dossier tools
if (-not (Test-Path "tools")) { New-Item -ItemType Directory -Path "tools" | Out-Null }
$reportLines | Set-Content -Path $Report -Encoding UTF8
Write-Host "Report written to $Report"
