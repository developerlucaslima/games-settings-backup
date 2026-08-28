# Games Settings Backup

Backup pessoal das configurações de jogos que não são sincronizadas de forma
confiável pela nuvem.

Cada jogo possui sua própria pasta, com as configurações versionadas e instruções
específicas de backup e restauração.

## Convenção de uso

Quando a intenção for configurar um jogo recém-instalado, pedidos como "atualizar
minhas configurações" significam restaurar no computador o snapshot que já está
versionado neste repositório.

- `restore.ps1`: repositório → computador (fluxo padrão para configurar o jogo);
- `backup.ps1`: computador → repositório (somente quando houver um pedido explícito
  para atualizar o backup ou o repositório).

Não execute backup, commit ou push com base apenas em um pedido para atualizar as
configurações locais. A atualização do repositório deve ser solicitada explicitamente.

## Jogos salvos

- [PUBG](pubg/README.md) — teclas, botões, sensibilidades e preferências do jogo.
- [Project Zomboid](project-zomboid/README.md) — configurações, teclas e saves.

## Organização

```text
games-settings-backup/
├── README.md
├── project-zomboid/
│   ├── README.md
│   ├── backup.ps1
│   ├── restore.ps1
│   ├── saves.zip
│   └── config/
└── pubg/
    ├── README.md
    ├── backup.ps1
    ├── restore.ps1
    └── config/
        └── GameUserSettings.ini
```

Novos jogos devem ser adicionados em pastas próprias, acompanhados de um README
que informe onde o jogo armazena suas configurações e como restaurá-las.

Arquivos com senhas, tokens de sessão, identificadores privados ou credenciais não
devem ser adicionados ao repositório.
