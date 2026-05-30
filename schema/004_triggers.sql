-- TRIGGER 1
-- Impede que um personagem participe de uma raid cujo boss tenha level mais que o dobro do level do personagem.
-- Simula a "asserção": todo participante de missão deve ter level mínimo compatível com o conteúdo.
CREATE OR REPLACE FUNCTION fn_validar_level_raid()
RETURNS TRIGGER AS $$
DECLARE
    v_level_personagem INT;
    v_level_boss       INT;
    v_nome_personagem  VARCHAR(100);
BEGIN
    SELECT level, nome_personagem
        INTO v_level_personagem, v_nome_personagem
    FROM PERSONAGEM
    WHERE id_personagem = NEW.id_personagem;

    SELECT MAX(level)
        INTO v_level_boss
    FROM BOSS
    WHERE id_missao = NEW.id_missao;

    IF v_level_boss IS NOT NULL AND v_level_personagem < (v_level_boss / 2) THEN
        RAISE EXCEPTION
            'Personagem "%" (level %) não pode participar desta raid (level mínimo exigido: %).',
            v_nome_personagem, v_level_personagem, (v_level_boss / 2);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validar_level_raid
BEFORE INSERT ON PARTICIPANTE_MISSAO
FOR EACH ROW EXECUTE FUNCTION fn_validar_level_raid();

-- TRIGGER 2
-- Recalcula automaticamente o ranking de uma guilda sempre que um personagem é inserido, atualizado (level) ou removido.
-- Ranking = soma dos levels de todos os membros ativos.
-- Simula a "asserção": o ranking deve sempre refletir o estado real dos membros.
CREATE OR REPLACE FUNCTION fn_recalcular_ranking_guilda()
RETURNS TRIGGER AS $$
DECLARE
    v_id_guilda INT;
BEGIN
    -- Determina qual guilda foi afetada (INSERT/UPDATE usa NEW, DELETE usa OLD)
    IF TG_OP = 'DELETE' THEN
        v_id_guilda := OLD.id_guilda;
    ELSE
        v_id_guilda := NEW.id_guilda;
    END IF;

    IF v_id_guilda IS NOT NULL THEN
        UPDATE GUILDA
        SET ranking = (
            SELECT COALESCE(SUM(level), 0)
            FROM PERSONAGEM
            WHERE id_guilda = v_id_guilda
        )
        WHERE id_guilda = v_id_guilda;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_recalcular_ranking
AFTER INSERT OR UPDATE OF level OR DELETE ON PERSONAGEM
FOR EACH ROW EXECUTE FUNCTION fn_recalcular_ranking_guilda();

-- TRIGGER 3
-- Impede que uma guilda seja sua própria aliada ou inimiga.
-- Simula a "asserção": uma relação diplomática não pode ter guilda de origem igual à guilda de destino.
CREATE OR REPLACE FUNCTION fn_validar_relacao_guilda()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.id_guilda_origem = NEW.id_guilda_destino THEN
        RAISE EXCEPTION
            'Uma guilda não pode ter uma relação diplomática consigo mesma (id_guilda: %).',
            NEW.id_guilda_origem;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validar_relacao_guilda
BEFORE INSERT OR UPDATE ON RELACOES_GUILDA
FOR EACH ROW EXECUTE FUNCTION fn_validar_relacao_guilda();