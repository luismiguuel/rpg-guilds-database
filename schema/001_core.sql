-- Tabelas base

CREATE TABLE JOGADOR (
    id_jogador SERIAL PRIMARY KEY,
    nome_usuario VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    servidor VARCHAR(50)
);

CREATE TABLE PROP_INVENTARIO (
    id_prop_inv SERIAL PRIMARY KEY
);

CREATE TABLE TIPO_ITEM (
    id_tipo_item SERIAL PRIMARY KEY,
    nome_tipo_item VARCHAR(100) NOT NULL
);

CREATE TABLE TIPO_QUEST (
    id_tipo_quest SERIAL PRIMARY KEY,
    nome_tipo_quest VARCHAR(100) NOT NULL
);

CREATE TABLE MISSAO (
    id_missao SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    dificuldade VARCHAR(50),
    ouro INT DEFAULT 0,
    experiencia INT DEFAULT 0
);

CREATE TABLE DADOS_ITEM (
    id_dados_item SERIAL PRIMARY KEY,
    id_tipo_item INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    efeito VARCHAR(255),
    durabilidade INT,
    validade INT,
    
    FOREIGN KEY (id_tipo_item) REFERENCES TIPO_ITEM(id_tipo_item)
);

CREATE TABLE ITEM_CLASSE (
    id_tipo_classe SERIAL PRIMARY KEY,
    id_dados_item INT NOT NULL,
    nome_classe VARCHAR(50) NOT NULL,
    
    FOREIGN KEY (id_dados_item) REFERENCES DADOS_ITEM(id_dados_item)
);