# Games Settings Backup

Backup pessoal das configurações de jogos que não são sincronizadas de forma
confiável pela nuvem.

Cada jogo possui sua própria pasta, com as configurações versionadas e instruções
específicas de backup e restauração.

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
