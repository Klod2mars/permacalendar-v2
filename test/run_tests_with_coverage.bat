@echo off
REM Script pour exécuter les tests avec couverture de code
REM Windows batch script

echo ========================================
echo Running Flutter tests with coverage
echo ========================================

flutter test --coverage

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo Tests completed successfully!
    echo Coverage report: coverage/lcov.info
    echo ========================================
    
    REM Optionnel: Générer un rapport HTML
    REM Nécessite: dart pub global activate coverage
    REM genhtml coverage/lcov.info -o coverage/html
    
) else (
    echo.
    echo ========================================
    echo Some tests failed! Check output above.
    echo ========================================
    exit /b 1
)
