-- ============================================================
-- AULA 08 - ATIVIDADE PRÁTICA DE DML
-- Nome: Gabrielli Araujo 
-- Turma: ______________________ Data: _________________
-- Base: smartcoffee_dml
-- ============================================================
USE SMARTCOFFE_DML_GABRIELLI;

-- IMPORTANTE:
-- Para toda questão de UPDATE ou DELETE, escreva primeiro um SELECT
-- com o mesmo WHERE para validar os registros afetados.

-- PARTE A - INSERT

-- 1. Cadastre dois novos clientes com dados diferentes.
INSERT INTO cliente(nome,email,telefone,cidade,ativo) VALUES
('Evellyn Hanna','evellynherrera@email.com',1322222222222,'Santos',TRUE),
('Felipe Cardoso','felipecardoso@gmail.com',13332222222,'Salvador',TRUE);

-- 2. Cadastre a categoria 'Especiais da Casa'.
INSERT INTO categoria(nome) VALUES
('Especial da Casa');

-- 3. Localize o id da categoria criada e cadastre três produtos nela.
SET @categoria_especial= (SELECT id_categoria FROM  categoria WHERE  nome= 'Especial da Casa');

INSERT INTO categoria(id_categoria,nome) VALUES
(14,'lanche'),
(15,'bolo de cenoura'),
(16,'Fondue');


INSERT INTO categoria (nome,id_categoria)VALUES
('Acai',17);


-- 4. Cadastre um terceiro cliente sem telefone.
INSERT INTO cliente(nome,email,telefone,cidade,ativo) VALUES
('Leticia Visenthainer','leticia2visenthainer@gmail.com',NULL,'Xique-Xique',TRUE);
select*from cliente;


-- 5. Crie um novo pedido para um dos clientes cadastrados.

INSERT INTO pedido (data_pedido,status_pedido,valor_total,id_cliente) VALUES
(NOW(),'ABERTO',0.00,19);

SET @pedido_compra = LAST_INSERT_ID();

-- 6. Use LAST_INSERT_ID() para guardar o id do pedido em @pedido_atividade
--    e insira pelo menos dois itens nesse pedido.
INSERT INTO pedido (data_pedido,status_pedido,valor_total,id_cliente) VALUES
(NOW(),'ABERTO',0.00,19),
(NOW(),'FINALIZADO',23.00,18);

SET @pedido_compra = LAST_INSERT_ID();

SELECT*FROM pedido;

-- PARTE B - UPDATE

-- 7. Corrija o telefone de um dos clientes criados.
-- SELECT de validação:
-- UPDATE:
-- SELECT final:
UPDATE Cliente
SET telefone = '10667667867'
WHERE id_cliente = 18;
SELECT * FROM Cliente;
-- 8. Altere cidade e telefone de outro cliente em um único UPDATE.

UPDATE Cliente
SET telefone = '67676767667',
    cidade = 'Pindamonhangaba'
WHERE id_cliente = 14;
SELECT * FROM categoria;

-- 9. Aumente em 8% o preço dos produtos da categoria 'Especiais da Casa'.

UPDATE preco
SET preco = preco * 0.08
WHERE id_categoria = 12;

-- 10. Altere o status do pedido criado para 'PREPARANDO'.


-- 11. Atualize valor_total do pedido de acordo com os itens cadastrados.
--     Você pode calcular previamente com SELECT SUM(quantidade * preco_unitario).


-- 12. Escolha um dos produtos criados e faça uma exclusão lógica (ativo = FALSE).


-- PARTE C - DELETE

-- 13. Crie um cliente de teste sem pedidos.
--     Depois localize e exclua apenas esse cliente.


-- 14. Tente excluir um cliente da base original que possua pedidos.
--     Deixe o DELETE comentado após o teste e descreva o erro abaixo.
-- Resultado observado:


-- 15. Explique em comentário por que a FK bloqueou a exclusão.
-- Resposta:


-- 16. Crie uma categoria temporária chamada 'Excluir Depois' e remova-a.

