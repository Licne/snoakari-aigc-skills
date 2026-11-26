$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$pluginsDir = Join-Path $env:USERPROFILE ".gemini\config\plugins"
$linkPath = Join-Path $pluginsDir "snoakari-aigc-skills"

New-Item -ItemType Directory -Force -Path $pluginsDir | Out-Null

if (Test-Path $linkPath) {
    $item = Get-Item $linkPath -Force
    if ($item.LinkType -eq "Junction" -or $item.LinkType -eq "SymbolicLink") {
        cmd /c rmdir "$linkPath"
    } else {
        throw "Path already exists and is not a link: $linkPath"
    }
}

cmd /c mklink /J "$linkPath" "$repoRoot"
Write-Host "Linked Antigravity plugin: $linkPath -> $repoRoot" -ForegroundColor Green
