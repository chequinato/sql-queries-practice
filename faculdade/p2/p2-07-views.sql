/* =====================================================================
   P2 - BANCO DE DADOS | 07 - VIEWS
   ---------------------------------------------------------------------
   Aula do professor: 15 C (Views).

   Antes: rode o p2-00-base-livraria.sql
   Rode um bloco por vez: selecione o bloco e aperte F5.
   ===================================================================== */


/* ---------------------------------------------------------------------
   1) O QUE E UMA VIEW
   ---------------------------------------------------------------------
   E um SELECT que fica SALVO no banco com um nome.
   Depois voce usa o nome como se fosse uma tabela.
   Ela NAO guarda os dados: toda vez que voce consulta, o SELECT dela
   roda de novo nas tabelas de verdade (por isso e "tabela virtual").

   ---------------------------------------------------------------------
   2) COMO ESCREVE
   ---------------------------------------------------------------------
     CREATE VIEW VW_NOME AS
         SELECT ...
     GO

     SELECT * FROM VW_NOME            -- usa igual tabela
     ALTER VIEW VW_NOME AS SELECT ... -- muda o SELECT da view
     DROP VIEW VW_NOME                -- apaga a view (as tabelas ficam)

   ---------------------------------------------------------------------
   3) PARA QUE SERVE
   ---------------------------------------------------------------------
     - esconder um SELECT grande (um JOIN de 4 tabelas vira SELECT * FROM VW)
     - seguranca: mostrar so algumas colunas (ex: sem o salario)
     - mostrar dados ja somados/contados

   ---------------------------------------------------------------------
   4) TIPOS (teoria)
   ---------------------------------------------------------------------
     PADRAO       a comum: roda o SELECT na hora
     INDEXADA     tem um indice; o resultado fica gravado no disco (mais rapida)
     PARTICIONADA junta partes de dados que estao em tabelas (ou servidores)
                  diferentes, como se fosse uma tabela so

   CUIDADO NA PROVA:
     - NAO pode ter ORDER BY dentro da view (ordene no SELECT que usa ela)
     - coluna calculada precisa de apelido: SALARIO * 12 AS ANUAL
     - CREATE VIEW tem que ficar sozinho no lote: GO antes e depois
   --------------------------------------------------------------------- */

USE P2_LIVRARIA
GO

-- apaga as views do exemplo se ja existirem (para poder rodar de novo)
IF OBJECT_ID('VW_CATALOGO') IS NOT NULL DROP VIEW VW_CATALOGO
IF OBJECT_ID('VW_FUNCIONARIO_SEM_SALARIO') IS NOT NULL DROP VIEW VW_FUNCIONARIO_SEM_SALARIO
IF OBJECT_ID('VW_TOTAL_PEDIDO') IS NOT NULL DROP VIEW VW_TOTAL_PEDIDO
GO

-- =====================================================================
-- EXEMPLOS
-- =====================================================================

-- Exemplo 1: view que esconde um JOIN
CREATE VIEW VW_CATALOGO
AS
    SELECT L.COD_LIVRO, L.TITULO, L.PRECO, C.NOME AS CATEGORIA
    FROM LIVRO L
        INNER JOIN CATEGORIA C ON L.COD_CATEGORIA = C.COD_CATEGORIA
GO
-- usando a view: simples, sem JOIN
SELECT * FROM VW_CATALOGO
SELECT TITULO, PRECO FROM VW_CATALOGO WHERE CATEGORIA = 'ROMANCE' ORDER BY PRECO
GO

-- Exemplo 2: view de seguranca (sem a coluna SALARIO)
CREATE VIEW VW_FUNCIONARIO_SEM_SALARIO
AS
    SELECT COD_FUNC, NOME, CARGO
    FROM FUNCIONARIO
GO
SELECT * FROM VW_FUNCIONARIO_SEM_SALARIO
GO

-- Exemplo 3: view com conta (o apelido TOTAL e obrigatorio)
CREATE VIEW VW_TOTAL_PEDIDO
AS
    SELECT NUM_PEDIDO, SUM(QUANTIDADE * PRECO_UNIT) AS TOTAL
    FROM ITEM_PEDIDO
    GROUP BY NUM_PEDIDO
GO
SELECT * FROM VW_TOTAL_PEDIDO WHERE TOTAL > 100
GO

-- Exemplo 4: a view nao guarda dado. Mudou a tabela, a view ja mostra
BEGIN TRAN
    UPDATE LIVRO SET PRECO = 10 WHERE COD_LIVRO = 1
    SELECT TITULO, PRECO FROM VW_CATALOGO WHERE COD_LIVRO = 1     -- mostra 10
ROLLBACK
GO

-- Exemplo 5: ALTER VIEW (agora mostra tambem o AUTOR)
ALTER VIEW VW_CATALOGO
AS
    SELECT L.COD_LIVRO, L.TITULO, L.AUTOR, L.PRECO, C.NOME AS CATEGORIA
    FROM LIVRO L
        INNER JOIN CATEGORIA C ON L.COD_CATEGORIA = C.COD_CATEGORIA
GO
SELECT * FROM VW_CATALOGO
GO

-- Exemplo 6: DROP VIEW (a tabela FUNCIONARIO continua existindo)
DROP VIEW VW_FUNCIONARIO_SEM_SALARIO
GO


-- =====================================================================
-- EXERCICIOS
-- =====================================================================

-- E1) Crie a view VW_SEM_ESTOQUE com codigo e titulo dos livros com
--     estoque zero. Depois consulte a view.


-- E2) Crie a view VW_PENDENTES com o numero do pedido, a data e o nome
--     do cliente dos pedidos que ainda nao foram entregues.


-- E3) Altere a VW_SEM_ESTOQUE para mostrar tambem o PRECO.


-- E4) A view abaixo tem DOIS erros. Quais? Corrija.
--     CREATE VIEW VW_ERRADA AS
--         SELECT NOME, SALARIO * 12 FROM FUNCIONARIO ORDER BY NOME


-- E5) Apague as views que voce criou.



/* =====================================================================
   RESPOSTAS - so desca ate aqui depois de tentar!
   =====================================================================















   ===================================================================== */
/* ==== RESPOSTAS

-- E1
CREATE VIEW VW_SEM_ESTOQUE
AS
    SELECT COD_LIVRO, TITULO
    FROM LIVRO
    WHERE ESTOQUE = 0
GO
SELECT * FROM VW_SEM_ESTOQUE
GO

-- E2
CREATE VIEW VW_PENDENTES
AS
    SELECT P.NUM_PEDIDO, P.DATA_PEDIDO, CL.NOME AS CLIENTE
    FROM PEDIDO P
        INNER JOIN CLIENTE CL ON P.COD_CLIENTE = CL.COD_CLIENTE
    WHERE P.DATA_ENTREGA IS NULL
GO
SELECT * FROM VW_PENDENTES
GO

-- E3
ALTER VIEW VW_SEM_ESTOQUE
AS
    SELECT COD_LIVRO, TITULO, PRECO
    FROM LIVRO
    WHERE ESTOQUE = 0
GO

-- E4
-- erro 1: SALARIO * 12 nao tem apelido
-- erro 2: ORDER BY dentro da view nao pode
CREATE VIEW VW_ERRADA
AS
    SELECT NOME, SALARIO * 12 AS SALARIO_ANUAL FROM FUNCIONARIO
GO
SELECT * FROM VW_ERRADA ORDER BY NOME      -- o ORDER BY vai aqui fora
GO

-- E5
DROP VIEW VW_SEM_ESTOQUE
DROP VIEW VW_PENDENTES
DROP VIEW VW_ERRADA
GO

==== FIM RESPOSTAS */
