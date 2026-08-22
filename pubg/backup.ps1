[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$source = Join-Path $env:LOCALAPPDATA 'TslGame\Saved\Config\WindowsNoEditor\GameUserSettings.ini'
$destination = Join-Path $PSScriptRoot 'config\GameUserSettings.ini'

if (-not (Test-Path -LiteralPath $source)) {
    throw "Configuração do PUBG não encontrada em: $source"
}

$destinationDirectory = Split-Path -Parent $destination
if (-not (Test-Path -LiteralPath $destinationDirectory)) {
    New-Item -ItemType Directory -Path $destinationDirectory | Out-Null
}

$lines = [System.IO.File]::ReadAllLines($source)
$safeLines = @(
    $lines | Where-Object { $_ -notmatch '^\s*OutgameUserDatas\s*=' }
)

$utf8WithoutBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllLines($destination, $safeLines, $utf8WithoutBom)

$removedCount = $lines.Count - $safeLines.Count
$hash = (Get-FileHash -LiteralPath $destination -Algorithm SHA256).Hash

Write-Host "Backup atualizado: $destination"
Write-Host "Campos privados removidos: $removedCount"
Write-Host "SHA-256: $hash"
