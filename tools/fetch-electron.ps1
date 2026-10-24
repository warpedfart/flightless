# downloads the Electron the client runs on (11.5.0, the last with Flash
# support) from Electron's GitHub releases, checks it against their published
# checksums and unpacks it into electron-win\ for run.bat.
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$version = "11.5.0"
$here = Split-Path -Parent $PSScriptRoot
$dir = Join-Path $here "electron-win"
$zip = "electron-v$version-win32-x64.zip"
$base = "https://github.com/electron/electron/releases/download/v$version"

if ((Test-Path "$dir\version") -and ((Get-Content "$dir\version").Trim() -eq $version)) {
    Write-Host "electron-win\ already has Electron $version"
    exit 0
}

$work = Join-Path ([IO.Path]::GetTempPath()) ([IO.Path]::GetRandomFileName())
New-Item -ItemType Directory $work | Out-Null
try {
    Write-Host "downloading $zip"
    Invoke-WebRequest "$base/SHASUMS256.txt" -OutFile "$work\SHASUMS256.txt"
    Invoke-WebRequest "$base/$zip" -OutFile "$work\$zip"
    $line = Get-Content "$work\SHASUMS256.txt" | Where-Object { $_ -match [regex]::Escape(" *$zip") }
    $want = ($line -split " ")[0]
    $got = (Get-FileHash "$work\$zip" -Algorithm SHA256).Hash
    if ($got -ne $want) { throw "checksum mismatch for $zip" }
    if (Test-Path $dir) { Remove-Item $dir -Recurse -Force }
    Expand-Archive "$work\$zip" -DestinationPath $dir
    Write-Host "Electron $version is in electron-win\"
} finally {
    Remove-Item $work -Recurse -Force -ErrorAction SilentlyContinue
}
