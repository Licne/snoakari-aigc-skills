$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$parentDir = (Split-Path $repoRoot -Parent) -replace "\\", "/"
$repoName = Split-Path $repoRoot -Leaf

$configDir = Join-Path $env:USERPROFILE ".gemini\config"
$pluginsJsonPath = Join-Path $configDir "plugins.json"
New-Item -ItemType Directory -Force -Path $configDir | Out-Null

# Clean up legacy junction if present
$legacyLink = Join-Path $configDir "plugins\$repoName"
if (Test-Path $legacyLink) {
    $item = Get-Item $legacyLink -Force
    if ($item.LinkType -eq "Junction" -or $item.LinkType -eq "SymbolicLink") {
        cmd /c rmdir "$legacyLink" | Out-Null
    }
}

$entries = @()
if (Test-Path $pluginsJsonPath) {
    $existing = Get-Content $pluginsJsonPath -Raw | ConvertFrom-Json
    if ($existing.entries) {
        $entries = @($existing.entries | Where-Object {
            -not ($_.path -eq $parentDir -and $_.include_only -contains $repoName)
        })
    }
}

$entries += [PSCustomObject]@{
    path         = $parentDir
    include_only = @($repoName)
}

$payload = [PSCustomObject]@{ entries = $entries }
$payload | ConvertTo-Json -Depth 5 | Set-Content -Path $pluginsJsonPath -Encoding UTF8

Write-Host "Registered Antigravity plugin in $pluginsJsonPath -> $parentDir/$repoName" -ForegroundColor Green
