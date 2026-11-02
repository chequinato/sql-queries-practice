/* =====================================================================
   P2 - BANCO DE DADOS | 06 - SUBSELECT, TOP E RANKING
   ---------------------------------------------------------------------
   Aula do professor: 14 (Limitacao e SubSelect, DQL Avancado).

   Antes: rode o p2-00-base-livraria.sql
   Rode um bloco por vez: selecione o bloco e aperte F5.
   ===================================================================== */


/* ---------------------------------------------------------------------
   1) SUBSELECT = um SELECT dentro de outro
   ---------------------------------------------------------------------
   Serve quando eu preciso de uma resposta para fazer a pergunta.
   Ex: "livros mais caros que a MEDIA". Primeiro descubro a media,
   depois comparo:

     SELECT TITULO FROM LIVRO
     WHERE PRECO > (SELECT AVG(PRECO) FROM LIVRO)
                    \_____________________________/
                      roda primeiro e vira um numero

   Qual operador usar:
     o subselect devolve UM valor     -> =  >  <  <> ...
     o subselect devolve uma LISTA    -> IN / NOT IN
     so quero saber se EXISTE linha   -> EXISTS / NOT EXISTS

   ---------------------------------------------------------------------
   2) SUBSELECT CORRELACIONADO
   ---------------------------------------------------------------------
   E quando o SELECT de dentro usa uma coluna do SELECT de fora.
   Ele roda de novo para cada linha de fora.
   Ex: "livros mais caros que a media DA CATEGORIA DELES"

   ---------------------------------------------------------------------
   3) ANY e ALL
   ---------------------------------------------------------------------
     > ALL (lista)  maior que TODOS da lista
     > ANY (lista)  maior que PELO MENOS UM da lista

   ---------------------------------------------------------------------
   4) TOP e RANKING
   ---------------------------------------------------------------------
     SELECT TOP 3 ... ORDER BY ...     so as 3 primeiras linhas

     Numerar as linhas numa ordem (sempre com OVER (ORDER BY ...)):
       ROW_NUMBER()  1, 2, 3, 4   (nunca repete)
       RANK()        1, 1, 3, 4   (empate repete e PULA o proximo)
       DENSE_RANK()  1, 1, 2, 3   (empate repete e NAO pula)
     PARTITION BY COL -> recomeca a contagem em cada grupo

   CUIDADO NA PROVA:
     - usar = quando o subselect devolve VARIAS linhas da erro.
       Nesse caso use IN.
     - NOT IN com um NULL na lista nao devolve nada. Prefira NOT EXISTS.
   --------------------------------------------------------------------- */

USE P2_LIVRARIA
GO

-- =====================================================================
-- EXEMPLOS
-- =====================================================================

-- Exemplo 1: subselect que devolve UM valor
SELECT AVG(PRECO) FROM LIVRO                      -- rode sozinho: 66.57
SELECT TITULO, PRECO FROM LIVRO
WHERE PRECO > (SELECT AVG(PRECO) FROM LIVRO)      -- livros acima da media

-- Exemplo 2: quem ganha o maior salario
SELECT NOME, SALARIO FROM FUNCIONARIO
WHERE SALARIO = (SELECT MAX(SALARIO) FROM FUNCIONARIO)

-- Exemplo 3: subselect que devolve uma LISTA (IN)
-- clientes que moram em cidades do estado de SP
SELECT NOME FROM CLIENTE
WHERE COD_CIDADE IN (SELECT COD_CIDADE FROM CIDADE WHERE UF = 'SP')

-- Exemplo 4: NOT IN -> livros que nunca foram vendidos
SELECT TITULO FROM LIVRO
WHERE COD_LIVRO NOT IN (SELECT COD_LIVRO FROM ITEM_PEDIDO)

-- Exemplo 5: NOT EXISTS -> clientes que nunca fizeram pedido
SELECT CL.NOME FROM CLIENTE CL
WHERE NOT EXISTS (SELECT * FROM PEDIDO P WHERE P.COD_CLIENTE = CL.COD_CLIENTE)

-- Exemplo 6: correlacionado -> livros mais caros que a media da categoria deles
-- (o L.COD_CATEGORIA de fora entra no SELECT de dentro)
SELECT L.TITULO, L.PRECO
FROM LIVRO L
WHERE L.PRECO > (SELECT AVG(L2.PRECO) FROM LIVRO L2
                 WHERE L2.COD_CATEGORIA = L.COD_CATEGORIA)

-- Exemplo 7: ALL -> livros mais caros que TODOS os romances (categoria 1)
SELECT TITULO, PRECO FROM LIVRO
WHERE PRECO > ALL (SELECT PRECO FROM LIVRO WHERE COD_CATEGORIA = 1)

-- Exemplo 8: TOP -> os 3 clientes que mais gastaram
SELECT TOP 3 CL.NOME, SUM(I.QUANTIDADE * I.PRECO_UNIT) AS TOTAL
FROM CLIENTE CL
    INNER JOIN PEDIDO P      ON CL.COD_CLIENTE = P.COD_CLIENTE
    INNER JOIN ITEM_PEDIDO I ON P.NUM_PEDIDO   = I.NUM_PEDIDO
GROUP BY CL.NOME
ORDER BY TOTAL DESC

-- Exemplo 9: ROW_NUMBER x RANK x DENSE_RANK pelo estoque
-- os livros 3 e 15 empatam com estoque 0, repare na diferenca
SELECT TITULO, ESTOQUE,
       ROW_NUMBER() OVER (ORDER BY ESTOQUE) AS ROW_NUMBER_,
       RANK()       OVER (ORDER BY ESTOQUE) AS RANK_,
       DENSE_RANK() OVER (ORDER BY ESTOQUE) AS DENSE_RANK_
FROM LIVRO

-- Exemplo 10: PARTITION BY -> ranking de preco DENTRO de cada categoria
SELECT COD_CATEGORIA, TITULO, PRECO,
       RANK() OVER (PARTITION BY COD_CATEGORIA ORDER BY PRECO DESC) AS POSICAO
FROM LIVRO


-- =====================================================================
-- EXERCICIOS
-- =====================================================================

-- E1) Mostre os funcionarios que ganham menos que a media salarial.


-- E2) Qual o titulo do livro mais barato? (use subselect, sem TOP)


-- E3) Mostre os clientes que moram na mesma cidade da funcionaria
--     LARISSA GOMES.


-- E4) Mostre as cidades que nao tem nenhum cliente.


-- E5) Mostre os funcionarios que nunca atenderam pedido nenhum.


-- E6) Mostre os 2 livros mais vendidos (em quantidade).


-- E7) Faca um ranking dos funcionarios pelo salario, do maior para o
--     menor, usando RANK().



/* =====================================================================
   RESPOSTAS - so desca ate aqui depois de tentar!
   =====================================================================















   ===================================================================== */
/* ==== RESPOSTAS

-- E1
SELECT NOME, SALARIO FROM FUNCIONARIO
WHERE SALARIO < (SELECT AVG(SALARIO) FROM FUNCIONARIO)

-- E2
SELECT TITULO, PRECO FROM LIVRO
WHERE PRECO = (SELECT MIN(PRECO) FROM LIVRO)

-- E3
SELECT NOME FROM CLIENTE
WHERE COD_CIDADE = (SELECT COD_CIDADE FROM FUNCIONARIO WHERE NOME = 'LARISSA GOMES')

-- E4  (resposta: MANAUS)
SELECT NOME FROM CIDADE
WHERE COD_CIDADE NOT IN (SELECT COD_CIDADE FROM CLIENTE)

-- E5
SELECT NOME FROM FUNCIONARIO
WHERE COD_FUNC NOT IN (SELECT COD_FUNC FROM PEDIDO)

-- E6
SELECT TOP 2 L.TITULO, SUM(I.QUANTIDADE) AS QTD
FROM LIVRO L
    INNER JOIN ITEM_PEDIDO I ON L.COD_LIVRO = I.COD_LIVRO
GROUP BY L.TITULO
ORDER BY QTD DESC

-- E7
SELECT NOME, SALARIO,
       RANK() OVER (ORDER BY SALARIO DESC) AS POSICAO
FROM FUNCIONARIO

==== FIM RESPOSTAS */
