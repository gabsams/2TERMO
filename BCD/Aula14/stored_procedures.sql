-- Active: 1794486439517@@127.0.0.1@3306@smartcoffee_procedures_gabrielli
DROP DATABASE IF EXISTS smartcoffee_procedures_gabrielli;
CREATE DATABASE smartcoffee_procedures_gabrielli;
USE smartcoffee_procedures_gabrielli;

CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    pontos_fidelidade INT NOT NULL DEFAULT 0,
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE produto (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    id_categoria INT NOT NULL,
    nome VARCHAR(120) NOT NULL,
    preco DECIMAL(10,2) NOT NULL CHECK (preco > 0),
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);

CREATE TABLE estoque (
    id_produto INT PRIMARY KEY,
    quantidade INT NOT NULL DEFAULT 0 CHECK (quantidade >= 0),
    FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);

CREATE TABLE pedido (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    data_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status_pedido VARCHAR(20) NOT NULL DEFAULT 'ABERTO'
        CHECK (status_pedido IN ('ABERTO','PAGO','CANCELADO','FINALIZADO')),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE item_pedido (
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL CHECK (quantidade > 0),
    preco_unitario DECIMAL(10,2) NOT NULL CHECK (preco_unitario > 0),
    PRIMARY KEY (id_pedido, id_produto),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);

INSERT INTO cliente(nome,email,telefone,pontos_fidelidade) VALUES
('Ana Martins','ana@smartcoffee.com','19999990001',80),
('Carlos Lima','carlos@smartcoffee.com',NULL,20),
('Marina Souza','marina@smartcoffee.com','19999990003',150);

INSERT INTO categoria(nome) VALUES
('Cafés'),('Bebidas'),('Doces');

INSERT INTO produto(id_categoria,nome,preco) VALUES
(1,'Espresso',8.50),
(1,'Cappuccino',13.90),
(2,'Suco de Laranja',11.00),
(3,'Brownie',12.50),
(3,'Cheesecake',16.90);

INSERT INTO estoque(id_produto,quantidade) VALUES
(1,20),(2,4),(3,0),(4,8),(5,3);






- ============================================================================
-- AULA 13 - STORED PROCEDURES (SMARTCOFFEE)
-- Script unificado com todos os exercícios (1 a 14) e o Desafio Final
-- ============================================================================

-- ============================================================================
-- EXERCÍCIO 1: Criar a procedure listar_clientes_ativos()
-- ============================================================================
DROP PROCEDURE IF EXISTS listar_clientes_ativos;
DELIMITER $$
CREATE PROCEDURE listar_clientes_ativos()
BEGIN
SELECT id_cliente, nome, email, telefone
FROM cliente
WHERE ativo = TRUE
ORDER BY nome;
END $$
DELIMITER ;
-- Teste:
CALL listar_clientes_ativos();

-- ============================================================================
-- EXERCÍCIO 2: Criar buscar_produto_por_nome(IN p_busca VARCHAR(100)) com LIKE
-- ============================================================================
DROP PROCEDURE IF EXISTS buscar_produto_por_nome;
DELIMITER $$
CREATE PROCEDURE buscar_produto_por_nome(
IN p_busca VARCHAR(100)
)
BEGIN
SELECT id_produto, nome, preco
FROM produto
WHERE nome LIKE CONCAT('%', p_busca, '%')
AND ativo = TRUE
ORDER BY nome;
END $$
DELIMITER ;
-- Teste:
CALL buscar_produto_por_nome('Café');

-- ============================================================================
-- EXERCÍCIO 3: Criar produtos_por_categoria(IN p_id_categoria INT)
-- ============================================================================
DROP PROCEDURE IF EXISTS produtos_por_categoria;
DELIMITER $$
CREATE PROCEDURE produtos_por_categoria(
IN p_id_categoria INT
)
BEGIN
SELECT id_produto, nome, preco
FROM produto
WHERE id_categoria = p_id_categoria
AND ativo = TRUE
ORDER BY nome;
END $$
DELIMITER ;
-- Teste:
CALL produtos_por_categoria(1);

-- ============================================================================
-- EXERCÍCIO 4: Criar total_clientes(OUT p_total INT)
-- ============================================================================
DROP PROCEDURE IF EXISTS total_clientes;
DELIMITER $$
CREATE PROCEDURE total_clientes(
OUT p_total INT
)
BEGIN
SELECT COUNT()
INTO p_total
FROM cliente
WHERE ativo = TRUE;
END $$
DELIMITER ;
-- Teste:
CALL total_clientes(@total_clientes);
SELECT @total_clientes AS total_clientes_ativos;

-- ============================================================================
-- EXERCÍCIO 5: Criar consultar_estoque(IN p_id_produto INT) com variável local
-- ============================================================================
DROP PROCEDURE IF EXISTS consultar_estoque;
DELIMITER $$
CREATE PROCEDURE consultar_estoque(
IN p_id_produto INT
)
BEGIN
DECLARE v_quantidade INT;
SELECT quantidade
INTO v_quantidade
FROM estoque
WHERE id_produto = p_id_produto;
SELECT p_id_produto AS id_produto, v_quantidade AS quantidade_estoque;
END $$
DELIMITER ;
-- Teste:
CALL consultar_estoque(1);

-- ============================================================================
-- EXERCÍCIO 6: Classificação de estoque (0 = SEM ESTOQUE; <= 5 = BAIXO; > 5 = NORMAL)
-- ============================================================================
DROP PROCEDURE IF EXISTS classificar_estoque;
DELIMITER $$
CREATE PROCEDURE classificar_estoque(
IN p_id_produto INT
)
BEGIN
DECLARE v_quantidade INT;
SELECT quantidade
INTO v_quantidade
FROM estoque
WHERE id_produto = p_id_produto;
IF v_quantidade = 0 THEN
SELECT 'SEM ESTOQUE' AS situacao;
ELSEIF v_quantidade <= 5 THEN
SELECT 'BAIXO' AS situacao;
ELSE
SELECT 'NORMAL' AS situacao;
END IF;
END $$
DELIMITER ;
-- Teste:
CALL classificar_estoque(1);

-- ============================================================================
-- EXERCÍCIO 7: Criar cadastrar_cliente(...) com três parâmetros IN
-- ============================================================================
DROP PROCEDURE IF EXISTS cadastrar_cliente;
DELIMITER $$
CREATE PROCEDURE cadastrar_cliente(
IN p_nome VARCHAR(100),
IN p_email VARCHAR(120),
IN p_telefone VARCHAR(20)
)
BEGIN
INSERT INTO cliente (nome, email, telefone, ativo)
VALUES (p_nome, p_email, p_telefone, TRUE);
END $$
DELIMITER ;
-- Teste:
CALL cadastrar_cliente('Carlos Lima', 'carlos.lima@email.com', '19988887777');

-- ============================================================================
-- EXERCÍCIO 8: Criar alterar_preco(...) impedindo preço menor ou igual a zero
-- ============================================================================
DROP PROCEDURE IF EXISTS alterar_preco;
DELIMITER $$
CREATE PROCEDURE alterar_preco(
IN p_id_produto INT,
IN p_novo_preco DECIMAL(10,2)
)
BEGIN
IF p_novo_preco > 0 THEN
UPDATE produto
SET preco = p_novo_preco
WHERE id_produto = p_id_produto;
SELECT 'PREÇO ATUALIZADO COM SUCESSO' AS mensagem;
ELSE
SELECT 'ERRO: O PREÇO DEVE SER MAIOR QUE ZERO' AS mensagem;
END IF;
END $$
DELIMITER ;
-- Teste:
CALL alterar_preco(1, 14.50);

-- ============================================================================
-- EXERCÍCIOS 9 e 10: Criar criar_pedido(...) devolvendo ID com LAST_INSERT_ID()
-- ============================================================================
DROP PROCEDURE IF EXISTS criar_pedido;
DELIMITER $$
CREATE PROCEDURE criar_pedido(
IN p_id_cliente INT,
OUT p_id_pedido INT
)
BEGIN
START TRANSACTION;
INSERT INTO pedido (id_cliente, data_pedido, status_pedido)
VALUES (p_id_cliente, NOW(), 'ABERTO');
SET p_id_pedido = LAST_INSERT_ID();
COMMIT;
END $$
DELIMITER ;
-- Teste:
CALL criar_pedido(1, @novo_pedido);
SELECT @novo_pedido AS id_pedido_criado;

-- ============================================================================
-- EXERCÍCIO 11: Criar adicionar_item_pedido(...) buscando o preço atual
-- ============================================================================
DROP PROCEDURE IF EXISTS adicionar_item_pedido;
DELIMITER $$
CREATE PROCEDURE adicionar_item_pedido(
IN p_id_pedido INT,
IN p_id_produto INT,
IN p_quantidade INT
)
BEGIN
DECLARE v_preco DECIMAL(10,2);
IF p_quantidade <= 0 THEN
SELECT 'QUANTIDADE INVÁLIDA' AS mensagem;
ELSE
SELECT preco
INTO v_preco
FROM produto
WHERE id_produto = p_id_produto
AND ativo = TRUE;
IF v_preco IS NULL THEN
SELECT 'PRODUTO INEXISTENTE OU INATIVO' AS mensagem;
ELSE
INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario)
VALUES (p_id_pedido, p_id_produto, p_quantidade, v_preco);
SELECT 'ITEM ADICIONADO' AS mensagem;
END IF;
END IF;
END $$
DELIMITER ;
-- Teste:
CALL adicionar_item_pedido(@novo_pedido, 1, 2);

-- ============================================================================
-- EXERCÍCIO 12: Testar chamada inválida e descrever o que aconteceu
-- ============================================================================
-- Teste A (Validação interna via IF):
CALL alterar_preco(1, -5.00);
-- O que aconteceu: A condição (p_novo_preco > 0) retorna falso, o UPDATE não é
-- executado, o preço original na tabela produto é preservado e a procedure
-- retorna a mensagem 'ERRO: O PREÇO DEVE SER MAIOR QUE ZERO'.
-- Teste B (Violação de constraint UNIQUE - descomente a linha abaixo para testar):
-- CALL cadastrar_cliente('Outro Nome', 'carlos.lima@email.com', '19977776666');
-- O que aconteceu: Mesmo dentro de uma procedure, as constraints da tabela
-- continuam ativas. O MySQL bloqueia a inserção e dispara o erro
-- "ERROR 1062: Duplicate entry ... for key 'email'".

-- ============================================================================
-- EXERCÍCIO 13: Usar SHOW CREATE PROCEDURE em uma rotina
-- ============================================================================
SHOW CREATE PROCEDURE alterar_preco;

-- ============================================================================
-- EXERCÍCIO 14: Remover uma procedure com DROP PROCEDURE IF EXISTS e recriá-la
-- ============================================================================
DROP PROCEDURE IF EXISTS listar_clientes_ativos;
DELIMITER $$
CREATE PROCEDURE listar_clientes_ativos()
BEGIN
SELECT id_cliente, nome, email, telefone
FROM cliente
WHERE ativo = TRUE
ORDER BY nome;
END $$
DELIMITER ;

-- ============================================================================
-- DESAFIO FINAL: Regra de negócio (baixa de estoque + inativação automática)
-- ============================================================================
-- Requisitos atendidos:
-- * 2 parâmetros (p_id_produto, p_qtd_saida)
-- * 1 variável local (v_estoque_atual)
-- * Decisões com IF / ELSEIF / ELSE
-- * Alteração no banco (UPDATE em estoque e, se zerar, UPDATE em produto)
--
-- Resumo para apresentação oral:
-- 1. Problema resolvido: Evita venda sem saldo e inativa itens esgotados.
-- 2. Entradas: ID do produto e quantidade de saída.
-- 3. Decisão: Valida quantidade > 0 e saldo suficiente; se zerar, inativa.
-- 4. Alteração no banco: Debita estoque e atualiza ativo = FALSE se saldo = 0.
-- 5. O que pode dar errado: Falha entre os UPDATEs sem transação ou vendas
-- simultâneas sem bloqueio de linha (concorrência).
DROP PROCEDURE IF EXISTS baixar_estoque_produto;
DELIMITER $$
CREATE PROCEDURE baixar_estoque_produto(
IN p_id_produto INT,
IN p_qtd_saida INT
)
BEGIN
DECLARE v_estoque_atual INT;
IF p_qtd_saida <= 0 THEN
SELECT 'ERRO: QUANTIDADE DE SAÍDA INVÁLIDA' AS status;
ELSE
SELECT quantidade
INTO v_estoque_atual
FROM estoque
WHERE id_produto = p_id_produto;
IF v_estoque_atual IS NULL THEN
SELECT 'ERRO: PRODUTO NÃO ENCONTRADO NO ESTOQUE' AS status;
ELSEIF v_estoque_atual < p_qtd_saida THEN
SELECT 'ERRO: ESTOQUE INSUFICIENTE PARA A OPERAÇÃO' AS status;
ELSE
START TRANSACTION;
UPDATE estoque
SET quantidade = quantidade - p_qtd_saida
WHERE id_produto = p_id_produto;
IF (v_estoque_atual - p_qtd_saida) = 0 THEN
UPDATE produto
SET ativo = FALSE
WHERE id_produto = p_id_produto;
END IF;
COMMIT;
SELECT 'BAIXA DE ESTOQUE REALIZADA COM SUCESSO' AS status;
END IF;
END IF;
END $$
DELIMITER ;
-- Teste do Desafio Final:
CALL baixar_estoque_produto(1.1);