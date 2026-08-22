[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$source = Join-Path $PSScriptRoot 'config\GameUserSettings.ini'
$destinationDirectory = Join-Path $env:LOCALAPPDATA 'TslGame\Saved\Config\WindowsNoEditor'
$destination = Join-Path $destinationDirectory 'GameUserSettings.ini'

$pubgProcesses = Get-Process -Name 'TslGame', 'TslGame_BE', 'ExecPubg' -ErrorAction SilentlyContinue
if ($pubgProcesses) {
    throw 'Feche o PUBG antes de restaurar as configurações.'
}

if (-not (Test-Path -LiteralPath $source)) {
    throw "Snapshot não encontrado em: $source"
}

if (-not (Test-Path -LiteralPath $destinationDirectory)) {
    New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null
}

if (Test-Path -LiteralPath $destination) {
    $timestamp = Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'
    $safetyCopy = "$destination.before-restore-$timestamp.bak"
    Copy-Item -LiteralPath $destination -Destination $safetyCopy
    Write-Host "Configuração anterior preservada em: $safetyCopy"
}

Copy-Item -LiteralPath $source -Destination $destination -Force
Write-Host "Configurações do PUBG restauradas em: $destination"
Write-Host 'Abra o jogo e confira teclas, botões e sensibilidades.'
