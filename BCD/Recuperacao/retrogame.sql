-- Active: 1794486439517@@127.0.0.1@3306@retrogame_recuperacao_gabrielli
--FASE 01 --DDL: estrutura e restrições
--01.
CREATE DATABASE IF NOT EXISTS retrogame_recuperacao_gabrielli;
USE retrogame_recuperacao_gabrielli;

--02.
CREATE TABLE cliente(
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    telefone VARCHAR(20) NULL,
    ativo BOOLEAN DEFAULT TRUE
);
--03.
CREATE TABLE plataforma(
    id_plataforma INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE categoria(
    id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(80) NOT NULL UNIQUE
);

--04.
CREATE TABLE jogo(
    id_jogo INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(150) NOT NULL,
    codigo VARCHAR(15) NOT NULL UNIQUE,
    ano_lancamento INT NOT NULL,
    quantidade_disponivel INT DEFAULT 0 CHECK (quantidade_disponivel >=0),
    id_plataforma INT NOT NULL,
    id_categoria INT NOT NULL,
    id_cliente INT NOT NULL,
    CONSTRAINT fk_jogo_plataforma FOREIGN KEY (id_plataforma) REFERENCES plataforma(id_plataforma),
    CONSTRAINT fk_jogo_categoria FOREIGN KEY (id_categoria) REFERENCES categoria (id_categoria)
);


--05.
CREATE TABLE locacao(
    id_locacao INT PRIMARY KEY AUTO_INCREMENT,
    data_retirada DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_prevista DATE NOT NULL,
    data_devolucao DATE NOT NULL,
    status_locacao VARCHAR(20) DEFAULT 'ABERTA' check (status_locacao = 'ABERTA' or status_locacao = 'DEVOLVIDA' or status_locacao = 'ATRASADA'),
    id_jogo INT NOT NULL,
    id_plataforma INT NOT NULL,
    id_cliente INT NOT NULL,
    CONSTRAINT fk_locacao_jogo FOREIGN KEY (id_jogo) REFERENCES jogo(id_jogo),
    CONSTRAINT fk_locacao_plataforma FOREIGN KEY (id_plataforma) REFERENCES plataforma(id_plataforma),
    CONSTRAINT fk_locacao_cliente FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente)
);

--06.
ALTER TABLE jogo ADD COLUMN desenvolvedora VARCHAR(100) NULL;


--FASE 2 -- DML: manipulação de dados
--07.
INSERT INTO cliente(nome, email, telefone, ativo) VALUES
('Rayssa', 'rayssa@email.com','1999999000',TRUE),
('Felipe','felipe@email.com',NULL, TRUE),
('Miguel','miguel@email.com','1999999902',TRUE),
('Isabel','isabel@email.com','1998230450',TRUE);

--08.
INSERT INTO plataforma(nome) VALUES
(Xbox),
(Nintendo),
(PlayStation4);

INSERT INTO categoria(descricao) VALUES
(Ação),
(Terror),
(Esporte);


INSERT INTO jogo (titulo, codigo, ano_lancamento, quantidade_disponivel, id_plataforma, id_categoria,desenvolvedora) VALUES
('League of legends', 92222,)
('Fall Guys')

--09.
INSERT INTO locacao(id_locacao, data_retirada, data_prevista, data_devolucao,id_cliente, id_jogo, id_plataforma, status_locacao) VALUES
(DEFAULT, '2025-05-09 14:00:00','2025-05-20',NULL,2,2,2,'ABERTA'),
(DEFAULT, '2025-04-12 13:00:00','2025-04-28',NULL,3,3,3,'ABERTA'),
(DEFAULT, '2025-05-09 14:00:00','2025-05-20',NULL,4,4,4,'ABERTA');

--10.
SELECT id_cliente, nome, telefone
FROM cliente

UPDATE cliente
SET telefone='12322233'
WHERE id_cliente =2;

--11.



--12.
delete from cliente where id_cliente = 3;
delete from cliente where id_cliente = 5;
SELECT * FROM cliente


--FASE 3
--13.
select titulo, ano