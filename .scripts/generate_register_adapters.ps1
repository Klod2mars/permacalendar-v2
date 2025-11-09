$ErrorActionPreference = 'Stop'

$root = (Get-Location).Path
$packageName = 'permacalendar'

Write-Host 'Scanning for *.g.dart files...'
$dartToolPattern = [regex]'[\\/]\.dart_tool[\\/]'
$gFiles = Get-ChildItem -Path $root -Recurse -Filter '*.g.dart' |
  Where-Object { -not $dartToolPattern.IsMatch($_.FullName) }

$adapterPattern = [regex]'class\s+(?<adapter>[A-Za-z0-9_]+Adapter)\s+extends\s+TypeAdapter'
$adapters = @()

foreach ($gf in $gFiles) {
  $content = Get-Content -Raw -LiteralPath $gf.FullName
  $matches = $adapterPattern.Matches($content)
  if ($matches.Count -eq 0) { continue }

  foreach ($match in $matches) {
    $adapterName = $match.Groups['adapter'].Value
    $typeSearch = $content.Substring($match.Index)
    $typeIdMatch = [regex]::Match($typeSearch, 'typeId\s*=\s*(\d+);')
    $typeId = if ($typeIdMatch.Success) { $typeIdMatch.Groups[1].Value } else { '' }

    $src = $gf.FullName -replace '\.g\.dart$','.dart'
    $relativePath = $src.Substring($root.Length + 1)
    $relativeUnix = $relativePath -replace '\\','/'

    if ($relativeUnix.StartsWith('lib/')) {
      $importPath = "package:$packageName/" + $relativeUnix.Substring(4)
    } else {
      $importPath = $relativeUnix
    }

    $adapters += [PSCustomObject]@{
      adapter = $adapterName
      typeId  = $typeId
      import  = $importPath
    }
  }
}

if ($adapters.Count -eq 0) {
  Write-Host 'No adapters found. Exiting.'
  exit 0
}

$adapters = $adapters | Sort-Object adapter -Unique
$imports = $adapters | Select-Object -ExpandProperty import -Unique | Sort-Object

$registerPath = Join-Path $root 'test\helpers\register_hive_adapters.dart'
$registerDir = Split-Path $registerPath -Parent
if (-not (Test-Path $registerDir)) {
  New-Item -ItemType Directory -Path $registerDir | Out-Null
}

$builder = [System.Text.StringBuilder]::new()
$builder.AppendLine('/// GENERATED FILE - DO NOT EDIT') | Out-Null
$builder.AppendLine('// Run .scripts/generate_register_adapters.ps1 to regenerate.') | Out-Null
$builder.AppendLine("import 'package:hive/hive.dart';") | Out-Null
foreach ($imp in $imports) {
  $builder.AppendLine("import '$imp';") | Out-Null
}
$builder.AppendLine('') | Out-Null
$builder.AppendLine('void registerAllHiveAdapters() {') | Out-Null
$builder.AppendLine('  try {') | Out-Null

foreach ($entry in $adapters) {
  $adapterName = $entry.adapter
  $typeId = $entry.typeId

  if ($typeId -ne '') {
    $builder.AppendLine("    if (!Hive.isAdapterRegistered($typeId)) { Hive.registerAdapter($adapterName()); }") | Out-Null
  } else {
    $builder.AppendLine("    try { Hive.registerAdapter($adapterName()); } catch (_) {}") | Out-Null
  }
}

$builder.AppendLine('  } catch (e) {') | Out-Null
$builder.AppendLine('    // ignore errors during adapter registration in test bootstrap') | Out-Null
$builder.AppendLine('  }') | Out-Null
$builder.AppendLine('}') | Out-Null

$builder.ToString() | Set-Content -Path $registerPath -Encoding UTF8
Write-Host "Wrote $registerPath with $($adapters.Count) adapters."

