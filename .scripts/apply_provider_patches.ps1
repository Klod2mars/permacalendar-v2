#! PowerShell: generate/apply provider family scaffolds (M008) - fixed Providers parsing
Param(
  [int]$Max = 5,
  [string[]]$Providers = @(),
  [switch]$DryRun,
  [switch]$RunTests,
  [switch]$PushBranch
)
$ErrorActionPreference = "Stop"

function Write-Log($msg) { Write-Host "$(Get-Date -Format u) - $msg" }

# --- Normalize Providers param: accept "a,b,c" or an array of strings
if ($Providers -and $Providers.Count -eq 1) {
  $single = $Providers[0]
  if ($single -match ',') {
    # split and trim
    $Providers = $single -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
    Write-Log "Providers parameter split into: $($Providers -join ', ')"
  }
}

# Repo root
$root = (Get-Location).Path

# Preconditions
if (-not (Test-Path ".ai-doc/patches")) {
  Write-Error ".ai-doc/patches not found. Run M006 scripts first."
  exit 1
}
if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
  Write-Error "Not a git repository (run from repo root)."
  exit 1
}

# Choose providers
if ($Providers.Length -eq 0) {
  if (Test-Path "provider_family_report.csv") {
    $rows = Import-Csv "provider_family_report.csv" | Where-Object { $_.is_family -eq "False" -and $_.defined_in -ne "" } | Sort-Object -Property usages -Descending
    $candidates = $rows | Select-Object -First $Max | ForEach-Object { $_.provider }
  } else {
    # fallback: list patches folder names
    $candidates = Get-ChildItem -Path ".ai-doc/patches" -Filter "*.md" | Select-Object -First $Max -ExpandProperty BaseName
  }
} else {
  $candidates = $Providers
}

Write-Log "Candidates to prepare:"
$candidates | ForEach-Object { Write-Host " - $_" }

# Ensure applied_patches dir
$appliedDir = ".ai-doc/applied_patches"
if (!(Test-Path $appliedDir)) { New-Item -ItemType Directory -Path $appliedDir | Out-Null }

foreach ($prov in $candidates) {
  Write-Log "Processing provider: $prov"

  # Find definitions across repo
  try {
    $defs = Select-String -Path ".\**\*.dart" -Pattern "final\s+$prov\s*=" -List -ErrorAction SilentlyContinue
  } catch {
    $defs = @()
  }

  if (-not $defs) {
    Write-Warning "No definition found for $prov - skipping."
    Add-Content -Path "$appliedDir/$prov.patch.md" -Value ("status: skipped`nreason: no_definition_found")
    continue
  }
  if ($defs.Count -ne 1) {
    Write-Warning "Multiple or zero definitions for $prov ($($defs.Count)) - SKIPPING to avoid collisions."
    $defs | ForEach-Object { Write-Host "  - $($_.Path):$($_.LineNumber)" }
    Add-Content -Path "$appliedDir/$prov.patch.md" -Value ("status: skipped`nreason: collision_or_multiple_defs`nfound:" + ($defs | ForEach-Object { "`n - $($_.Path):$($_.LineNumber)" }))
    continue
  }

  $def = $defs[0]
  $defFile = $def.Path
  $lineNo = $def.LineNumber
  Write-Log ("Found single definition in {0}:{1}" -f $defFile, $lineNo)

  # Extract snippet
  $content = Get-Content -Path $defFile -Raw -Encoding UTF8
  $lines = $content -split "`r?`n"
  $start = [Math]::Max(1, $lineNo - 4)
  $end = [Math]::Min($lines.Length, $lineNo + 8)
  $snippet = $lines[($start-1)..($end-1)]

  # Backup original file
  $bakFile = "$defFile.m008.bak"
  Copy-Item -Path $defFile -Destination $bakFile -Force
  Write-Log "Backup created: $bakFile"

  # Create branch
  $branch = "apply-provider/$prov-m008"
  if ($DryRun) {
    Write-Log "(DryRun) would create branch: $branch"
  } else {
    git checkout -b $branch
    Write-Log "Created branch $branch"
  }

  # Prepare scaffold: comment original snippet and add TODO conversion block
  $before = if ($start -gt 1) { $lines[0..($start-2)] } else { @() }
  $after  = if ($end -lt $lines.Length) { $lines[$end..($lines.Length-1)] } else { @() }

  $commentedOriginal = $snippet | ForEach-Object { "// $_" }
  $conversionBlock = @(
    "// BEGIN_M008_CONVERSION $prov",
    "// TODO: Convert `$prov` to a `.family` provider (NotifierProvider.family / Provider.family / FutureProvider.family).",
    "// Suggested outline (replace <ParamType> and adapt generics):",
    "// final $prov = <ProviderType>.family<<ParamType>, <State>>((ref, param) {",
    "//   // 1) move provider logic here, replacing implicit scope with param",
    "//   // 2) thread `param` through downstream ref.watch/ref.read calls",
    "//   // 3) update keys/repositories/state accordingly",
    "// });",
    "// The original definition is kept below (commented). Remove/comment out after conversion.",
    ""
  ) + $commentedOriginal + @(
    "",
    "// END_M008_CONVERSION $prov"
  )

  $newContentLines = @()
  $newContentLines += $before
  $newContentLines += $conversionBlock
  $newContentLines += $after
  $newContent = $newContentLines -join "`n"

  if ($DryRun) {
    Write-Log "(DryRun) Would write scaffold to $defFile (backup at $bakFile)."
  } else {
    Set-Content -Path $defFile -Value $newContent -Encoding UTF8
    Write-Log "Scaffold written into $defFile"
  }

  # Commit prepared changes
  if ($DryRun) {
    Write-Log "(DryRun) Skipping git add/commit for $defFile"
  } else {
    git add $defFile $bakFile
    git commit -m "M008: scaffold .family conversion for $prov (manual edits required)"
    Write-Log "Committed scaffold for $prov on $branch"
  }

  # Optionally run build_runner & tests for quick validation
  if ($RunTests) {
    if ($DryRun) {
      Write-Log "(DryRun) Would run build_runner and flutter test"
    } else {
      Write-Log "Running build_runner..."
      & flutter pub run build_runner build --delete-conflicting-outputs
      Write-Log "Running flutter test (full suite; consider running targeted tests)..."
      & flutter test
      if ($LASTEXITCODE -ne 0) {
        Write-Warning "Some tests failed - check logs."
      }
    }
  }

  # Push branch and create backup tag if requested
  if ($PushBranch -and -not $DryRun) {
    # backup tag
    $sha = (git rev-parse --short HEAD).Trim()
    $backupTag = "backup-remote-main-$sha"
    git tag -f $backupTag
    git push origin $backupTag
    Write-Log "Pushed backup tag $backupTag to origin"

    # push branch
    git push origin "HEAD:refs/heads/$branch"
    Write-Log "Pushed branch $branch to origin"
  } elseif ($PushBranch -and $DryRun) {
    Write-Log "(DryRun) Would create backup tag and push branch $branch"
  }

  # Create a small applied_patches status file
  $appliedFile = "$appliedDir/$prov.patch.md"
  $statusContentLines = @(
    '---',
    "provider: $prov",
    "prepared_in_file: $defFile",
    "prepared_line: $lineNo",
    "backup_file: $bakFile",
    "branch: $branch",
    'status: prepared',
    'notes: "Scaffold inserted. Manual conversion to .family required. See TODO block in file."',
    '---'
  )
  $statusContent = $statusContentLines -join "`n"
  Set-Content -Path $appliedFile -Value $statusContent -Encoding UTF8
  Write-Log "Wrote applied patch status: $appliedFile"

  # Return to main if not in dryrun and not staying in branch
  if (-not $DryRun) {
    git checkout main
  }
}

Write-Log "M008 script finished."

