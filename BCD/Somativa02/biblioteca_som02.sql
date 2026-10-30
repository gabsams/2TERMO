-- Active: 1788519497574@@127.0.0.1@3306@biblioteca_som2_gabrielli

----------------------------FASE 2 — DML: MANIPULAÇÃO DE DADOS-------------------------
CREATE DATABASE IF NOT EXISTS Biblioteca_som2_Gabrielli;
DROP DATABASE IF EXISTS Biblioteca_som2_Gabrielli;
USE Biblioteca_som2_Gabrielli;

CREATE TABLE usuario (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(120) UNIQUE,
    telefone VARCHAR(20),
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);


CREATE TABLE livro (
    id_livro INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(150) NOT NULL,
    autor VARCHAR(120) NOT NULL UNIQUE,
    isbn CHAR(13) NOT NULL UNIQUE,
    ano_publicacao INT,
    quantidade_disponivel INT DEFAULT 0 CHECK (quantidade_disponivel>= 0)
);

CREATE TABLE IF NOT EXISTS emprestimo (
    id_emprestimo INT AUTO_INCREMENT,
    data_emprestimo DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_prevista DATE NOT NULL,
    data_devolucao DATE NULL,
    status_emprestimo VARCHAR(20) DEFAULT 'ABERTO',
    id_usuario INT NOT NULL,
    id_livro INT NOT NULL,
    CONSTRAINT PK_EMPRESTIMO PRIMARY KEY (id_emprestimo),
    CONSTRAINT CK_STATUS_EMPRESTIMO CHECK (status_emprestimo IN ('ABERTO', 'DEVOLVIDO', 'ATRASADO')),
    CONSTRAINT FK_EMPRESTIMO_USUARIO FOREIGN KEY (id_usuario) REFERENCES USUARIO (id_usuario) ON DELETE RESTRICT,
    CONSTRAINT FK_EMPRESTIMO_LIVRO FOREIGN KEY (id_livro) REFERENCES LIVRO (id_livro) ON DELETE RESTRICT
);

CREATE TABLE bibliotecaria(
    id_bibliotecaria INT PRIMARY KEY AUTO_INCREMENT,
    nome_responsavel VARCHAR(100) NOT NULL,
    email_responsavel VARCHAR(120) UNIQUE,
    telefone_responsavel VARCHAR(20),
    horario_de_trabalho TIME NOT NULL
);


CREATE TABLE funcionarios(
    id_funcionario INT PRIMARY KEY AUTO_INCREMENT,
    nome_funcionario VARCHAR(100) NOT NULL,
    telefone_funcionario VARCHAR(120),
    horario_de_trabalho TIME NOT NULL
);

ALTER TABLE livro ADD COLUMN editora VARCHAR(100) NULL;

SELECT*FROM emprestimo;

-----------------------FASE 2 — DML: MANIPULAÇÃO DE DADOS------------------------------


INSERT INTO usuario (nome,email,telefone,ativo) VALUES
('Rayssa', 'rayssa@email.com','1999999000',TRUE),
('Arthur','arthur@email.com',NULL, TRUE),
('Miguel','miguel@email.com','1999999902',TRUE),
('Isabel','isabel@email.com','1998230450',TRUE);


INSERT INTO livro (titulo, autor, isbn, ano_publicacao, quantidade_disponivel) VALUES
('O pequeno Principe','Antoine de Saint-Exupéry','9788575317075', '1943', '9' ),
('Dom Quixote','Miguel de Cervantes','9788582850152','1605', '7' ),
('Crime e Castigo','Fiódor Dostoiévski','9788573262117', '1866', '12'),
('Orgulho e Preconceito', 'Jane Austen', '9788542217674', '1813', '14'),
('Moby Dick', 'Herman Melville','9788535912449', '1851', '6'),
('Verity','Colleen Hoover','9788501117847','2018','13');

INSERT INTO livro(titulo, autor, isbn, ano_publicacao, quantidade_disponivel) VALUES
('Adultos','Emma Jane Unsworth', '9786555600049', '2020', '6'),
('Nem Todo Outono é Igual','Ellis Barnett', '9786552260857', '2023', '3');



INSERT INTO emprestimo (data_prevista, id_usuario, id_livro) VALUES
('2026-12-09','4','3'),
('2026-11-24','2','1'),
('2026-10-30','1','4');


SELECT*FROM usuario WHERE id_usuario =2;

UPDATE usuario
SET telefone = '1993245643'
WHERE id_usuario = 2;

UPDATE livro
SET quantidade_disponivel = quantidade_disponivel + 2
WHERE ano_publicacao >= 2020;

SELECT * FROM livro;


INSERT INTO usuario (nome , email, telefone, ativo) VALUES ('User Testee', 'teste@email.com', NULL, TRUE);

DELETE FROM usuario WHERE email = 'teste@email.com';


----------------------FASE 3 — DQL: CONSULTAS E  ANÁLISE---------------------------------

SELECT titulo, autor, quantidade_disponivel
FROM livro;


SELECT * FROM livro 
WHERE quantidade_disponivel > 2
ORDER BY  quantidade_disponivel DESC;


SELECT * FROM livro
WHERE titulo LIKE '%Quixote%';

SELECT * FROM livro
WHERE ano_publicacao BETWEEN 2015 AND 2025;


SELECT 
COUNT(*) AS total_livros,
SUM(quantidade_disponivel) AS total_exemplares,
AVG(quantidade_disponivel) AS media_exemplares,
MIN(quantidade_disponivel) AS menor_estoque,
MAX(quantidade_disponivel) AS maior_estoque
FROM livro;


SELECT E.id_emprestimo, U.id_usuario, E.id_livro, E.data_prevista, E.status_emprestimo 
FROM emprestimo as E 
INNER JOIN USUARIO AS U ON E.id_usuario = U.id_usuario;


SELECT status_emprestimo, COUNT(*) AS Quantidade 
FROM EMPRESTIMO 
GROUP BY status_emprestimo;



SELECT U.id_usuario, U.nome, COUNT(E.id_emprestimo) AS Quantidade 
FROM USUARIO AS U 
INNER JOIN EMPRESTIMO AS E ON E.id_usuario = U.id_usuario 
GROUP BY U.id_usuario, U.nome 
ORDER BY Quantidade DESC;



---------------------------------FASE 4 — TCL, TRANSAÇÕES E INTEGRIDADE----------------------------------

--21
START TRANSACTION;

INSERT INTO EMPRESTIMO
    (data_prevista, id_usuario, id_livro)
VALUES
    ('2026-11-05', 3, 4);

UPDATE livro
SET quantidade_disponivel = quantidade_disponivel - 1
WHERE id_livro = 4
  AND quantidade_disponivel > 0;

SELECT *
FROM EMPRESTIMO
WHERE id_usuario = 2
  AND id_livro = 2;

SELECT *
FROM LIVRO
WHERE id_livro = 4;

COMMIT;

--22
UPDATE livro
SET quantidade_disponivel = 99
WHERE id_livro = 1;
SELECT id_livro, quantidade_disponivel
FROM LIVRO
WHERE id_livro = 1;

ROLLBACK;

SELECT id_livro, quantidade_disponivel
FROM LIVRO
WHERE id_livro = 1;


--23
START TRANSACTION;

UPDATE LIVRO
SET quantidade_disponivel = 20
WHERE id_livro = 2;

SAVEPOINT ponto_alte;

UPDATE LIVRO
SET quantidade_disponivel = 30
WHERE id_livro = 3;

ROLLBACK TO SAVEPOINT ponto_alte;

COMMIT;

SELECT id_livro, quantidade_disponivel
FROM LIVRO
WHERE id_livro IN (2, 3);


--24
START TRANSACTION;

UPDATE LIVRO L
INNER JOIN EMPRESTIMO E
    ON L.id_livro = E.id_livro
SET L.quantidade_disponivel = L.quantidade_disponivel + 1
WHERE E.id_emprestimo = 1
  AND E.status_emprestimo ='‘ABERTO';

UPDATE EMPRESTIMO
SET status_emprestimo = 'DEVOLVIDO',
    Data_devolucao = CURDATE()
WHERE id_emprestimo = 1
  AND status_emprestimo = 'ABERTO';

COMMIT;

