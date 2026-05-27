# 🛡️ RPG Guilds Database

Repositório do banco de dados do projeto de RPG. Contém a estrutura completa de tabelas (Schema), dados iniciais de teste (Seed), consultas SQL e um script Python de conexão, todos utilizando PostgreSQL.

## 📋 Pré-requisitos

Certifique-se de ter as seguintes ferramentas instaladas:
- [Git](https://git-scm.com/)
- [PostgreSQL](https://www.postgresql.org/download/) (versão 14 ou superior)
- [Python](https://www.python.org/downloads/) (versão 3.8 ou superior)
- [Visual Studio Code](https://code.visualstudio.com/) com uma extensão de banco de dados (*SQLTools*, *Database Client* ou *PostgreSQL* da Microsoft) — ou *pgAdmin* / *DBeaver*

---

## 📁 Estrutura do Projeto

```
rpg-guilds-database/
│
├── schema/
│   ├── 001_core.sql        # Tabelas base: Jogador, Itens, Missões, Tipos
│   ├── 002_game.sql        # Guildas, Personagens, Inventário, Quests, Raids
│   ├── 003_relations.sql   # Participantes de missão, Diplomacia entre guildas
│   ├── 004_triggers.sql    # Triggers de validação e integridade
│   └── 005_views.sql       # Views para consultas recorrentes
│
├── seed/
│   └── 001_seed_data.sql   # Dados iniciais de teste
│
├── queries/
│   └── 001_consultations.sql   # Consultas SQL com subconsultas e uso das views
│
└── app/
    └── connections.py          # Script Python de conexão e execução de consultas
```

---

## 🚀 Como configurar o projeto localmente

### 1. Clone o repositório

```bash
git clone URL_DO_SEU_REPOSITORIO_AQUI
cd rpg-guilds-database
```

### 2. Crie o banco de dados

Abra o terminal `psql` ou sua ferramenta de administração e execute:

```sql
CREATE DATABASE rpg_guilds_db;
```

### 3. Execute os Schemas

Conecte-se ao banco `rpg_guilds_db` e execute os arquivos da pasta `/schema` **estritamente nesta ordem**, pois há dependências entre as tabelas:

```
1. schema/001_core.sql       → Tabelas base
2. schema/002_game.sql       → Entidades principais do jogo
3. schema/003_relations.sql  → Tabelas de relacionamento
4. schema/004_triggers.sql   → Triggers
5. schema/005_views.sql      → Views
```

### 4. Popule o banco com dados de teste

```
seed/001_seed_data.sql
```

### 5. Execute as consultas (opcional)

O arquivo abaixo contém exemplos de consultas SQL, incluindo subconsultas:

```
queries/001_consultations.sql
```

---

## 🐍 Conexão via Python

### Instale a dependência

```bash
pip install psycopg2-binary
```

### Configure as credenciais

Abra `app/connections.py` e ajuste o bloco `DB_CONFIG` com as credenciais do seu ambiente:

```python
DB_CONFIG = {
    "host":     "localhost",
    "port":     5432,
    "dbname":   "rpg_guilds_db",
    "user":     "postgres",
    "password": "postgres",
}
```

### Execute

```bash
python app/connections.py
```

O script conecta ao banco e exibe os resultados das principais consultas no terminal.
