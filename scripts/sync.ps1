# sync.ps1
# CodeBuddy Skills Sync
# Creates directory junctions from skills-repo/skills/ to ~/.codebuddy/skills/

$ErrorActionPreference = "Stop"

$RepoSkillsDir = "$PSScriptRoot\..\skills"
$CodeBuddySkillsDir = "$env:USERPROFILE\.codebuddy\skills"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  CodeBuddy Skills Sync" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Source : $RepoSkillsDir" -ForegroundColor Gray
Write-Host "Target : $CodeBuddySkillsDir" -ForegroundColor Gray
Write-Host ""

if (-not (Test-Path $RepoSkillsDir)) {
    Write-Host "[ERROR] Source not found: $RepoSkillsDir" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $CodeBuddySkillsDir)) {
    New-Item -ItemType Directory -Path $CodeBuddySkillsDir -Force | Out-Null
    Write-Host "[OK] Created: $CodeBuddySkillsDir" -ForegroundColor Green
}

$SkillDirs = Get-ChildItem -Path $RepoSkillsDir -Directory
$synced = 0
$skipped = 0

foreach ($SkillDir in $SkillDirs) {
    $SkillName = $SkillDir.Name
    $LinkPath = Join-Path $CodeBuddySkillsDir $SkillName

    if (Test-Path $LinkPath) {
        $Item = Get-Item $LinkPath -ErrorAction SilentlyContinue
        if ($Item -and ($Item.Attributes -band [System.IO.FileAttributes]::ReparsePoint)) {
            Write-Host "[SKIP] $SkillName - already linked" -ForegroundColor Gray
            $skipped++
            continue
        } else {
            Write-Host "[WARN] $SkillName - exists, skipping" -ForegroundColor Yellow
            $skipped++
            continue
        }
    }

    try {
        cmd /c "mklink /J `"$LinkPath`" `"$($SkillDir.FullName)`"" 2>&1 | Out-Null
        Write-Host "[OK] $SkillName" -ForegroundColor Green
        $synced++
    } catch {
        Write-Host "[FAIL] $SkillName - try running as Administrator" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Done: $synced synced, $skipped skipped" -ForegroundColor White
Write-Host "========================================" -ForegroundColor Cyan
