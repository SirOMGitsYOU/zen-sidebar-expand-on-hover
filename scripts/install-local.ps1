param(
    [int]$ProfileIndex = 0,
    [switch]$AllProfiles
)

# Installs this fork into Zen. Uses file:// URLs so "Check for updates" won't
# replace your files with the official theme-store build (which lacks local changes).

$ErrorActionPreference = "Stop"

$ModId = "bd92a9a0-1c00-4187-a66e-94c389fa5a59"
$RepoRoot = Split-Path $PSScriptRoot -Parent
$ChromeCss = Join-Path $RepoRoot "chrome.css"
$Preferences = Join-Path $RepoRoot "preferences.json"
$Readme = Join-Path $RepoRoot "README.md"

foreach ($path in @($ChromeCss, $Preferences, $Readme)) {
    if (-not (Test-Path $path)) {
        Write-Error "Missing required file: $path"
    }
}

function Install-ToProfile([string]$ProfilePath) {
    $modDir = Join-Path $ProfilePath "chrome\zen-themes\$ModId"
    New-Item -ItemType Directory -Path $modDir -Force | Out-Null

    Copy-Item $ChromeCss (Join-Path $modDir "chrome.css") -Force
    Copy-Item $Preferences (Join-Path $modDir "preferences.json") -Force
    Copy-Item $Readme (Join-Path $modDir "readme.md") -Force

    function To-FileUri([string]$Path) {
        $resolved = (Resolve-Path $Path).Path -replace "\\", "/"
        return "file:///$resolved"
    }

    $theme = [PSCustomObject]@{
        id          = $ModId
        name        = "Sidebar Expand on Hover"
        description = "Local fork — expand sidebar on hover"
        homepage    = "https://github.com/SirOMGitsYOU/zen-sidebar-expand-on-hover"
        style       = To-FileUri (Join-Path $modDir "chrome.css")
        readme      = To-FileUri (Join-Path $modDir "readme.md")
        preferences = To-FileUri (Join-Path $modDir "preferences.json")
        image       = "https://raw.githubusercontent.com/StormAnon/zen-sidebar-expand-on-hover/main/screenshot.png"
        author      = "SirOMGitsYOU"
        version     = "1.0.2-local"
        tags        = @()
        createdAt   = "2025-07-16"
        updatedAt   = (Get-Date -Format "yyyy-MM-dd")
        enabled     = $true
    }

    $zenThemesJson = Join-Path $ProfilePath "zen-themes.json"
    $allMods = [ordered]@{}
    if (Test-Path $zenThemesJson) {
        $existing = Get-Content $zenThemesJson -Raw | ConvertFrom-Json
        if ($null -ne $existing) {
            $existing.PSObject.Properties | ForEach-Object { $allMods[$_.Name] = $_.Value }
        }
    }
    $allMods[$ModId] = $theme
    ($allMods | ConvertTo-Json -Depth 10) | Set-Content $zenThemesJson -Encoding UTF8

    Write-Host "Installed to $modDir" -ForegroundColor Green
}

$ZenProfiles = Join-Path $env:APPDATA "zen\Profiles"
$profileDirs = @(Get-ChildItem $ZenProfiles -Directory)

if ($AllProfiles) {
    foreach ($p in $profileDirs) { Install-ToProfile $p.FullName }
    exit 0
}

Write-Host "Zen profiles:" -ForegroundColor Cyan
$i = 0
foreach ($p in $profileDirs) {
    $i++
    Write-Host "  [$i] $($p.Name)"
}

if ($ProfileIndex -lt 1 -or $ProfileIndex -gt $profileDirs.Count) {
    $choice = Read-Host "Install to profile number (default 1)"
    if ([string]::IsNullOrWhiteSpace($choice)) { $choice = 1 }
    $ProfileIndex = [int]$choice
}

Install-ToProfile $profileDirs[$ProfileIndex - 1].FullName

Write-Host ""
Write-Host "Restart Zen, or disable then enable this mod." -ForegroundColor Yellow
Write-Host "Version should show v1.0.2-local and include the pinned-tabs buffer (px) field."
