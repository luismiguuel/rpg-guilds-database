-- VIEW 1: vw_personagem_completo
-- Visão desnormalizada de um personagem com dados do jogador e da guilda. Evita repetir os mesmos JOINs em toda consulta.
CREATE VIEW vw_personagem_completo AS
SELECT
    p.id_personagem,
    p.nome_personagem,
    p.classe,
    p.raca,
    p.sexo,
    p.level,
    p.hp,
    p.dano_por_segundo,
    p.cura_por_segundo,
    p.conexao,
    g.nome        AS nome_guilda,
    g.ranking     AS ranking_guilda,
    j.nome_usuario AS jogador,
    j.servidor
FROM PERSONAGEM p
JOIN JOGADOR j       ON j.id_jogador = p.id_jogador
LEFT JOIN GUILDA g   ON g.id_guilda  = p.id_guilda;

-- VIEW 2: vw_missao_resumo
-- Missões com contagem de participantes individuais e indicação do tipo (Quest ou Raid).
CREATE VIEW vw_missao_resumo AS
SELECT
    m.id_missao,
    m.titulo,
    m.dificuldade,
    m.ouro,
    m.experiencia,
    CASE
        WHEN r.id_missao IS NOT NULL THEN 'Raid'
        WHEN q.id_missao IS NOT NULL THEN 'Quest'
        ELSE 'Indefinido'
    END AS tipo_missao,
    COUNT(pm.id_personagem) AS total_participantes
FROM MISSAO m
LEFT JOIN RAID               r  ON r.id_missao  = m.id_missao
LEFT JOIN QUEST              q  ON q.id_missao  = m.id_missao
LEFT JOIN PARTICIPANTE_MISSAO pm ON pm.id_missao = m.id_missao
GROUP BY m.id_missao, r.id_missao, q.id_missao;

-- VIEW 3: vw_inventario_personagem
-- Itens que cada personagem possui, com nome e tipo do item.
CREATE VIEW vw_inventario_personagem AS
SELECT
    p.nome_personagem,
    p.classe,
    di.nome          AS nome_item,
    ti.nome_tipo_item AS tipo_item,
    di.efeito,
    i.durabilidade,
    i.usos_disponiveis
FROM PERSONAGEM p
JOIN PROP_INVENTARIO pi ON pi.id_prop_inv = p.id_prop_inv
JOIN INVENTARIO inv     ON inv.id_propietario = pi.id_prop_inv
JOIN ITEM i             ON i.id_inventario  = inv.id_inventario
JOIN DADOS_ITEM di      ON di.id_dados_item  = i.id_dados_item
JOIN TIPO_ITEM ti       ON ti.id_tipo_item   = di.id_tipo_item;