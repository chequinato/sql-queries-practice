/* =====================================================================
   P2 - BANCO DE DADOS | 08 - STORED PROCEDURES, FUNCAO e CASE (T-SQL)
   ---------------------------------------------------------------------
   Aulas do professor: 15 B (Programacao em T-SQL - CASE),
   15 D (Procedures) e 14 (funcao de total acumulado).

   Antes: rode o p2-00-base-livraria.sql
   Rode um bloco por vez: selecione o bloco e aperte F5.
   ===================================================================== */


/* ---------------------------------------------------------------------
   1) O QUE E UMA STORED PROCEDURE
   ---------------------------------------------------------------------
   E um bloco de comandos SQL salvo no banco com um nome, que voce
   executa quando quiser. Parece uma funcao de programacao:
   pode receber PARAMETROS (valores de entrada).

   Vantagens (caem em teoria):
     - fica salva no servidor: escreve uma vez, usa varias vezes
     - menos trafego na rede: manda so "EXEC nome" em vez do codigo todo
     - seguranca: o usuario pode ter permissao so para executar a
       procedure, sem mexer direto nas tabelas
     - com parametros ajuda a evitar SQL Injection

   ---------------------------------------------------------------------
   2) COMO ESCREVE
   ---------------------------------------------------------------------
     CREATE PROCEDURE NOME
         @PARAMETRO TIPO
     AS
         SELECT ... WHERE COLUNA = @PARAMETRO
     GO

     EXEC NOME 'valor'                 -- executa (EXEC = EXECUTE)
     EXEC NOME @PARAMETRO = 'valor'    -- executa dizendo o nome do parametro
     ALTER PROCEDURE NOME ...          -- muda (mantem as permissoes)
     DROP PROCEDURE NOME               -- apaga

     Parametro com valor padrao: @NOME VARCHAR(40) = '%'
     (se nao passar nada, usa o padrao)

   ---------------------------------------------------------------------
   3) PROCEDURE x VIEW x FUNCAO
   ---------------------------------------------------------------------
     VIEW       so um SELECT, sem parametro, usa no FROM
     PROCEDURE  varios comandos, com parametros, roda com EXEC
                (nao da para usar dentro de um SELECT)
     FUNCAO     devolve UM valor e pode ser usada dentro do SELECT

   CUIDADO NA PROVA:
     - nao comece o nome com sp_ : esse prefixo e das procedures do
       proprio SQL Server, e a do sistema pode ser executada no lugar da sua
     - parametro sempre comeca com @
     - para ver o codigo de uma procedure: EXEC sp_helptext 'NOME'
   --------------------------------------------------------------------- */

USE P2_LIVRARIA
GO

-- apaga o que este arquivo cria, para poder rodar de novo
IF OBJECT_ID('USP_LISTA_LIVROS', 'P')      IS NOT NULL DROP PROCEDURE USP_LISTA_LIVROS
IF OBJECT_ID('USP_LIVROS_DA_CATEGORIA', 'P') IS NOT NULL DROP PROCEDURE USP_LIVROS_DA_CATEGORIA
IF OBJECT_ID('USP_BUSCA_CLIENTE', 'P')     IS NOT NULL DROP PROCEDURE USP_BUSCA_CLIENTE
IF OBJECT_ID('USP_REAJUSTA_PRECO', 'P')    IS NOT NULL DROP PROCEDURE USP_REAJUSTA_PRECO
IF OBJECT_ID('FN_TOTAL_PEDIDO', 'FN')      IS NOT NULL DROP FUNCTION FN_TOTAL_PEDIDO
GO

-- =====================================================================
-- EXEMPLOS
-- =====================================================================

-- Exemplo 1: procedure SEM parametro
CREATE PROCEDURE USP_LISTA_LIVROS
AS
    SELECT L.TITULO, L.PRECO, C.NOME AS CATEGORIA
    FROM LIVRO L
        INNER JOIN CATEGORIA C ON L.COD_CATEGORIA = C.COD_CATEGORIA
GO
EXEC USP_LISTA_LIVROS
GO

-- Exemplo 2: procedure COM parametro
CREATE PROCEDURE USP_LIVROS_DA_CATEGORIA
    @CATEGORIA VARCHAR(30)
AS
    SELECT L.TITULO, L.PRECO
    FROM LIVRO L
        INNER JOIN CATEGORIA C ON L.COD_CATEGORIA = C.COD_CATEGORIA
    WHERE C.NOME = @CATEGORIA
GO
-- duas formas de executar:
EXEC USP_LIVROS_DA_CATEGORIA 'ROMANCE'
EXEC USP_LIVROS_DA_CATEGORIA @CATEGORIA = 'TECNOLOGIA'
GO

-- Exemplo 3: parametro com valor PADRAO + LIKE (busca por parte do nome)
CREATE PROCEDURE USP_BUSCA_CLIENTE
    @NOME VARCHAR(40) = '%'           -- se nao passar nada, traz todos
AS
    SELECT COD_CLIENTE, NOME, EMAIL
    FROM CLIENTE
    WHERE NOME LIKE @NOME
GO
EXEC USP_BUSCA_CLIENTE               -- todos
EXEC USP_BUSCA_CLIENTE 'MAR%'        -- nomes que comecam com MAR
GO

-- Exemplo 4: procedure que ALTERA dados (dois parametros)
CREATE PROCEDURE USP_REAJUSTA_PRECO
    @COD_CATEGORIA INT,
    @PERCENTUAL    NUMERIC(5,2)
AS
    UPDATE LIVRO
    SET PRECO = PRECO * (1 + @PERCENTUAL / 100)
    WHERE COD_CATEGORIA = @COD_CATEGORIA
GO
BEGIN TRAN
    EXEC USP_REAJUSTA_PRECO 4, 10            -- +10% nos infantis
    SELECT TITULO, PRECO FROM LIVRO WHERE COD_CATEGORIA = 4
ROLLBACK
GO

-- Exemplo 5: ALTER PROCEDURE (agora tambem ordena pelo preco)
ALTER PROCEDURE USP_LISTA_LIVROS
AS
    SELECT L.TITULO, L.PRECO, C.NOME AS CATEGORIA
    FROM LIVRO L
        INNER JOIN CATEGORIA C ON L.COD_CATEGORIA = C.COD_CATEGORIA
    ORDER BY L.PRECO
GO
EXEC USP_LISTA_LIVROS
GO

-- Exemplo 6: ver o codigo e apagar
EXEC sp_helptext 'USP_LISTA_LIVROS'
DROP PROCEDURE USP_LISTA_LIVROS
GO

-- Exemplo 7: FUNCAO -> devolve UM valor e da para usar no SELECT
CREATE FUNCTION FN_TOTAL_PEDIDO (@NUM_PEDIDO INT)
    RETURNS NUMERIC(10,2)
AS
BEGIN
    RETURN (SELECT SUM(QUANTIDADE * PRECO_UNIT)
            FROM ITEM_PEDIDO
            WHERE NUM_PEDIDO = @NUM_PEDIDO)
END
GO
-- funcao precisa do "dbo." na frente quando for usada
SELECT NUM_PEDIDO, DATA_PEDIDO, dbo.FN_TOTAL_PEDIDO(NUM_PEDIDO) AS TOTAL
FROM PEDIDO
GO

-- Exemplo 8: CASE (Aula 15 B) -> trocar um valor por um texto
SELECT NUM_PEDIDO,
       CASE
           WHEN DATA_ENTREGA IS NULL THEN 'PENDENTE'
           ELSE 'ENTREGUE'
       END AS SITUACAO
FROM PEDIDO

-- CASE comparando com valores fixos (igual ao exemplo do professor)
SELECT NOME,
       CASE COD_DEPTO
           WHEN 'VEN' THEN 'Vendas'
           WHEN 'EST' THEN 'Estoque'
           ELSE 'Outros'
       END AS SETOR
FROM FUNCIONARIO
GO


-- =====================================================================
-- EXERCICIOS
-- =====================================================================

-- E1) Crie a procedure USP_CLIENTES_DA_CIDADE que recebe o nome de uma
--     cidade e mostra o nome dos clientes de la. Execute para 'JUNDIAI'.


-- E2) Crie a procedure USP_PEDIDOS_DO_CLIENTE que recebe o codigo do
--     cliente e mostra numero e data dos pedidos dele. Execute para o
--     cliente 1 das duas formas (com e sem o nome do parametro).


-- E3) Crie a procedure USP_LIVROS_ATE que recebe um preco maximo e
--     mostra os livros ate esse preco. Se nao passar o preco, use 50.


-- E4) Mostre o nome dos funcionarios e uma coluna NIVEL:
--     salario ate 3000 -> 'JUNIOR', ate 6000 -> 'PLENO', acima -> 'SENIOR'.


-- E5) (teoria) Qual a diferenca entre VIEW e PROCEDURE? Por que nao se
--     deve criar procedure com nome comecando com sp_ ?


-- E6) Apague as procedures que voce criou.



/* =====================================================================
   RESPOSTAS - so desca ate aqui depois de tentar!
   =====================================================================















   ===================================================================== */
/* ==== RESPOSTAS

-- E1
CREATE PROCEDURE USP_CLIENTES_DA_CIDADE
    @CIDADE VARCHAR(30)
AS
    SELECT CL.NOME
    FROM CLIENTE CL
        INNER JOIN CIDADE CI ON CL.COD_CIDADE = CI.COD_CIDADE
    WHERE CI.NOME = @CIDADE
GO
EXEC USP_CLIENTES_DA_CIDADE 'JUNDIAI'
GO

-- E2
CREATE PROCEDURE USP_PEDIDOS_DO_CLIENTE
    @COD_CLIENTE INT
AS
    SELECT NUM_PEDIDO, DATA_PEDIDO
    FROM PEDIDO
    WHERE COD_CLIENTE = @COD_CLIENTE
GO
EXEC USP_PEDIDOS_DO_CLIENTE 1
EXEC USP_PEDIDOS_DO_CLIENTE @COD_CLIENTE = 1
GO

-- E3
CREATE PROCEDURE USP_LIVROS_ATE
    @PRECO_MAX NUMERIC(10,2) = 50
AS
    SELECT TITULO, PRECO
    FROM LIVRO
    WHERE PRECO <= @PRECO_MAX
GO
EXEC USP_LIVROS_ATE          -- usa 50
EXEC USP_LIVROS_ATE 80
GO

-- E4
SELECT NOME, SALARIO,
       CASE
           WHEN SALARIO <= 3000 THEN 'JUNIOR'
           WHEN SALARIO <= 6000 THEN 'PLENO'
           ELSE 'SENIOR'
       END AS NIVEL
FROM FUNCIONARIO

-- E5
-- VIEW e so um SELECT salvo, sem parametro, e voce usa no FROM como se
-- fosse tabela. PROCEDURE pode ter varios comandos (INSERT, UPDATE...),
-- recebe parametros e roda com EXEC.
-- sp_ e o prefixo das procedures do sistema. Se o nome bater com uma do
-- sistema, o SQL Server executa a dele, nao a sua.

-- E6
DROP PROCEDURE USP_CLIENTES_DA_CIDADE
DROP PROCEDURE USP_PEDIDOS_DO_CLIENTE
DROP PROCEDURE USP_LIVROS_ATE
GO

==== FIM RESPOSTAS */
