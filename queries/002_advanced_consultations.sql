-- Calcula em quantos segundos cada guilda derrotaria cada boss do jogo se atacassem juntos
WITH PoderDaGuilda AS (
    SELECT 
        g.id_guilda,
        g.nome AS guilda,
        COUNT(p.id_personagem) AS total_membros,
        SUM(p.dano_por_segundo) AS dps_total_guilda
    FROM GUILDA g
    JOIN PERSONAGEM p ON p.id_guilda = g.id_guilda
    GROUP BY g.id_guilda, g.nome
    HAVING SUM(p.dano_por_segundo) > 0
)
SELECT 
    pg.guilda,
    pg.total_membros,
    pg.dps_total_guilda,
    b.nome AS boss,
    b.hp AS boss_hp,
    ROUND((b.hp / pg.dps_total_guilda), 2) AS segundos_para_derrotar
FROM PoderDaGuilda pg
CROSS JOIN BOSS b
ORDER BY segundos_para_derrotar ASC;

-- Traz o Top 3 jogadores de cada servidor baseado na soma do level de seus personagens
WITH RankContas AS (
    SELECT 
        j.servidor,
        j.nome_usuario,
        COUNT(p.id_personagem) as qtd_personagens_na_conta,
        SUM(p.level) AS level_total_conta,
        DENSE_RANK() OVER (
            PARTITION BY j.servidor 
            ORDER BY SUM(p.level) DESC
        ) AS rank_no_servidor
    FROM JOGADOR j
    JOIN PERSONAGEM p ON j.id_jogador = p.id_jogador
    GROUP BY j.servidor, j.nome_usuario
)
SELECT * FROM RankContas
WHERE rank_no_servidor <= 3 
ORDER BY servidor, rank_no_servidor;

-- Verifica quem carrega itens que não tem permissão para usar (restrição de classe)
SELECT 
    p.nome_personagem,
    p.classe AS classe_do_personagem,
    di.nome AS item_incompativel,
    ti.nome_tipo_item AS categoria_item
FROM PERSONAGEM p
JOIN PROP_INVENTARIO pi ON p.id_prop_inv = pi.id_prop_inv
JOIN INVENTARIO inv     ON inv.id_propietario = pi.id_prop_inv
JOIN ITEM i             ON i.id_inventario = inv.id_inventario
JOIN DADOS_ITEM di      ON di.id_dados_item = i.id_dados_item
JOIN TIPO_ITEM ti       ON ti.id_tipo_item = di.id_tipo_item
WHERE NOT EXISTS (
    SELECT 1 
    FROM ITEM_CLASSE ic 
    WHERE ic.id_dados_item = di.id_dados_item 
      AND ic.nome_classe = p.classe
);

-- Calcula qual a % de dano cada personagem representa dentro do seu grupo de Raid
SELECT 
    r.nome AS nome_da_raid,
    b.nome AS nome_do_boss,
    p.nome_personagem,
    p.classe,
    p.dano_por_segundo AS dps_individual,
    SUM(p.dano_por_segundo) OVER (PARTITION BY r.id_missao) AS dps_total_do_grupo,
    ROUND(
        (p.dano_por_segundo / NULLIF(SUM(p.dano_por_segundo) OVER (PARTITION BY r.id_missao), 0)) * 100, 
    2) AS percentual_de_contribuicao
FROM RAID r
JOIN BOSS b ON r.id_missao = b.id_missao
JOIN PARTICIPANTE_MISSAO pm ON r.id_missao = pm.id_missao
JOIN PERSONAGEM p ON pm.id_personagem = p.id_personagem
ORDER BY r.id_missao, percentual_de_contribuicao DESC;

-- Soma o level dos membros da própria guilda com o level dos membros das guildas aliadas
SELECT 
    g_origem.nome AS guilda_analisada,
    COUNT(DISTINCT g_destino.id_guilda) AS total_de_guildas_aliadas,
    COALESCE(SUM(p_aliado.level), 0) AS poder_militar_dos_aliados
FROM GUILDA g_origem
LEFT JOIN RELACOES_GUILDA rg 
    ON g_origem.id_guilda = rg.id_guilda_origem 
    AND rg.tipo_relacao ILIKE '%Aliança%'
LEFT JOIN GUILDA g_destino 
    ON rg.id_guilda_destino = g_destino.id_guilda
LEFT JOIN PERSONAGEM p_aliado 
    ON g_destino.id_guilda = p_aliado.id_guilda
GROUP BY g_origem.id_guilda, g_origem.nome
ORDER BY poder_militar_dos_aliados DESC;