/* =====================================================================
   P2 - BANCO DE DADOS | 02 - DML: INSERT, UPDATE, DELETE e TRUNCATE
   ---------------------------------------------------------------------
   Aulas do professor: 07 B (Comandos DML), 08 e 09 (exercicios).

   Antes: rode o p2-00-base-livraria.sql
   Rode um bloco por vez: selecione o bloco e aperte F5.
   ===================================================================== */


/* ---------------------------------------------------------------------
   1) INSERT = colocar uma linha nova
   ---------------------------------------------------------------------
     INSERT INTO TABELA (COLUNA1, COLUNA2) VALUES (valor1, valor2)

     - os valores vao na MESMA ORDEM das colunas que voce escreveu
     - coluna que voce nao escreveu fica vazia (NULL)
     - varias linhas de uma vez: VALUES (...), (...), (...)
     - texto e data vao entre aspas: 'JOAO', '20250108'
     - numero vai sem aspas, e decimal com PONTO: 10.50
     - coluna IDENTITY (numero automatico) nao entra no INSERT

   ---------------------------------------------------------------------
   2) UPDATE = mudar dados de linhas que ja existem
   ---------------------------------------------------------------------
     UPDATE TABELA SET COLUNA = valor WHERE condicao

     - mudar duas colunas: SET COL1 = valor, COL2 = valor
     - aumento de 10%:  SET PRECO = PRECO * 1.10
     - desconto de 20%: SET PRECO = PRECO * 0.80

   ---------------------------------------------------------------------
   3) DELETE = apagar linhas
   ---------------------------------------------------------------------
     DELETE FROM TABELA WHERE condicao

   ---------------------------------------------------------------------
   4) TRUNCATE = esvaziar a tabela inteira
   ---------------------------------------------------------------------
     TRUNCATE TABLE TABELA
     - apaga TODAS as linhas, nao aceita WHERE, e mais rapido que DELETE

   ---------------------------------------------------------------------
   5) TRANSACAO = o "desfazer" do banco
   ---------------------------------------------------------------------
     BEGIN TRAN   comeca
     ROLLBACK     desfaz tudo desde o BEGIN TRAN
     COMMIT       confirma de vez

   CUIDADO NA PROVA:
     - UPDATE ou DELETE SEM WHERE mexe em TODAS as linhas
     - nao da para apagar um "pai" que ainda tem "filhos" ligados (FK).
       Ex: apagar um cliente que tem pedido -> ERRO
     - no INSERT, primeiro o pai, depois o filho
   --------------------------------------------------------------------- */

USE P2_LIVRARIA
GO

-- =====================================================================
-- EXEMPLOS
-- Tudo entre BEGIN TRAN e ROLLBACK e desfeito no final,
-- entao pode rodar quantas vezes quiser.
-- =====================================================================

-- Exemplo 1: INSERT
BEGIN TRAN
    -- uma linha, com as colunas escritas
    INSERT INTO CIDADE (COD_CIDADE, NOME, UF) VALUES (20, 'ITATIBA', 'SP')

    -- sem escrever a coluna EMAIL: ela fica NULL
    INSERT INTO CLIENTE (COD_CLIENTE, NOME, DATA_CADASTRO, COD_CIDADE)
    VALUES (20, 'OTAVIO MELO', '20251101', 20)

    -- varias linhas de uma vez
    INSERT INTO CATEGORIA (COD_CATEGORIA, NOME) VALUES
        (20, 'QUADRINHOS'),
        (21, 'AUTOAJUDA')

    SELECT * FROM CLIENTE WHERE COD_CLIENTE = 20
    SELECT * FROM CATEGORIA
ROLLBACK
GO

-- Exemplo 2: UPDATE
BEGIN TRAN
    -- muda o email de UM cliente (pela chave)
    UPDATE CLIENTE SET EMAIL = 'lucas@email.com' WHERE COD_CLIENTE = 2

    -- +10% no preco dos livros infantis (categoria 4)
    SELECT TITULO, PRECO FROM LIVRO WHERE COD_CATEGORIA = 4      -- antes
    UPDATE LIVRO SET PRECO = PRECO * 1.10 WHERE COD_CATEGORIA = 4
    SELECT TITULO, PRECO FROM LIVRO WHERE COD_CATEGORIA = 4      -- depois
ROLLBACK
GO

-- Exemplo 3: DELETE
BEGIN TRAN
    -- o cliente 10 nao tem pedido, entao pode apagar
    DELETE FROM CLIENTE WHERE COD_CLIENTE = 10

    -- ITEM_PEDIDO tem chave de 2 colunas: para apagar UM item, use as duas
    DELETE FROM ITEM_PEDIDO WHERE NUM_PEDIDO = 3 AND ITEM = 2

    SELECT * FROM ITEM_PEDIDO WHERE NUM_PEDIDO = 3
ROLLBACK
GO

-- Exemplo 4: o ERRO de FK (rode e leia a mensagem)
-- o cliente 1 tem pedidos, entao o SQL Server nao deixa apagar
DELETE FROM CLIENTE WHERE COD_CLIENTE = 1
GO

-- Exemplo 5: TRUNCATE
-- (cria uma tabela de teste, enche, esvazia e apaga)
CREATE TABLE TESTE_TRUNCATE (NUMERO INT)
INSERT INTO TESTE_TRUNCATE VALUES (1), (2), (3)
TRUNCATE TABLE TESTE_TRUNCATE
SELECT * FROM TESTE_TRUNCATE        -- vazia
DROP TABLE TESTE_TRUNCATE
GO


-- =====================================================================
-- EXERCICIOS
-- Dica: escreva BEGIN TRAN antes e ROLLBACK depois, para poder repetir.
-- =====================================================================

-- E1) Cadastre a cidade 9, SOROCABA, SP.


-- E2) Cadastre o cliente 11, 'HUGO TEIXEIRA', cadastrado em 01/11/2025,
--     da cidade 9, sem email.


-- E3) Cadastre de uma vez so as categorias 7 'AUTOAJUDA' e 8 'QUADRINHOS'.


-- E4) Aumente em 5% o preco dos livros da categoria 3 (TECNOLOGIA).


-- E5) Mude o estoque dos livros 3 e 15 para 10.


-- E6) Apague o item 2 do pedido 9.


-- E7) Tente apagar o livro 7. Da erro? Por que?



/* =====================================================================
   RESPOSTAS - so desca ate aqui depois de tentar!
   =====================================================================















   ===================================================================== */
/* ==== RESPOSTAS

BEGIN TRAN

-- E1
INSERT INTO CIDADE (COD_CIDADE, NOME, UF) VALUES (9, 'SOROCABA', 'SP')

-- E2  (EMAIL nao aparece na lista, entao fica NULL)
INSERT INTO CLIENTE (COD_CLIENTE, NOME, DATA_CADASTRO, COD_CIDADE)
VALUES (11, 'HUGO TEIXEIRA', '20251101', 9)

-- E3
INSERT INTO CATEGORIA (COD_CATEGORIA, NOME) VALUES
    (7, 'AUTOAJUDA'),
    (8, 'QUADRINHOS')

-- E4
UPDATE LIVRO SET PRECO = PRECO * 1.05 WHERE COD_CATEGORIA = 3

-- E5
UPDATE LIVRO SET ESTOQUE = 10 WHERE COD_LIVRO = 3 OR COD_LIVRO = 15

-- E6
DELETE FROM ITEM_PEDIDO WHERE NUM_PEDIDO = 9 AND ITEM = 2

ROLLBACK
GO

-- E7
DELETE FROM LIVRO WHERE COD_LIVRO = 7
GO
-- Da erro de FK: o livro 7 ja foi vendido, entao aparece em ITEM_PEDIDO.
-- Um item de pedido nao pode ficar apontando para um livro que sumiu.

==== FIM RESPOSTAS */
