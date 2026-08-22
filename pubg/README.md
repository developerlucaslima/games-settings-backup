# PUBG

Esta pasta guarda as configurações locais do PUBG para Windows, incluindo:

- teclas e botões personalizados;
- sensibilidade geral, de mira e por escopo;
- modos de mirar, agachar, inclinar e outras preferências;
- demais opções presentes em `GameUserSettings.ini`.

O arquivo original fica em:

```text
%LOCALAPPDATA%\TslGame\Saved\Config\WindowsNoEditor\GameUserSettings.ini
```

O `Input.ini` dessa instalação está vazio; as configurações relevantes estão em
`GameUserSettings.ini`.

## Restaurar depois de formatar

1. Instale e abra o PUBG pelo menos uma vez; depois feche o jogo.
2. Clone este repositório ou copie o backup para o computador.
3. Abra o PowerShell na pasta `pubg` e execute:

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\restore.ps1
```

Se já existir uma configuração, o script cria uma cópia com o sufixo
`.before-restore-AAAA-MM-DD_HH-mm-ss.bak` antes de substituí-la.

## Atualizar o backup

Com o PUBG fechado, execute:

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\backup.ps1
git add config\GameUserSettings.ini
git commit -m "Atualiza configurações do PUBG"
```

O script remove `OutgameUserDatas` do snapshot. Esse campo contém um token
temporário do jogo, não é necessário para restaurar os controles e não deve ser
versionado.

## Fazer o backup sobreviver à formatação

As configurações desta pasta são versionadas no repositório remoto. Depois de uma
formatação, basta clonar novamente o repositório e executar o script de restauração.
