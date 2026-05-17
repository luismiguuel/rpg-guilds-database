-- População inicial do banco de dados para testes

INSERT INTO PROP_INVENTARIO DEFAULT VALUES;
INSERT INTO PROP_INVENTARIO DEFAULT VALUES;
INSERT INTO PROP_INVENTARIO DEFAULT VALUES;
INSERT INTO PROP_INVENTARIO DEFAULT VALUES;
INSERT INTO PROP_INVENTARIO DEFAULT VALUES;

INSERT INTO JOGADOR (nome_usuario, email, senha, servidor) VALUES 
('Arthas99', 'arthas@email.com', 'senha123', 'America do Sul'),
('MerlinBR', 'merlin@email.com', 'magia321', 'America do Sul'),
('LaraCroft', 'lara@email.com', 'tomb456', 'America do Norte');

INSERT INTO GUILDA (id_prop_inv, ranking, nome) VALUES 
(1, 5, 'Cavaleiros do Dragão'),
(2, 12, 'Irmandade Arcana');

INSERT INTO PERSONAGEM (id_guilda, id_jogador, id_prop_inv, level, classe, raca, sexo, nome_personagem, dano_por_segundo, cura_por_segundo, hp) VALUES 
(1, 1, 3, 10, 'Guerreiro', 'Humano', 'Masculino', 'Sir Lancelot', 150.50, 0, 1200),
(2, 2, 4, 12, 'Mago', 'Elfo', 'Masculino', 'Gandalfinho', 220.00, 50.00, 700),
(1, 3, 5, 8, 'Arqueira', 'Elfo', 'Feminino', 'LegolasGirl', 180.20, 10.00, 850);

UPDATE GUILDA SET id_gestor = 1 WHERE id_guilda = 1; 
UPDATE GUILDA SET id_gestor = 2 WHERE id_guilda = 2; 

INSERT INTO TIPO_ITEM (nome_tipo_item) VALUES ('Arma'), ('Armadura'), ('Consumível');

INSERT INTO DADOS_ITEM (id_tipo_item, nome, efeito, durabilidade, validade) VALUES 
(1, 'Espada Larga de Ferro', 'Aumenta o dano físico em 15', 100, NULL),
(1, 'Cajado do Fogo', 'Ataques causam queimadura', 80, NULL),
(3, 'Poção de Vida Pequena', 'Restaura 200 de HP', NULL, 30); 

INSERT INTO ITEM_CLASSE (id_dados_item, nome_classe) VALUES 
(1, 'Guerreiro'), 
(1, 'Paladino'),
(2, 'Mago'), 
(2, 'Bruxo');

INSERT INTO INVENTARIO (id_propietario) VALUES (3), (4), (5); 

INSERT INTO ITEM (id_inventario, id_dados_item, durabilidade, usos_disponiveis) VALUES 
(1, 1, 100, NULL), 
(2, 2, 80, NULL),  
(1, 3, NULL, 5);   

INSERT INTO TIPO_QUEST (nome_tipo_quest) VALUES ('Coleta'), ('Escolta'), ('Extermínio');

INSERT INTO MISSAO (titulo, dificuldade, ouro, experiencia) VALUES 
('Goblins na Floresta', 'Fácil', 100, 500),
('A Caverna do Dragão', 'Épico', 5000, 15000);

INSERT INTO QUEST (id_missao, id_tipo_quest, item_coletado, personagem_escoltado, item_entregue) VALUES 
(1, 3, 'Orelhas de Goblin', NULL, 'Orelhas de Goblin');

INSERT INTO RAID (id_missao, nome) VALUES 
(2, 'Covil de Smaug');

INSERT INTO BOSS (id_missao, level, nome, hp, dano_por_segundo) VALUES 
(2, 50, 'Smaug, O Terrível', 50000, 850.00);

INSERT INTO PARTICIPANTE_MISSAO (id_missao, id_personagem) VALUES 
(2, 1), 
(2, 2);

INSERT INTO RELACOES_GUILDA (id_guilda_origem, id_guilda_destino, tipo_relacao) VALUES 
(1, 2, 'Aliança Comercial');