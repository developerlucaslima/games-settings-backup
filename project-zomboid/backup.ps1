[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$gameRoot = Join-Path $env:USERPROFILE 'Zomboid'
$configDestination = Join-Path $PSScriptRoot 'config'
$archiveDestination = Join-Path $PSScriptRoot 'saves.zip'

if (-not (Test-Path -LiteralPath $gameRoot)) {
    throw "Pasta do Project Zomboid não encontrada em: $gameRoot"
}

$runningGame = Get-CimInstance Win32_Process | Where-Object {
    $_.Name -match '(?i)(ProjectZomboid|pzserver)' -or
    $_.CommandLine -match '(?i)(zombie\.GameWindow|zombie\.network\.GameServer)'
}
if ($runningGame) {
    throw 'Feche o Project Zomboid e qualquer servidor hospedado antes do backup.'
}

$repoRoot = [System.IO.Path]::GetFullPath($PSScriptRoot).TrimEnd('\') + '\'
$resolvedConfigDestination = [System.IO.Path]::GetFullPath($configDestination)
if (-not $resolvedConfigDestination.StartsWith($repoRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw 'O destino das configurações não está dentro da pasta do backup.'
}

if (Test-Path -LiteralPath $configDestination) {
    Remove-Item -LiteralPath $configDestination -Recurse -Force
}
New-Item -ItemType Directory -Path $configDestination | Out-Null

$optionsSource = Join-Path $gameRoot 'options.ini'
if (Test-Path -LiteralPath $optionsSource) {
    Copy-Item -LiteralPath $optionsSource -Destination (Join-Path $configDestination 'options.ini')
}

$luaSource = Join-Path $gameRoot 'Lua'
$luaDestination = Join-Path $configDestination 'Lua'
if (Test-Path -LiteralPath $luaSource) {
    Get-ChildItem -LiteralPath $luaSource -File -Recurse -Force | ForEach-Object {
        $relativePath = $_.FullName.Substring($luaSource.Length).TrimStart('\')
        if ($relativePath -notin @('host.ini', 'invited.ini')) {
            $target = Join-Path $luaDestination $relativePath
            $targetDirectory = Split-Path -Parent $target
            if (-not (Test-Path -LiteralPath $targetDirectory)) {
                New-Item -ItemType Directory -Path $targetDirectory -Force | Out-Null
            }
            Copy-Item -LiteralPath $_.FullName -Destination $target
        }
    }
}

$serverSource = Join-Path $gameRoot 'Server'
$serverDestination = Join-Path $configDestination 'Server'
if (Test-Path -LiteralPath $serverSource) {
    Copy-Item -LiteralPath $serverSource -Destination $serverDestination -Recurse

    $privateKeys = @('Password', 'RCONPassword', 'DiscordToken', 'server_browser_announced_ip')
    $utf8WithoutBom = New-Object System.Text.UTF8Encoding($false)
    Get-ChildItem -LiteralPath $serverDestination -File -Filter '*.ini' -Recurse | ForEach-Object {
        $lines = [System.IO.File]::ReadAllLines($_.FullName)
        for ($index = 0; $index -lt $lines.Count; $index++) {
            foreach ($key in $privateKeys) {
                if ($lines[$index] -match "^\s*$([regex]::Escape($key))\s*=") {
                    $lines[$index] = "$key="
                    break
                }
            }
        }
        [System.IO.File]::WriteAllLines($_.FullName, $lines, $utf8WithoutBom)
    }
}

$savesSource = Join-Path $gameRoot 'Saves'
if (-not (Test-Path -LiteralPath $savesSource)) {
    throw "Pasta de saves não encontrada em: $savesSource"
}

$temporaryArchive = Join-Path $PSScriptRoot ("saves.{0}.tmp.zip" -f [guid]::NewGuid().ToString('N'))
try {
    & tar.exe -a -cf $temporaryArchive -C $gameRoot 'Saves'
    if ($LASTEXITCODE -ne 0) {
        throw "Falha ao compactar os saves; tar.exe retornou $LASTEXITCODE."
    }
    Move-Item -LiteralPath $temporaryArchive -Destination $archiveDestination -Force
}
finally {
    if (Test-Path -LiteralPath $temporaryArchive) {
        Remove-Item -LiteralPath $temporaryArchive -Force
    }
}

$saveFiles = @(Get-ChildItem -LiteralPath $savesSource -File -Recurse -Force)
$hash = (Get-FileHash -LiteralPath $archiveDestination -Algorithm SHA256).Hash

Write-Host "Configurações atualizadas em: $configDestination"
Write-Host ("Saves arquivados: {0} arquivos, {1:N0} bytes" -f $saveFiles.Count, ($saveFiles | Measure-Object Length -Sum).Sum)
Write-Host "Arquivo: $archiveDestination"
Write-Host "SHA-256: $hash"
