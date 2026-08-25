[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$gameRoot = Join-Path $env:USERPROFILE 'Zomboid'
$configSource = Join-Path $PSScriptRoot 'config'
$archiveSource = Join-Path $PSScriptRoot 'saves.zip'

$runningGame = Get-CimInstance Win32_Process | Where-Object {
    $_.Name -match '(?i)(ProjectZomboid|pzserver)' -or
    $_.CommandLine -match '(?i)(zombie\.GameWindow|zombie\.network\.GameServer)'
}
if ($runningGame) {
    throw 'Feche o Project Zomboid e qualquer servidor hospedado antes da restauração.'
}

if (-not (Test-Path -LiteralPath $configSource)) {
    throw "Configurações salvas não encontradas em: $configSource"
}
if (-not (Test-Path -LiteralPath $archiveSource)) {
    throw "Arquivo de saves não encontrado em: $archiveSource"
}

if (-not (Test-Path -LiteralPath $gameRoot)) {
    New-Item -ItemType Directory -Path $gameRoot | Out-Null
}

$timestamp = Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'
$safetyRoot = Join-Path $gameRoot "CodexRestoreBackups\$timestamp"
New-Item -ItemType Directory -Path $safetyRoot -Force | Out-Null

Get-ChildItem -LiteralPath $configSource -File -Recurse -Force | ForEach-Object {
    $relativePath = $_.FullName.Substring($configSource.Length).TrimStart('\')
    $currentFile = Join-Path $gameRoot $relativePath
    if (Test-Path -LiteralPath $currentFile) {
        $safetyFile = Join-Path (Join-Path $safetyRoot 'config') $relativePath
        $safetyDirectory = Split-Path -Parent $safetyFile
        if (-not (Test-Path -LiteralPath $safetyDirectory)) {
            New-Item -ItemType Directory -Path $safetyDirectory -Force | Out-Null
        }
        Copy-Item -LiteralPath $currentFile -Destination $safetyFile
    }
}

$currentSaves = Join-Path $gameRoot 'Saves'
if (Test-Path -LiteralPath $currentSaves) {
    Move-Item -LiteralPath $currentSaves -Destination (Join-Path $safetyRoot 'Saves')
}

Get-ChildItem -LiteralPath $configSource -File -Recurse -Force | ForEach-Object {
    $relativePath = $_.FullName.Substring($configSource.Length).TrimStart('\')
    $destinationFile = Join-Path $gameRoot $relativePath
    $destinationDirectory = Split-Path -Parent $destinationFile
    if (-not (Test-Path -LiteralPath $destinationDirectory)) {
        New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null
    }
    Copy-Item -LiteralPath $_.FullName -Destination $destinationFile -Force
}

& tar.exe -xf $archiveSource -C $gameRoot
if ($LASTEXITCODE -ne 0) {
    throw "Falha ao extrair os saves. Os arquivos anteriores estão em: $safetyRoot"
}

Write-Host "Configurações e saves restaurados em: $gameRoot"
Write-Host "Estado anterior preservado em: $safetyRoot"
Write-Host 'Senhas e tokens de servidor não fazem parte do backup.'
