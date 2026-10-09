-- Active: 1788519497574@@127.0.0.1@3306@smartcoffe_dml_gabrielli
--AULA 09 - DQL (DATA QUERY LANGUAGE) - LINGUAGEM DE CONSULTA DE DADOS
--EX 1: SELECT SIMPLES

--SELECT coluna
--FROM tabela;

SELECT * FROM cliente;

--CONSULTA TODAS AS COLUNAS NA TABELA

SELECT nome, telefone FROM cliente;
SELECT nome FROM produto;

--CONSULTA DADOS COM VÁRIAS COLUNAS

--EXEMPLO 2: CONSULTANDO E PERSONALIZANDO A CONSULTA

SELECT nome AS Nome_Cliente, telefone AS Contato_Cliente
FROM cliente;

SELECT nome, preco, preco * 1.00 AS preco_ajustado
FROM produto;

--EXERCICIO 3: DISTINCT - ELIMINAR REPETIÇÕES

SELECT DISTINCT cidade
FROM cliente;
SELECT cidade FROM cliente;

--COM DISTINCT CADA RESULTADO É APRESENTADO UMA ÚNICA VEZ
--SEM DISTINCT CADA RESULTADO É APRESENTADO VÁRIAS VEZES

--EXEMPLO 4: USO DE WHERE - FILTRO DE REGISTROS
--INSERIR CONDIÇÕES E UTILIZAR OPERADORES DE COMPARAÇÃO

--=IGUAL
--<> OU ! = DIFERENTE
--> - MAIOR QUE
--< - MENOR QUE
-->= - MAIOR OU IGUAL
--<= MENOR OU IGUAL

SELECT nome, preco FROM produto WHERE preco > 10;
--CONSULTAR PRECOS QUE OSSUEM VALOR ACIMA DE 10.00 REAIS

SELECT nome, preco FROM produto WHERE ativo = FALSE;

--CONSULTAR PRODUTOS ATIVOS OU INATIVOS

SELECT id_pedido, data_pedido, valor_total
FROM pedido WHERE valor_total >= 25.00;
--CONSULTAR VALOR TOTAL DE PRODUTOS ACIMA DE 25.00 REAIS

--EXEMPLO 5: USO DE AND, OR E NOT
--AND - TODAS AS CONDIÇÕES VERDADEIRAS
SELECT nome, preco FROM produto
WHERE preco >= 8.00 AND preco <= 25.00;

--OR -UMA DAS CONDIÇÕES PRECISA SER VERDADEIRA

SELECT nome, cidade FROM cliente
WHERE cidade = 'Limeira' OR cidade = 'Campinas';

--NOT - CRIAR UMA CONDIÇÃO DE NEGAÇÃO

SELECT nome, cidade FROM cliente
WHERE NOT cidade = 'Limeira';

--AND E OR JUNTOS PRECISAMOS INSERIR()

SELECT nome, cidade, ativo FROM cliente
WHERE ativo = TRUE AND (cidade = 'Limeira' OR cidade = 'Piracicaba');

--EXEMPLO 6: BETWEEM - PESQUISAR POR INTERVALOS
--LIMITE INICIAL E FINAL

SELECT nome, preco FROM produto WHERE preco BETWEEN 8.00 AND 15.00
--CONSULTAR POR INTERVALOS DE VALORES

SELECT id_pedido, data_pedido, valor_total
FROM pedido
WHERE data_pedido BETWEEN '2026-09-01 00:00:00' AND '2026-09-30 23:59:59';

--CONSULTAR DADOS POR INTERVALO DE DATA
--EXEMPLO 7: IN - MUITAS POSSIBILIDADES

SELECT nome, cidade FROM cliente
WHERE cidade IN ('Limeira','Piracicaba','Americana');

SELECT nome, cidade FROM cliente
WHERE cidade NOT IN ('Limeira','Piracicaba');

--EXEMPLO 8: LIKE - PESQUISA POR TEXTOS
--CORINGA
--% VARIOS CARACTERES
--_APENAS UM CARACTER

SELECT nome FROM produto
WHERE nome LIKE 'Café%';
--CONSULTA PELA PALAVRA QUE DESEJA E QUAL COMEÇA

SELECT nome FROM produto
WHERE nome LIKE '%chocolate%';
--CONSULA PELA PALAVRA QUE CONTEM CHOCOLATE

SELECT nome FROM cliente
WHERE nome LIKE '%Silva';

SELECT nome FROM produto
WHERE nome LIKE '%o_o%';

--EXEMPLO 9: NULL - AUSÊNCIA DE VALOR

SELECT nome, telefone FROM cliente
WHERE telefone IS NULL;

SELECT nome, telefone FROM cliente
WHERE telefone IS NULL;

--OBSERVAÇÃO
SELECT nome, telefone FROM cliente
WHERE telefone = 'NULL';

--EXEMPLO 10: ORDER BY - ORDENAR RESULTADOS
--ASC é crescente
--DESC decrescente

SELECT nome, preco FROM produto
ORDER BY preco ASC;

SELECT nome, preco FROM produto
ORDER BY preco DESC;

SELECT nome, preco FROM produto
ORDER BY nome ASC,preco DESC;

SELECT cidade, nome FROM cliente
ORDER BY cidade ASC, nome DESC;

--ORDERNAR POR MAIS DE UMA COLUNA

--EXEMPLO 11: LIMIT DETERMINAR UMA QUANTIDADE DE LINHAS
SELECT nome, preco
FROM produto
ORDER BY preco DESC
LIMIT 10;


SELECT nome, preco
FROM produto
ORDER BY nome
LIMIT 10 OFFSET 5;

--EXEMPLO 12: CÁLCULOS EM COLUNAS
SELECT nome, preco, preco * 1.30 AS Preço_Reajuste
FROM produto;

SELECT id_item, quantidade, preco_unitario, quantidade * preco_unitario AS Subtotal FROM item_pedido;
--EXEMPLO 13 : FUNÇÕES
--TEXTOS
SELECT UPPER(nome) AS NOME_M, LOWER(cidade) AS  cidade_m
FROM cliente;
--USO DE MAIUSCULO E MINUSCULO
SELECT CONCAT(nome, '--', cidade) AS Cliente_Cidades
FROM cliente;

--NÚMEROS
SELECT nome, preco, ROUND(preco*0.90, 2) AS Preço_Desconto
FROM produto;

--DATA
SELECT id_pedido,data_pedido,valor_total, DATE(data_pedido) AS DATAS, MONTH (data_pedido) AS MÊS, YEAR(data_pedido) AS ANO, DAY(data_pedido) AS DIAS
FROM pedido;

--SUBSTITUIR O NULL NO RESULTADO COM COALESCE
SELECT nome, COALESSE(telefone, 'Não possui telefone') AS telefone FROM cliente;

--EXEMPLO 14: FUNÇÕES DE AGREGAÇÃO
---COUNT= SOMAR VALORES COM UMA QUANTIDADE
--SUM = CONTAR UMA QUANTIDADE
--AVG= CALCULAR MEDIA
--MIN= MINIMO VALOR
--MAS= MASXIMO VALOR

SELECT COUNT(*) AS TOTAL_CLINTE
FROM cliente;
--QUANTOS EXISTEM NA TELA

SELECT AVG(preco) AS Preço_medio_produtos
FROM produto;
--PREÇO  MEDIO DOS PRODUTOS

SELECT MIN((preco),2) AS Preços_Baixos,
ROUNDMAX_((preco),2) AS Preco_Alto,
ROUNDAVG((preco),2) AS Média_preco
FROM produto;

--RESUMO DE PREÇOS

SELECT SUM(valor_total) AS FATURAMENTO
FROM pedido
WHERE status = 'Preparando';

--total de pedidos com critério

--EXEMPLO 15: GROUP BY - AGRUPAR DADOS

SELECT cidade, COUNT(*) AS QTDE_CLIENTES
FROM cliente
GROUP BY cidade;
--quantos clientes tem tenho em uma cidade

SELECT id_categoria, COUUNT(*) AS QTDE_PRODUTOS
FROM produto
GROUP BY id_categoria;
--QUANTIDADE DE PRODUTOS POR CATEGORIA

--EXEMPLO 16: HAVING - CRIAR CONDIÇÕES EM AGRUPAMENTOS
--WHERE FILTRA LINHAS ANTES DO AGRUPAMENTO
--HAVING FILTRA LINHAS DEPOIS DO GROUP BY

SELECT cidade, COUNT(*) AS QTDE_CLIENTES
FROM cliente
GROUP BY cidade
HAVING COUNT(*) <=10;
--CONSULTA PARA CIDADES COM PELO MENOS DOIS CLIENTES

--EXEMPLO 17: RESUMO DE UMA CONSULTA COMPLETA
SELECT colunas
FROM tabela
WHERE condicao
GROUP BY coluna_agrupar
HAVING condicao_agrupar
ORDER BY colunas
LIMIT quantidade;