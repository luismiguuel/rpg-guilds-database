# 🛡️ RPG Guilds Database

Bem-vindo ao repositório do banco de dados do nosso projeto de RPG! Aqui mantemos toda a estrutura de tabelas (Schema) e os dados iniciais de teste (Seed) usando PostgreSQL.

## 📋 Pré-requisitos

Antes de começar, certifique-se de ter as seguintes ferramentas instaladas na sua máquina:
- [Git](https://git-scm.com/)
- [PostgreSQL](https://www.postgresql.org/download/) (Recomendamos a versão 14 ou superior)
- [Visual Studio Code](https://code.visualstudio.com/)
- Uma extensão de banco de dados no VS Code (ex: *PostgreSQL* da Microsoft, *SQLTools* ou *Database Client*) ou ferramentas como o *pgAdmin*/*DBeaver*.

---

## 🚀 Como configurar o projeto localmente

Siga o passo a passo abaixo para criar o banco de dados na sua máquina e populá-lo com os dados de teste.

### 1. Clone o repositório
Abra o seu terminal e rode o comando:
```bash
git clone URL_DO_SEU_REPOSITORIO_AQUI
cd RPG-GUILDS-DATABASE
```

### 2. Crie o Banco de Dados no PostgreSQL
Abra sua ferramenta de administração do PostgreSQL (ou o terminal psql) e crie um novo banco de dados vazio para o projeto:
```bash
CREATE DATABASE rpg_guilds_db;
```

### 3. Conecte-se e execute os Schemas (Estrutura)
Conecte-se ao banco `rpg_guilds_db` que você acabou de criar.
No VS Code, abra a pasta do projeto. Navegue até a pasta `/schema` e execute os scripts estritamente nesta ordem (pois existem dependências entre as tabelas):

1. `schema/001_core.sql` - (Tabelas base: Jogador, Itens, Missões...)

2. `schema/002_game.sql` - (Guildas, Personagens, Inventário...)

3. `schema/003_relation.sql` - (Participantes de missão, Diplomacia...)

### 4. Popule com Dados de Teste (Seed)
Para não trabalhar com um banco vazio, inserimos personagens, guildas e missões de teste.
Navegue até a pasta `/seed` e execute o arquivo:

- `seed/001_seed_data.sql`

Pronto! Seu banco local já está configurado, populado e pronto para uso!