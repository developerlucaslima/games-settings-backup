# Project Zomboid

Esta pasta guarda as configurações e os saves locais do Project Zomboid no
Windows. A pasta original do jogo fica em:

```text
%USERPROFILE%\Zomboid
```

## Conteúdo salvo

- `config/options.ini`: vídeo, áudio, interface e opções gerais;
- `config/Lua/`: teclas, layouts e preferências de mods;
- `config/Server/`: configurações e regras dos servidores locais;
- `saves.zip`: cópia completa da pasta `Zomboid\Saves`.

Os campos `Password`, `RCONPassword`, `DiscordToken` e
`server_browser_announced_ip` são esvaziados automaticamente. Os arquivos
`Lua/host.ini`, `Lua/invited.ini` e a pasta `db` não são versionados porque podem
conter nomes de usuário, contas ou credenciais. Logs, mods baixados, Workshop e
backups automáticos duplicados também ficam de fora.

Este repositório é público. Saves multiplayer podem conter identificadores de
jogadores e servidores necessários para que o jogo reconheça os personagens.

## Restaurar depois de formatar

1. Instale e abra o Project Zomboid pelo menos uma vez; depois feche o jogo e
   qualquer servidor hospedado.
2. Clone este repositório.
3. Abra o PowerShell na pasta `project-zomboid` e execute:

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\restore.ps1
```

Se já existirem saves ou configurações, o script os preserva primeiro em
`%USERPROFILE%\Zomboid\CodexRestoreBackups\<data-e-hora>`.

Senhas de servidor e tokens não são restaurados; configure-os novamente no jogo.

## Atualizar o backup

Feche o jogo e qualquer servidor hospedado. Depois execute:

```powershell
cd project-zomboid
powershell.exe -ExecutionPolicy Bypass -File .\backup.ps1
cd ..
git add README.md project-zomboid
git commit -m "Atualiza configuracoes e saves do Project Zomboid"
git push
```

O script recria `config/` e `saves.zip` a partir dos arquivos atuais do jogo,
aplicando novamente os filtros de privacidade.
