-- Listar todos os personagens com seus dados completos
SELECT *
FROM vw_personagem_completo
ORDER BY level DESC;

-- SUBCONSULTA — Personagens com level acima da média geral
SELECT nome_personagem, classe, level
FROM PERSONAGEM
WHERE level > (
    SELECT AVG(level)
    FROM PERSONAGEM
)
ORDER BY level DESC;

-- SUBCONSULTA — Guildas que ainda não participaram de nenhuma missão
SELECT nome
FROM GUILDA
WHERE id_guilda NOT IN (
    SELECT id_guilda
    FROM GUILDA_MISSAO
);


-- SUBCONSULTA — Missões com recompensa em ouro acima da média de todas as missões
SELECT titulo, dificuldade, ouro, experiencia
FROM MISSAO
WHERE ouro > (
    SELECT AVG(ouro)
    FROM MISSAO
)
ORDER BY ouro DESC;

-- SUBCONSULTA CORRELACIONADA — Para cada guilda, mostrar o personagem com maior level (gestor ou não)
SELECT
    g.nome AS guilda,
    p.nome_personagem,
    p.level
FROM PERSONAGEM p
JOIN GUILDA g ON g.id_guilda = p.id_guilda
WHERE p.level = (
    SELECT MAX(p2.level)
    FROM PERSONAGEM p2
    WHERE p2.id_guilda = p.id_guilda
);

-- Resumo de todas as missões com número de participantes
SELECT *
FROM vw_missao_resumo
ORDER BY total_participantes DESC;

-- Itens no inventário de cada personagem
SELECT *
FROM vw_inventario_personagem
ORDER BY nome_personagem;

-- Ranking das guildas com o total de membros
SELECT
    g.nome          AS guilda,
    g.ranking,
    COUNT(p.id_personagem) AS total_membros,
    COALESCE(AVG(p.level), 0) AS level_medio
FROM GUILDA g
LEFT JOIN PERSONAGEM p ON p.id_guilda = g.id_guilda
GROUP BY g.id_guilda
ORDER BY g.ranking DESC;

-- Itens disponíveis para a classe 'Guerreiro'
SELECT
    di.nome          AS item,
    ti.nome_tipo_item AS tipo,
    di.efeito
FROM DADOS_ITEM di
JOIN TIPO_ITEM ti   ON ti.id_tipo_item  = di.id_tipo_item
JOIN ITEM_CLASSE ic ON ic.id_dados_item = di.id_dados_item
WHERE ic.nome_classe = 'Guerreiro';

-- Relações diplomáticas entre guildas
SELECT
    g1.nome AS guilda_origem,
    rg.tipo_relacao,
    g2.nome AS guilda_destino
FROM RELACOES_GUILDA rg
JOIN GUILDA g1 ON g1.id_guilda = rg.id_guilda_origem
JOIN GUILDA g2 ON g2.id_guilda = rg.id_guilda_destino;