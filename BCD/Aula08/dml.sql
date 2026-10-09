-- Active: 1788519497574@@127.0.0.1@3306@smartcoffe_dml_gabrielli
DROP DATABASE IF NOT EXISTS SMARTCOFFE_DML_GABRIELLI;

CREATE DATABASE IF NOT EXISTS SMARTCOFFE_DML_GABRIELLI;

USE SMARTCOFFE_DML_GABRIELLI;

CREATE TABLE Cliente(
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR (120) NOT NULL,
    telefone VARCHAR(15),
    cidade VARCHAR(60) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE categoria(
    id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(60) NOT NULL UNIQUE,
    preco DECIMAL(10,2) NOT NULL
);



CREATE TABLE produto(
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    id_categoria INT NOT NULL,
    CONSTRAINT fk_produto_categoria FOREIGN KEY (id_categoria) REFERENCES categoria (id_categoria)
);


CREATE TABLE pedido(
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    data_pedido DATETIME NOT NULL,
    status_pedido ENUM('ABERTO','PREPARADO','FINALIZADO','CANCELADO') NOT NULL,
    valor_total DECIMAL (10,2) NOT NULL DEFAULT 0.00,
    id_cliente INT NOT NULL,
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente)
);

CREATE TABLE item_pedido(
    id_item INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    observacao VARCHAR(150),
    CONSTRAINT fk_item_pedido FOREIGN KEY (id_pedido) REFERENCES pedido (id_pedido)
);

CREATE TABLE forma_pagamento(
    id_forma_pagamento INT PRIMARY KEY AUTO_INCREMENT ,
    descricao VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE pagamento(
    id_pagamento INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    id_forma_pagamento INT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    data_pagamento DATETIME,
    CONSTRAINT fk_pagamento_pedido FOREIGN KEY (id_pedido) REFERENCES pedido (id_pedido),
    CONSTRAINT fk_pagamento_forma_pagamento FOREIGN KEY (id_forma_pagamento) REFERENCES forma_pagamento (id_forma_pagamento)
);


--INSERINDO DADOS NO BD

INSERT INTO cliente(nome,email,telefone,cidade,ativo) VALUES
('Arthur Nunes','arthur@email.com','1999999991','Rondonia',TRUE),
('Beatriz Raissa','beatriz@email.com','1999999991','Limeira',TRUE),
('Davi Ferreira','davi@email.com',NULL,'Limeira',TRUE),
('Francisco Magri','chico@email.com','1999999994','Limeira',TRUE),
('Franz Kramer','franz@email.com','1999999994','Limeira',TRUE),
('Gabriel Nouqueira','gabriel@email.com','1999999995','Limeira',TRUE),
('Gabrielli Araujo','gabrielli@email.com','1999999996','Americana',TRUE),
('Isabella Alves','isabella@email.com',NULL,'Rondonia',TRUE),
('Keynan Santos','keynan@email.com','1999999998','Santos',TRUE),
('Larissa Ramires','larissa@email.com','1999999998','Limeira',TRUE),
('Leonardo Dia','leonardo@email.com','1999999999','Valinhos',TRUE),
('Luana Lima','luana@email.com','1999999910','Limeira',TRUE),
('Luccas manfredi','luccas@email.com','1999999910','Limeira',TRUE),
('Livia Stein','livia@email.com','1999999991','Campinas',TRUE),
('Dandara Dias','dandara@gmail.com','1999999993','Limeira',TRUE);



INSERT INTO categoria(nome) VALUES
('Cafés'),('Bebidas Geladas'),('Bebidas Quentes'),('Salgados'),('Sobremesas'),
('Combo');

INSERT INTO categoria (nome) VALUES
('Doces');


INSERT INTO produto (nome,preco,id_categoria,ativo) VALUES
('Bebidas Geladas', 23.00,1, TRUE),
('Cafés',8.00,2,TRUE),
('Sobremesas',24.00,3, TRUE),
('Salgados',5.00, 4, TRUE),
('Bebidas Quentes', 8.00, 5,TRUE);



INSERT INTO pedido(data_pedido,status_pedido,valor_total,id_cliente) VALUES
(NOW(),'FINALIZADO',0.00,11),
(NOW(),'PREPARADO',0.00, 8),
(NOW(),'ABERTO',0.00, 12),
(NOW(),'FINALIZADO',0.00, 14),
(NOW(),'CANCELADO',0.00,15);

INSERT INTO item_pedido(quantidade, preco_unitario, observacao)


INSERT INTO forma_pagamento(id_forma_pagamento, descricao)
()

INSERT INTO pagamento()

------------------------------------------------------------------------------------------------
--Atribuir nomes aos IDS

INSERT INTO categoria(nome) VALUES
('Combos Extras');

SET @categorias_novas =(SELECT nome FROM categoria WHERE nome = 'Combos Extras');

SELECT @categorias_novas;






SELECT * FROM pedido;
SET @categoria = LAST_INSERT_ID();

SELECT @categoria;
------------------------------------------------
--ATUALIZANDO OU MODIFICANDO DADOS NO BD
--LEMBRAR DE SEMPRE EXECUTAR O SELECT PARA ATUALIZAR (UPDATE)
--E NUNCA JAMAIS NEVER FAÇA UM UPDATE SEM WHERE😶
--EX 1: Modificando valores individuais
UPDATE Cliente
SET telefone = '1988880001'
WHERE id_cliente = 8

--EX 2 : MODIFICANDO VÁRIOS VALORES
UPDATE cliente
SET telefone = '1999999901',
    cidade = 'Piracicaba'
WHERE id_cliente = 8;


DELETE FROM cliente
WHERE id_cliente = 8;

DELETE FROM produto
WHERE preco;

--CONSULTAR DADOS NO BD
SELECT * FROM Cliente;
WHERE id_cliente = 8;
SELECT * FROM categoria;


--Procedimento de uma compra
--PASSO 1: REALIAR CADASTRO CLIENTE

INSERT INTO cliente(nome, email, telefone,cidade,ativo) VALUES 
('Carlos Silva','carlossilva3@gmail.com',19999999999999,'Santos',TRUE);


SET @cliente_compra = LAST_INSERT_ID();

---PASSO 2: REALIZAR O PEDIDO

INSERT INTO pedido (data_pedido,status, valor_total,id_cliente) VALUES
(NOW(),'ABERTO',0.00,@cliente_compra);

SET @pedido_compra = LAST_INSERT_ID();

--PASSO 3: INSERINDO ITENS

INSERT INTO item_pedido(id_pedido, id_produto, quantidade, preco_unitario) VALUES
(@pedido_compra,4,1,13.00), (@pedido_compra,9,1,9.00);


--PASSO 4- ATUALIZANDO TOTAL E STATUS

UPDATE pedido
SET valor_total = 22.00,
    status= 'PREPARANDO'
WHERE id_pedido = @pedido_compra;

--PASSO 5- REGISTRAR PAGAMENTO

INSERT INTO pagamento(id_pedido,id_forma_pagamento,valor,data_pagamento,valor,data_pagamento)VALUES
(@pedido_compra,2,22.00,NOW());


--PASSO 6 - CONSULAR O PEDIDO E RESULTADO

SELECT p.id_pedido,
c.nome AS Nome_Cliente,
p.status AS Status_Pedido,
p.valor_total AS Compra_Total
FROM pedido p
JOIN cliente c ON c.id_cliente = p.id_cliente
WHERE p.id_pedido = @pedido_compra;


----PASSO 7 - RELATORIO


--TRANSAÇÕES - SEGURANÇA PARA DML

START TRANSACTION;

UPDATE produto
SET preco = preco * 2.80
WHERE id_categoria = 1;


SELECT id_produto, nome, preco
FROM produto
WHERE  id_categoria = 1;
--DESFAZ O QUE FIZEMOS ERRADO OU VOLTA UMA TRANSÇÃO

ROLLBACK;
--VALIDA O PROCEDIMENTO DE TRANSAÇÃO

COMMIT;

START TRANSACTION;

UPDATE cliente SET cidade = 'Santos' WHERE id_cliente = 121;

SELECT * FROM cliente WHERE id_cliente = 121;

COMMIT;

ROLLBACK;


--PROCEDIMENTO DE UMA