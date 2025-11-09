# scripts/run_orphan_analysis.ps1
# Script PowerShell pour exécuter l'analyse des orphelins sur Windows

param(
    [string]$OutputDir = "cursor_orphan_results",
    [string]$MessageIdx = "12"
)

Write-Host "🔍 Analyse des orphelins Dart/Flutter (Riverpod 3)" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Vérifier que nous sommes dans le bon répertoire
if (-not (Test-Path "pubspec.yaml")) {
    Write-Host "❌ Erreur: pubspec.yaml non trouvé. Exécutez ce script depuis la racine du projet." -ForegroundColor Red
    exit 1
}

# Vérifier que Dart est disponible
try {
    $dartVersion = dart --version 2>&1
    Write-Host "✓ Dart trouvé: $dartVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Erreur: Dart n'est pas installé ou n'est pas dans le PATH." -ForegroundColor Red
    exit 1
}

# Créer le dossier de sortie
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
    Write-Host "✓ Dossier de sortie créé: $OutputDir" -ForegroundColor Green
}

Write-Host ""
Write-Host "🚀 Lancement de l'analyse..." -ForegroundColor Yellow
Write-Host ""

# Exécuter le script Dart
try {
    dart run tools/orphan_analyzer.dart $OutputDir $MessageIdx
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✅ Analyse terminée avec succès!" -ForegroundColor Green
        Write-Host ""
        Write-Host "📊 Résultats disponibles dans: $OutputDir" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Fichiers générés:" -ForegroundColor Yellow
        Write-Host "  - orphan_report.md (rapport principal)" -ForegroundColor White
        Write-Host "  - unreferenced_files.txt (fichiers non référencés)" -ForegroundColor White
        Write-Host "  - orphan_providers.txt (providers orphelins)" -ForegroundColor White
        Write-Host "  - unused_symbols.txt (symboles non utilisés)" -ForegroundColor White
        Write-Host ""
        
        # Ouvrir le dossier de résultats (optionnel)
        $openFolder = Read-Host "Voulez-vous ouvrir le dossier de résultats? (O/N)"
        if ($openFolder -eq "O" -or $openFolder -eq "o") {
            Start-Process explorer.exe -ArgumentList $OutputDir
        }
    } else {
        Write-Host "❌ Erreur lors de l'exécution de l'analyse." -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ Erreur: $_" -ForegroundColor Red
    exit 1
}


