/* =====================================================================
   P2 - BANCO DE DADOS | 05 - CONTAR, SOMAR E AGRUPAR (GROUP BY)
   ---------------------------------------------------------------------
   Aulas do professor: 10 (Exercicios do Select, parte final),
   13 (Agrupando dados) e 14 (DQL Avancado: ISNULL, ROLLUP, CASE).

   Antes: rode o p2-00-base-livraria.sql
   Rode um bloco por vez: selecione o bloco e aperte F5.
   ===================================================================== */


/* ---------------------------------------------------------------------
   1) FUNCOES DE AGREGACAO (varias linhas viram UM numero)
   ---------------------------------------------------------------------
     COUNT(*)      quantas linhas
     SUM(COL)      soma
     AVG(COL)      media
     MAX(COL)      maior valor
     MIN(COL)      menor valor

   ---------------------------------------------------------------------
   2) GROUP BY = fazer a conta POR GRUPO
   ---------------------------------------------------------------------
     Sem GROUP BY: "quantos livros tem?"           -> 1 numero
     Com GROUP BY: "quantos livros tem POR categoria?" -> 1 numero por categoria

       SELECT COD_CATEGORIA, COUNT(*)
       FROM LIVRO
       GROUP BY COD_CATEGORIA

     REGRA: coluna que aparece no SELECT sem COUNT/SUM/... TEM que
     estar no GROUP BY.

   ---------------------------------------------------------------------
   3) WHERE x HAVING
   ---------------------------------------------------------------------
     WHERE  filtra as LINHAS antes de agrupar
     HAVING filtra os GRUPOS depois de agrupar (aceita COUNT, SUM...)

       ... GROUP BY COD_CATEGORIA HAVING COUNT(*) > 2
       ("so as categorias com mais de 2 livros")

   Ordem de escrever:
     SELECT -> FROM -> WHERE -> GROUP BY -> HAVING -> ORDER BY

   ---------------------------------------------------------------------
   4) EXTRAS DA AULA 14
   ---------------------------------------------------------------------
     ISNULL(COL, 0)   troca vazio (NULL) por 0
     WITH ROLLUP      acrescenta linhas de subtotal e total geral
     CASE             um "se" dentro do SELECT:
         CASE WHEN PRECO < 50 THEN 'BARATO' ELSE 'CARO' END

   CUIDADO NA PROVA:
     - COUNT(*) conta todas as linhas; COUNT(EMAIL) conta so quem tem email
     - filtro com COUNT/SUM vai no HAVING, nao no WHERE
   --------------------------------------------------------------------- */

USE P2_LIVRARIA
GO

-- =====================================================================
-- EXEMPLOS
-- =====================================================================

-- Exemplo 1: contas na tabela toda (resultado = 1 linha)
SELECT COUNT(*)     AS QTD_LIVROS,
       SUM(ESTOQUE) AS TOTAL_ESTOQUE,
       AVG(PRECO)   AS PRECO_MEDIO,
       MAX(PRECO)   AS MAIS_CARO,
       MIN(PRECO)   AS MAIS_BARATO
FROM LIVRO

-- Exemplo 2: COUNT(*) x COUNT(coluna)
SELECT COUNT(*)     AS TODOS_OS_CLIENTES,    -- 10
       COUNT(EMAIL) AS COM_EMAIL             -- 7 (nao conta os NULL)
FROM CLIENTE

-- Exemplo 3: GROUP BY -> quantos livros por categoria
SELECT COD_CATEGORIA, COUNT(*) AS QTD
FROM LIVRO
GROUP BY COD_CATEGORIA

-- Exemplo 4: GROUP BY com JOIN -> o nome da categoria no lugar do codigo
SELECT C.NOME AS CATEGORIA, COUNT(*) AS QTD, AVG(L.PRECO) AS PRECO_MEDIO
FROM CATEGORIA C
    INNER JOIN LIVRO L ON C.COD_CATEGORIA = L.COD_CATEGORIA
GROUP BY C.NOME

-- Exemplo 5: valor total de cada pedido (soma dos itens)
SELECT NUM_PEDIDO, SUM(QUANTIDADE * PRECO_UNIT) AS TOTAL
FROM ITEM_PEDIDO
GROUP BY NUM_PEDIDO

-- Exemplo 6: HAVING -> so clientes com 2 pedidos ou mais
SELECT CL.NOME, COUNT(*) AS QTD_PEDIDOS
FROM CLIENTE CL
    INNER JOIN PEDIDO P ON CL.COD_CLIENTE = P.COD_CLIENTE
GROUP BY CL.NOME
HAVING COUNT(*) >= 2

-- Exemplo 7: WHERE e HAVING juntos
-- WHERE: so pedidos de 2025 | HAVING: so vendedores com mais de 2 desses pedidos
SELECT F.NOME, COUNT(*) AS PEDIDOS_2025
FROM FUNCIONARIO F
    INNER JOIN PEDIDO P ON F.COD_FUNC = P.COD_FUNC
WHERE P.DATA_PEDIDO BETWEEN '20250101' AND '20251231'
GROUP BY F.NOME
HAVING COUNT(*) > 2

-- Exemplo 8: ISNULL -> quem nao comprou nada aparece com 0 (e nao NULL)
SELECT CL.NOME, ISNULL(SUM(I.QUANTIDADE * I.PRECO_UNIT), 0) AS TOTAL_COMPRADO
FROM CLIENTE CL
    LEFT JOIN PEDIDO P      ON CL.COD_CLIENTE = P.COD_CLIENTE
    LEFT JOIN ITEM_PEDIDO I ON P.NUM_PEDIDO   = I.NUM_PEDIDO
GROUP BY CL.NOME

-- Exemplo 9: ROLLUP -> estoque por categoria e, no fim, uma linha a mais
-- com COD_CATEGORIA NULL: essa linha e o TOTAL GERAL
SELECT COD_CATEGORIA, SUM(ESTOQUE) AS ESTOQUE
FROM LIVRO
GROUP BY COD_CATEGORIA WITH ROLLUP

-- Exemplo 10: CASE -> classificar cada livro pelo preco
SELECT TITULO, PRECO,
       CASE
           WHEN PRECO < 50 THEN 'BARATO'
           WHEN PRECO < 80 THEN 'MEDIO'
           ELSE 'CARO'
       END AS FAIXA
FROM LIVRO


-- =====================================================================
-- EXERCICIOS
-- =====================================================================

-- E1) Qual o maior e o menor salario da empresa?


-- E2) Quanto a empresa gasta com salarios por mes (soma)?


-- E3) Quantos clientes NAO tem email?


-- E4) Mostre cada cargo e quantos funcionarios tem nele.


-- E5) Mostre o nome de cada departamento e a media salarial dele.


-- E6) Mostre cada UF e quantos clientes moram nela.


-- E7) Mostre o titulo de cada livro e quantas unidades ele vendeu no
--     total, so dos que venderam 3 ou mais.


-- E8) Mostre os pedidos com valor total acima de 150.


-- E9) Mostre o nome das categorias que tem mais de 2 livros.


-- E10) Por que este SELECT da erro? Corrija.
--      SELECT COD_DEPTO, NOME, AVG(SALARIO) FROM FUNCIONARIO GROUP BY COD_DEPTO



/* =====================================================================
   RESPOSTAS - so desca ate aqui depois de tentar!
   =====================================================================















   ===================================================================== */
/* ==== RESPOSTAS

-- E1
SELECT MAX(SALARIO) AS MAIOR, MIN(SALARIO) AS MENOR FROM FUNCIONARIO

-- E2
SELECT SUM(SALARIO) AS TOTAL_SALARIOS FROM FUNCIONARIO

-- E3  (resposta: 3)
SELECT COUNT(*) AS SEM_EMAIL FROM CLIENTE WHERE EMAIL IS NULL

-- E4
SELECT CARGO, COUNT(*) AS QTD
FROM FUNCIONARIO
GROUP BY CARGO

-- E5
SELECT D.NOME, AVG(F.SALARIO) AS MEDIA
FROM DEPARTAMENTO D
    INNER JOIN FUNCIONARIO F ON D.COD_DEPTO = F.COD_DEPTO
GROUP BY D.NOME

-- E6
SELECT CI.UF, COUNT(*) AS QTD_CLIENTES
FROM CLIENTE CL
    INNER JOIN CIDADE CI ON CL.COD_CIDADE = CI.COD_CIDADE
GROUP BY CI.UF

-- E7
SELECT L.TITULO, SUM(I.QUANTIDADE) AS QTD_VENDIDA
FROM LIVRO L
    INNER JOIN ITEM_PEDIDO I ON L.COD_LIVRO = I.COD_LIVRO
GROUP BY L.TITULO
HAVING SUM(I.QUANTIDADE) >= 3

-- E8
SELECT NUM_PEDIDO, SUM(QUANTIDADE * PRECO_UNIT) AS TOTAL
FROM ITEM_PEDIDO
GROUP BY NUM_PEDIDO
HAVING SUM(QUANTIDADE * PRECO_UNIT) > 150

-- E9
SELECT C.NOME, COUNT(*) AS QTD
FROM CATEGORIA C
    INNER JOIN LIVRO L ON C.COD_CATEGORIA = L.COD_CATEGORIA
GROUP BY C.NOME
HAVING COUNT(*) > 2

-- E10
-- NOME nao esta no GROUP BY e nao tem COUNT/SUM/AVG em volta.
-- O banco nao sabe qual nome mostrar para o grupo. Tirando o NOME:
SELECT COD_DEPTO, AVG(SALARIO) AS MEDIA FROM FUNCIONARIO GROUP BY COD_DEPTO

==== FIM RESPOSTAS */
