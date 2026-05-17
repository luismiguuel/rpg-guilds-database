-- Tabelas de relacionamentos

CREATE TABLE PARTICIPANTE_MISSAO (
    id SERIAL PRIMARY KEY,
    id_missao INT NOT NULL,
    id_personagem INT NOT NULL,
    
    FOREIGN KEY (id_missao) REFERENCES MISSAO(id_missao),
    FOREIGN KEY (id_personagem) REFERENCES PERSONAGEM(id_personagem)
);

CREATE TABLE GUILDA_MISSAO (
    id SERIAL PRIMARY KEY,
    id_guilda INT NOT NULL,
    id_missao INT NOT NULL,
    
    FOREIGN KEY (id_guilda) REFERENCES GUILDA(id_guilda),
    FOREIGN KEY (id_missao) REFERENCES MISSAO(id_missao)
);

CREATE TABLE RELACOES_GUILDA (
    id_relacao SERIAL PRIMARY KEY,
    id_guilda_origem INT NOT NULL,
    id_guilda_destino INT NOT NULL,
    tipo_relacao VARCHAR(50) NOT NULL,
    
    FOREIGN KEY (id_guilda_origem) REFERENCES GUILDA(id_guilda),
    FOREIGN KEY (id_guilda_destino) REFERENCES GUILDA(id_guilda)
);