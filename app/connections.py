"""
Dependência:
    pip install psycopg2-binary

Configuração:
    Ajuste as variáveis em DB_CONFIG com as credenciais locais.
"""

import psycopg2
from psycopg2.extras import RealDictCursor

# Configuração da conexão — ajuste conforme seu ambiente local
DB_CONFIG = {
    "host":     "localhost",
    "port":     5432,
    "dbname":   "rpg_guilds_db",
    "user":     "postgres",
    "password": "postgres",
}

def conectar():
    """Abre e retorna uma conexão com o banco de dados."""
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        print("Conexão estabelecida com sucesso.\n")
        return conn
    except psycopg2.OperationalError as e:
        print(f"Erro ao conectar: {e}")
        raise

def exibir_resultado(cursor, titulo: str):
    """Imprime o resultado de uma consulta de forma legível."""
    print(f"{'=' * 60}")
    print(f"  {titulo}")
    print(f"{'=' * 60}")
    linhas = cursor.fetchall()
    if not linhas:
        print("  (nenhum resultado encontrado)")
    for linha in linhas:
        print(" ", dict(linha))
    print()

def main():
    conn = conectar()

    with conn.cursor(cursor_factory=RealDictCursor) as cur:

        # Todos os personagens com dados completos (via view)
        cur.execute("""
            SELECT nome_personagem, classe, level, nome_guilda, jogador
            FROM vw_personagem_completo
            ORDER BY level DESC;
        """)
        exibir_resultado(cur, "Personagens (ordenados por level)")

        # SUBCONSULTA — Personagens acima da média de level
        cur.execute("""
            SELECT nome_personagem, classe, level
            FROM PERSONAGEM
            WHERE level > (SELECT AVG(level) FROM PERSONAGEM)
            ORDER BY level DESC;
        """)
        exibir_resultado(cur, "Personagens com level acima da média")

        # SUBCONSULTA — Guildas sem missões registradas
        cur.execute("""
            SELECT nome
            FROM GUILDA
            WHERE id_guilda NOT IN (
                SELECT id_guilda FROM GUILDA_MISSAO
            );
        """)
        exibir_resultado(cur, "Guildas sem missões")

        # SUBCONSULTA — Missões com ouro acima da média
        cur.execute("""
            SELECT titulo, dificuldade, ouro
            FROM MISSAO
            WHERE ouro > (SELECT AVG(ouro) FROM MISSAO)
            ORDER BY ouro DESC;
        """)
        exibir_resultado(cur, "Missões com recompensa acima da média")

        # Ranking das guildas
        cur.execute("""
            SELECT g.nome, g.ranking, COUNT(p.id_personagem) AS membros
            FROM GUILDA g
            LEFT JOIN PERSONAGEM p ON p.id_guilda = g.id_guilda
            GROUP BY g.id_guilda
            ORDER BY g.ranking DESC;
        """)
        exibir_resultado(cur, "Ranking das guildas")

        # Relações diplomáticas
        cur.execute("""
            SELECT g1.nome AS origem, rg.tipo_relacao, g2.nome AS destino
            FROM RELACOES_GUILDA rg
            JOIN GUILDA g1 ON g1.id_guilda = rg.id_guilda_origem
            JOIN GUILDA g2 ON g2.id_guilda = rg.id_guilda_destino;
        """)
        exibir_resultado(cur, "Relações diplomáticas entre guildas")

    conn.close()
    print("Conexão encerrada.")


if __name__ == "__main__":
    main()