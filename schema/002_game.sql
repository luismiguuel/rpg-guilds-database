-- Entidades principais do jogo e resolução de heranças

CREATE TABLE GUILDA (
    id_guilda SERIAL PRIMARY KEY,
    id_prop_inv INT,
    id_gestor INT,
    ranking INT,
    nome VARCHAR(100) NOT NULL,
    
    FOREIGN KEY (id_prop_inv) REFERENCES PROP_INVENTARIO(id_prop_inv)
);

CREATE TABLE PERSONAGEM (
    id_personagem SERIAL PRIMARY KEY,
    id_guilda INT,
    id_jogador INT NOT NULL,
    id_prop_inv INT,
    level INT DEFAULT 1,
    classe VARCHAR(50),
    raca VARCHAR(50),
    sexo VARCHAR(20),
    nome_personagem VARCHAR(100) NOT NULL,
    conexao TIMESTAMP, 

    FOREIGN KEY (id_guilda) REFERENCES GUILDA(id_guilda),
    FOREIGN KEY (id_jogador) REFERENCES JOGADOR(id_jogador),
    FOREIGN KEY (id_prop_inv) REFERENCES PROP_INVENTARIO(id_prop_inv)
    FOREIGN KEY (classe, level) REFERENCES PERSONAGEM_STATUS(classe, level)
);

CREATE TABLE PERSONAGEM_STATUS (
    classe VARCHAR(50) PRIMARY KEY,
    level INT NOT NULL,
    dano_por_segundo DECIMAL(10,2) DEFAULT 0,
    cura_por_segundo DECIMAL(10,2) DEFAULT 0,
    hp INT NOT NULL

)

ALTER TABLE GUILDA 
ADD CONSTRAINT fk_guilda_gestor 
FOREIGN KEY (id_gestor) REFERENCES PERSONAGEM(id_personagem);

CREATE TABLE INVENTARIO (
    id_inventario SERIAL PRIMARY KEY,
    id_propietario INT NOT NULL,
    
    FOREIGN KEY (id_propietario) REFERENCES PROP_INVENTARIO(id_prop_inv)
);

CREATE TABLE ITEM (
    id_item SERIAL PRIMARY KEY,
    id_inventario INT NOT NULL,
    id_dados_item INT NOT NULL,
    durabilidade INT,
    validade INT,
    usos_disponiveis INT,
    
    FOREIGN KEY (id_inventario) REFERENCES INVENTARIO(id_inventario),
    FOREIGN KEY (id_dados_item) REFERENCES DADOS_ITEM(id_dados_item)
);

CREATE TABLE QUEST (
    id_missao INT PRIMARY KEY,
    id_tipo_quest INT,
    item_coletado VARCHAR(100),
    personagem_escoltado VARCHAR(100),
    item_entregue VARCHAR(100),
    
    FOREIGN KEY (id_missao) REFERENCES MISSAO(id_missao),
    FOREIGN KEY (id_tipo_quest) REFERENCES TIPO_QUEST(id_tipo_quest)
);

CREATE TABLE RAID (
    id_missao INT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    
    FOREIGN KEY (id_missao) REFERENCES MISSAO(id_missao)
);

CREATE TABLE BOSS (
    id_boss SERIAL PRIMARY KEY,
    id_missao INT NOT NULL,
    level INT,
    nome VARCHAR(100) NOT NULL,
    hp INT,
    dano_por_segundo DECIMAL(10,2),
    
    FOREIGN KEY (id_missao) REFERENCES MISSAO(id_missao)
);