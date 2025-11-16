# safe-fix-garden_bed_fallback.ps1
$file = 'lib/features/garden_bed/presentation/widgets/garden_bed_card.dart'
if (-not (Test-Path $file)) { Write-Host "Fichier introuvable : $file" -ForegroundColor Red; exit 1 }

# Sauvegarde
$bak = $file + '.bak_' + (Get-Date -Format 'yyyyMMdd_HHmmss')
Copy-Item -Path $file -Destination $bak -ErrorAction Stop
Write-Host "Sauvegarde créée -> $bak"

# Lire le fichier
$content = Get-Content -Raw -Encoding UTF8 $file
$new = $content

# Remplacer la déclaration fallbackImage par une version + helper _buildFallbackImage
$patternDecl = "final fallbackImage = 'assets/images/legumes/default.png';"
$replacementDecl = @"
final String fallbackImage = 'assets/images/legumes/default.png';

  Widget _buildFallbackImage(BuildContext ctx, {double width = 64, double height = 64, BoxFit fit = BoxFit.cover}) {
    return Image.asset(
      fallbackImage,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        // Ultimate fallback: simple icon so we never throw at runtime when asset is missing.
        return Container(
          width: width,
          height: height,
          color: Colors.grey.shade200,
          alignment: Alignment.center,
          child: Icon(Icons.eco, size: (width < height ? width : height) * 0.6, color: Theme.of(context).colorScheme.primary),
        );
      },
    );
  }
"@ -replace "`n", [Environment]::NewLine

if ($new -notmatch [regex]::Escape($patternDecl)) {
  Write-Host "La déclaration fallback attendue n'a pas été trouvée. Vérifie le fichier manuellement." -ForegroundColor Yellow
} else {
  $new = $new -replace [regex]::Escape($patternDecl), [regex]::Escape($replacementDecl)
}

# Remplacer l'errorBuilder qui renvoyait Image.asset(fallbackImage, ...) par le helper
$patternErrorBuilder = 'errorBuilder:\s*\(\s*_,\s*__\s*,\s*___\s*\)\s*=>\s*Image\.asset\(\s*fallbackImage[\s\S]*?\),'
$replacementErrorBuilder = 'errorBuilder: (_, __, ___) => _buildFallbackImage(context, width: 64, height: 64, fit: BoxFit.cover),'

$new = [System.Text.RegularExpressions.Regex]::Replace($new, $patternErrorBuilder, $replacementErrorBuilder, [System.Text.RegularExpressions.RegexOptions]::Singleline)

# Remplacer l'usage direct Image.asset(fallbackImage, ...) (else branch) par le helper
$patternDirectFallback = 'Image\.asset\(\s*fallbackImage\s*,\s*width:\s*64\s*,\s*height:\s*64\s*,\s*fit:\s*BoxFit\.cover\s*\)'
$replacementDirectFallback = '_buildFallbackImage(context, width: 64, height: 64, fit: BoxFit.cover)'

$new = $new -replace $patternDirectFallback, $replacementDirectFallback

# Normaliser retours de ligne et écrire
$new = [System.Text.RegularExpressions.Regex]::Replace($new, "\r?\n", [Environment]::NewLine)
if ($new -ne $content) {
  Set-Content -Path $file -Value $new -Encoding UTF8
  Write-Host "Fichier mis à jour : $file" -ForegroundColor Green
  if (Get-Command git -ErrorAction SilentlyContinue) { git --no-pager diff -- $file } else { Write-Host "(git not found)" }
} else {
  Write-Host "Aucune modification détectée." -ForegroundColor Yellow
}
