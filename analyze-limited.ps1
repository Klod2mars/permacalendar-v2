function analyze-limited {
  [CmdletBinding()]
  param(
    [string[]]$Paths = @(
      "lib/shared/widgets/organic_dashboard.dart",
      "lib/features/home/widgets/invisible_garden_zone.dart",
      "lib/shared/widgets",
      "lib/features/home/widgets"
    ),
    [int]$MaxResults = 50,
    [switch]$OnlyErrors,
    [switch]$OnlyWarnings,
    [switch]$ShowAll,
    [switch]$UseFlutter,
    [switch]$GitChanged
  )

  try {
    $repo = (Resolve-Path ".").Path
  } catch {
    Write-Error "Impossible de résoudre le répertoire courant."
    return 1
  }

  if ($GitChanged) {
    $changed = & git diff --name-only origin/main 2>$null
    if (-not $changed) {
      Write-Host "Aucun fichier modifié trouvé par rapport à origin/main." -ForegroundColor Yellow
      return 0
    }
    $pathsList = $changed -split "`r?`n" | Where-Object { $_ -and $_ -match '\.dart$' }
    if ($pathsList.Count -eq 0) {
      Write-Host "Aucun fichier .dart modifié." -ForegroundColor Yellow
      return 0
    }
    $Paths = $pathsList
  }

  $realPaths = @()
  foreach ($p in $Paths) {
    $full = Join-Path $repo $p
    if (Test-Path $full) {
      if ((Get-Item $full).PSIsContainer) {
        $realPaths += Get-ChildItem -Path $full -Recurse -Filter *.dart | Select-Object -ExpandProperty FullName
      } else {
        $realPaths += $full
      }
    } else {
      $matches = Get-ChildItem -Path $repo -Recurse -Filter (Split-Path $p -Leaf) -ErrorAction SilentlyContinue |
                 Where-Object { $_.FullName -like "*$p*" } | Select-Object -ExpandProperty FullName -ErrorAction SilentlyContinue
      if ($matches) { $realPaths += $matches } else {
        $realPaths += $p
      }
    }
  }
  $realPaths = $realPaths | Select-Object -Unique
  if ($realPaths.Count -eq 0) {
    Write-Warning "Aucun chemin Dart trouvé pour l'analyse. Passe des paths via -Paths ou utilisez -GitChanged."
    return 0
  }

  $dartCmd = (Get-Command dart.exe -ErrorAction SilentlyContinue) -or (Get-Command dart -ErrorAction SilentlyContinue)
  $flutterCmd = (Get-Command flutter.exe -ErrorAction SilentlyContinue) -or (Get-Command flutter -ErrorAction SilentlyContinue)

  if ($UseFlutter -and $flutterCmd) {
    $analyzer = "flutter"
    $args = @("analyze") + $realPaths
  } elseif ($dartCmd) {
    $analyzer = "dart"
    $args = @("analyze") + $realPaths
  } elseif ($flutterCmd) {
    $analyzer = "flutter"
    $args = @("analyze") + $realPaths
  } else {
    Write-Error "Aucun 'dart' ni 'flutter' trouvé dans le PATH."
    return 1
  }

  Write-Host "Running: $analyzer $($args -join ' ')" -ForegroundColor Cyan

  $psi = New-Object System.Diagnostics.ProcessStartInfo
  $psi.FileName = $analyzer
  $psi.Arguments = $args -join " "
  $psi.RedirectStandardOutput = $true
  $psi.RedirectStandardError  = $true
  $psi.UseShellExecute = $false
  $psi.CreateNoWindow = $true

  $proc = New-Object System.Diagnostics.Process
  $proc.StartInfo = $psi
  $proc.Start() | Out-Null
  $stdout = $proc.StandardOutput.ReadToEnd()
  $stderr = $proc.StandardError.ReadToEnd()
  $proc.WaitForExit()

  $lines = @()
  if ($stdout) { $lines += $stdout -split "`r?`n" }
  if ($stderr) { $lines += $stderr -split "`r?`n" }

  if ($lines.Count -eq 0) {
    Write-Host "Aucune sortie de l'analyseur." -ForegroundColor Yellow
    return 0
  }

  if ($ShowAll) {
    $lines | ForEach-Object { Write-Host $_ }
    return 0
  }

  $errors = $lines | Where-Object { $_ -match '\berror\s*•' }
  $warnings = $lines | Where-Object { $_ -match '\bwarning\s*•' }
  $infos = $lines | Where-Object { $_ -match '\binfo\s*•' }

  if ($errors.Count -eq 0) {
    $errors = $lines | Where-Object { $_ -match '\b(Error|ERROR|error:)\b' }
  }
  if ($warnings.Count -eq 0) {
    $warnings = $lines | Where-Object { $_ -match '\b(Warning|WARNING|warning:)\b' }
  }

  if ($OnlyErrors) {
    if ($errors.Count -eq 0) { Write-Host "Aucun error trouvé." -ForegroundColor Green }
    ($errors | Select-Object -First $MaxResults) | ForEach-Object { Write-Host $_ }
  } elseif ($OnlyWarnings) {
    if ($warnings.Count -eq 0) { Write-Host "Aucun warning trouvé." -ForegroundColor Green }
    ($warnings | Select-Object -First $MaxResults) | ForEach-Object { Write-Host $_ }
  } else {
    if ($errors.Count -gt 0) {
      Write-Host "`n=== ERRORS ===" -ForegroundColor Red
      ($errors | Select-Object -First $MaxResults) | ForEach-Object { Write-Host $_ }
      if ($errors.Count -gt $MaxResults) { Write-Host "...and $($errors.Count - $MaxResults) more errors" -ForegroundColor Gray }
    } else {
      Write-Host "`n(no errors)" -ForegroundColor Green
    }

    if ($warnings.Count -gt 0) {
      Write-Host "`n=== WARNINGS ===" -ForegroundColor Yellow
      ($warnings | Select-Object -First $MaxResults) | ForEach-Object { Write-Host $_ }
      if ($warnings.Count -gt $MaxResults) { Write-Host "...and $($warnings.Count - $MaxResults) more warnings" -ForegroundColor Gray }
    } else {
      Write-Host "`n(no warnings)" -ForegroundColor Green
    }
  }

  $errCount = $errors.Count
  $warCount = $warnings.Count
  $infoCount = $infos.Count
  Write-Host "`nSummary: Errors=$errCount  Warnings=$warCount  Infos=$infoCount" -ForegroundColor Cyan

  if ($errCount -gt 0 -and -not $OnlyErrors) {
    Write-Host "Tip: run 'analyze-limited -OnlyErrors' or 'analyze-limited -ShowAll' for more details." -ForegroundColor Gray
  }

  return 0
}
