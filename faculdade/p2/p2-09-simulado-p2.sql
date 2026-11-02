/* =====================================================================
   P2 - BANCO DE DADOS | 09 - SIMULADO (tudo misturado)
   ---------------------------------------------------------------------
   Faca este por ultimo, depois dos arquivos 01 a 08.
   Tente sem olhar os outros arquivos. Cada questao diz o assunto entre
   colchetes, para voce saber o que revisar se errar.

   Antes: rode o p2-00-base-livraria.sql
   ===================================================================== */

USE P2_LIVRARIA
GO

-- Q1) [DDL] Crie a tabela AVALIACAO_LIVRO com:
--     COD_AVALIACAO inteiro automatico (PK), COD_LIVRO inteiro obrigatorio
--     (FK para LIVRO), NOTA inteiro obrigatorio de 1 a 5, COMENTARIO texto 100.


-- Q2) [DML] Cadastre duas avaliacoes para o livro 7: nota 5 e nota 4.


-- Q3) [DDL] Adicione a coluna DATA_AVALIACAO (data) que, se nao for
--     informada, recebe a data de hoje.


-- Q4) [SELECT] Mostre os livros de HUGO MATOS ou de BIA FONTES que custam
--     mais de 30, do mais caro para o mais barato.


-- Q5) [SELECT] Mostre os clientes cadastrados em 2024 que tem email.


-- Q6) [JOIN] Mostre o numero do pedido, o nome do cliente, a cidade do
--     cliente e o nome do vendedor.


-- Q7) [JOIN] Mostre os funcionarios que nao tem departamento e os
--     departamentos que nao tem funcionario (dois SELECTs).


-- Q8) [GROUP BY] Mostre o nome de cada vendedor e quantos pedidos ele
--     atendeu, so de quem atendeu 3 ou mais.


-- Q9) [GROUP BY] Mostre o nome de cada categoria e o valor total vendido
--     dos livros dela.


-- Q10) [SUBSELECT] Mostre os livros que custam mais que o livro
--      'O PLANETA AZUL'.


-- Q11) [VIEW] Crie a view VW_VENDAS_VENDEDOR com o nome do vendedor e o
--      total vendido. Use a view para mostrar so quem vendeu mais de 300.


-- Q12) [PROCEDURE] Crie a procedure USP_PEDIDOS_DO_MES que recebe um mes
--      e um ano e mostra os pedidos feitos nesse mes.
--      Dica: MONTH(DATA_PEDIDO) e YEAR(DATA_PEDIDO)


-- Q13) [TEORIA] Responda em uma frase:
--      a) Diferenca entre DELETE sem WHERE e TRUNCATE?
--      b) Diferenca entre WHERE e HAVING?
--      c) O que acontece se eu esquecer a condicao do JOIN?
--      d) Uma view guarda dados?


-- Q14) Limpe o que voce criou: apague a view, a procedure e a tabela.



/* =====================================================================
   RESPOSTAS - so desca ate aqui depois de tentar!
   =====================================================================















   ===================================================================== */
/* ==== RESPOSTAS

-- Q1
CREATE TABLE AVALIACAO_LIVRO (
    COD_AVALIACAO  INT          NOT NULL IDENTITY(1,1),
    COD_LIVRO      INT          NOT NULL,
    NOTA           INT          NOT NULL,
    COMENTARIO     VARCHAR(100),
    CONSTRAINT PK_AVALIACAO_LIVRO PRIMARY KEY (COD_AVALIACAO),
    CONSTRAINT FK_AVALIACAO_LIVRO FOREIGN KEY (COD_LIVRO) REFERENCES LIVRO (COD_LIVRO),
    CONSTRAINT CK_AVALIACAO_NOTA  CHECK (NOTA BETWEEN 1 AND 5)
)
GO

-- Q2  (COD_AVALIACAO e IDENTITY: nao entra no INSERT)
INSERT INTO AVALIACAO_LIVRO (COD_LIVRO, NOTA, COMENTARIO) VALUES
    (7, 5, 'OTIMO'),
    (7, 4, NULL)
GO

-- Q3
ALTER TABLE AVALIACAO_LIVRO ADD DATA_AVALIACAO DATE DEFAULT GETDATE()
GO

-- Q4  (parenteses no OR, senao o AND pega so a BIA FONTES)
SELECT TITULO, AUTOR, PRECO FROM LIVRO
WHERE (AUTOR = 'HUGO MATOS' OR AUTOR = 'BIA FONTES') AND PRECO > 30
ORDER BY PRECO DESC

-- Q5
SELECT NOME, EMAIL, DATA_CADASTRO FROM CLIENTE
WHERE DATA_CADASTRO BETWEEN '20240101' AND '20241231'
  AND EMAIL IS NOT NULL

-- Q6
SELECT P.NUM_PEDIDO, CL.NOME AS CLIENTE, CI.NOME AS CIDADE, F.NOME AS VENDEDOR
FROM PEDIDO P
    INNER JOIN CLIENTE CL    ON P.COD_CLIENTE = CL.COD_CLIENTE
    INNER JOIN CIDADE CI     ON CL.COD_CIDADE = CI.COD_CIDADE
    INNER JOIN FUNCIONARIO F ON P.COD_FUNC    = F.COD_FUNC

-- Q7
SELECT NOME FROM FUNCIONARIO WHERE COD_DEPTO IS NULL      -- ANA PAULA

SELECT D.NOME
FROM DEPARTAMENTO D
    LEFT JOIN FUNCIONARIO F ON D.COD_DEPTO = F.COD_DEPTO
WHERE F.COD_FUNC IS NULL                                  -- MARKETING

-- Q8
SELECT F.NOME, COUNT(*) AS QTD_PEDIDOS
FROM FUNCIONARIO F
    INNER JOIN PEDIDO P ON F.COD_FUNC = P.COD_FUNC
GROUP BY F.NOME
HAVING COUNT(*) >= 3

-- Q9
SELECT C.NOME, SUM(I.QUANTIDADE * I.PRECO_UNIT) AS TOTAL_VENDIDO
FROM CATEGORIA C
    INNER JOIN LIVRO L       ON C.COD_CATEGORIA = L.COD_CATEGORIA
    INNER JOIN ITEM_PEDIDO I ON L.COD_LIVRO     = I.COD_LIVRO
GROUP BY C.NOME

-- Q10
SELECT TITULO, PRECO FROM LIVRO
WHERE PRECO > (SELECT PRECO FROM LIVRO WHERE TITULO = 'O PLANETA AZUL')
GO

-- Q11  (CREATE VIEW tem que ser o unico comando do lote: por isso o GO acima)
CREATE VIEW VW_VENDAS_VENDEDOR
AS
    SELECT F.NOME, SUM(I.QUANTIDADE * I.PRECO_UNIT) AS TOTAL
    FROM FUNCIONARIO F
        INNER JOIN PEDIDO P      ON F.COD_FUNC   = P.COD_FUNC
        INNER JOIN ITEM_PEDIDO I ON P.NUM_PEDIDO = I.NUM_PEDIDO
    GROUP BY F.NOME
GO
SELECT * FROM VW_VENDAS_VENDEDOR WHERE TOTAL > 300
GO

-- Q12
CREATE PROCEDURE USP_PEDIDOS_DO_MES
    @MES INT,
    @ANO INT
AS
    SELECT NUM_PEDIDO, DATA_PEDIDO
    FROM PEDIDO
    WHERE MONTH(DATA_PEDIDO) = @MES AND YEAR(DATA_PEDIDO) = @ANO
GO
EXEC USP_PEDIDOS_DO_MES 1, 2025
GO

-- Q13
-- a) os dois apagam todas as linhas; o TRUNCATE e mais rapido, nao
--    aceita WHERE e zera o contador do IDENTITY.
-- b) WHERE filtra linhas antes de agrupar; HAVING filtra os grupos
--    depois do GROUP BY (e aceita COUNT, SUM...).
-- c) vira produto cartesiano: cada linha de uma tabela junta com cada
--    linha da outra.
-- d) nao (a view padrao); ela so guarda o SELECT. Os dados ficam nas
--    tabelas. A excecao e a view indexada.

-- Q14
DROP VIEW VW_VENDAS_VENDEDOR
DROP PROCEDURE USP_PEDIDOS_DO_MES
DROP TABLE AVALIACAO_LIVRO
GO

==== FIM RESPOSTAS */
