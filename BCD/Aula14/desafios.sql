USE smartcoffee_procedures_gabrielli;

-- AULA 13 - ATIVIDADE STORED PROCEDURES
-- Aluno: Gabrielli Araujo Martins Silva
-- Turma: DEVIS

-- 1. listar_clientes_ativos()
DELIMITER $$
CREATE PROCEDURE listar_clientes_ativos()
BEGIN
    SELECT id_cliente, nome, email, telefone
    FROM cliente
    WHERE ativo = TRUE
    ORDER BY nome;
END $$

DROP PROCEDURE listar_clientes_ativos;
DELIMITER;
CALL listar_clientes_ativos();
SELECT * FROM listar_clientes_ativos

-- 2. buscar_produto_por_nome(IN p_busca VARCHAR(100))
DELIMITER$$
CREATE PROCEDURE buscar_produto_por_nome( IN P_ID_PRODUTO INT)
BEGIN
    SELECT ID_PRODUTO AS CÓDIGO, NOME, PRECO
    FROM PRODUTO
    WHERE ID_PRODUTO = P_ID_PRODUTO
    AND ATIVO = TRUE
    ORDER BY NOME;
END

DELIMITER;
CALL buscar_produto_por_nome(3);



-- 3. produtos_por_categoria(IN p_id_categoria INT)
DELIMITER $$
CREATE PROCEDURE produtos_por_categoria( IN P_ID_CATEGORIA INT)
BEGIN
    SELECT ID_PRODUTO AS CÓDIGO, NOME, PRECO
    FROM PRODUTO
    WHERE ID_CATEGORIA = P_ID_CATEGORIA
    AND ATIVO = TRUE
    ORDER BY NOME;
END

DELIMITER;

CALL BUSCAR_PRODUTOS_CATEGORIA(3);

-- 4. total_clientes(OUT p_total INT)

DELIMITER $$
CREATE PROCEDURE total_clientes ( OUT P_TOTAL INT)
BEGIN
    SELECT COUNT(*)
    INTO P_TOTAL
    FROM PRODUTO
    WHERE ATIVO = TRUE;
END $$

DELIMITER;

CALL total_clientes(@total_clientes);
SELECT * FROM cliente;

-- 5. consultar_estoque(IN p_id_produto INT) usando variável local
DELIMITER$$

CREATE PROCEDURE consultar_estoque ( IN P_ID_PRODUTO INT)
BEGIN
    DECLARE V_PRECO DECIMAL(10, 2);
    SELECT PRECO
    INTO V_PRECO
    FROM PRODUTO
    WHERE ID_PRODUTO = P_ID_PRODUTO;
    
    SELECT V_PRECO AS PRECO_PRODUTO;
END$$

DELIMITER;

CALL consultar_estoque(3);

-- 6. classificar estoque: 0 SEM ESTOQUE / <=5 BAIXO / >5 NORMAL
DELIMITER$$
CREATE PROCEDURE classificar_estoque1( IN P_ID_PRODUTO INT)
BEGIN
    DECLARE V_QUANTIDADE INT;

        SELECT QUANTIDADE
        INTO V_QUANTIDADE
        FROM ESTOQUE
        WHERE ID_PRODUTO = P_ID_PRODUTO;

    IF V_QUANTIDADE = 0 THEN
        SELECT 'SEM ESTOQUE' AS SITUAÇÃO;
    ELSEIF V_QUANTIDADE <=5 THEN
        SELECT 'ESTOQUE BAIXO' AS SITUAÇÃO;
    ELSE
        SELECT 'ESTOQUE NORMAL' AS SITUAÇÃO;
    END IF;
END$$

DELIMITER;

CALL classificar_estoque1(2);

-- 7. cadastrar_cliente(...) com três parâmetros IN
DELIMITER$$
CREATE PROCEDURE cadastrar_cliente1 (
    IN P_NOME VARCHAR(100),
    IN P_EMAIL VARCHAR(120),
    IN P_TELEFONE VARCHAR(20)
)
BEGIN
    INSERT INTO CLIENTE(NOME, EMAIL, TELEFONE, ATIVO)
    VALUES (P_NOME, P_EMAIL, P_TELEFONE, TRUE);
END$$

DELIMITER;

CALL cadastrar_cliente1('josé', 'josé@EMAIL.COM', '1999999999');

SELECT * FROM CLIENTE;

-- 8. alterar_preco(...) impedindo valor <= 0 --------------------------------

DELIMITER$$

CREATE PROCEDURE alterar_preco (
    IN P_ID_PRODUTO INT,
    IN P_NOVO_PRECO DECIMAL(10,2)
)
BEGIN
    IF P_NOVO_PRECO > 0 THEN
        UPDATE PRODUTO
        SET PRECO = P_NOVO_PRECO
        WHERE ID_PRODUTO = P_ID_PRODUTO;

        SELECT 'PREÇO ATUALIZADO' AS MENSAGEM;
    ELSE
        SELECT 'PREÇO INVÁLIDO' AS MENSAGEM;
    END IF;
END$$
DELIMITER;
CALL ATUALIZAR_PRECO_PRODUTO(2,14);
SELECT * FROM PRODUTO;

-- 9. criar_pedido(IN p_id_cliente INT, OUT p_id_pedido INT)
DELIMITER $$
CREATE PROCEDURE criar_pedido (
    IN P_ID_CLIENTE INT,
    OUT P_ID_PEDIDO INT
)
BEGIN
    START TRANSACTION;
    INSERT INTO PEDIDO(
        ID_CLIENTE,
        DATA_PEDIDO,
        STATUS_PEDIDO
    )
    
    VALUES (
        P_ID_CLIENTE, NOW(), 'ABERTO'
    );

    SET P_ID_PEDIDO = LAST_INSERT_ID();
    COMMIT;
END $$
DELIMITER;

-- 10. devolver ID com LAST_INSERT_ID()
CALL criar_pedido(1, @PEDIDO);
SELECT @PEDIDO;

-- 11. adicionar_item_pedido(...) buscando o preço atual

delimiter $$
create procedure adicionar_item_pedido2(
    in p_id_pedido int,
    in p_id_produto int,
    in p_quantidade int
)
begin
    declare v_preco decimal(10,2);
    if p_quantidade <= 0 THEN
        select 'QUANTIDADE INVALIDA' as mensagem;
    ELSE
        SELECT preco
        into v_preco
        from produto
        where id_produto = p_id_produto
            and ativo = true;
        
        insert into item_pedido(
            id_pedido, id_produto, quantidade, preco_unitario
        )
        values (
            p_id_pedido, p_id_produto, p_quantidade, v_preco
        );
        select 'ITEM ADICIONADO' as mensagem;
    end if;
end$$
DELIMITER;
call adicionar_item_pedido2(1,2,1);
SELECT * from pedido;

-- 12. Faça uma chamada inválida e explique o resultado.

call adicionar_item_pedido(2, -5);
-- Error: Incorrect number of arguments for PROCEDURE smartcoffee_procedures_gabrielli.adicionar_item_pedido; expected 3, got 1
-- Da esse erro porque precisa conferir os IDs corretos para chama-los

-- 13. Use SHOW CREATE PROCEDURE.

SHOW CREATE PROCEDURE alterar_preco;

-- 14. Remova uma procedure com DROP PROCEDURE IF EXISTS e recrie-a.

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

-- DESAFIO FINAL:
-- Crie uma procedure de negócio com:
-- - pelo menos 2 parâmetros;
-- - variável local;
-- - IF;
-- - pelo menos uma alteração no banco.

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

CALL baixar_estoque_produto(1,1);