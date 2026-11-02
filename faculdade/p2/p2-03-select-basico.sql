/* =====================================================================
   P2 - BANCO DE DADOS | 03 - SELECT: CONSULTAR E FILTRAR
   ---------------------------------------------------------------------
   Aula do professor: 10 (Exercicios do Select).

   Antes: rode o p2-00-base-livraria.sql
   Rode um bloco por vez: selecione o bloco e aperte F5.
   ===================================================================== */


/* ---------------------------------------------------------------------
   1) O BASICO
   ---------------------------------------------------------------------
     SELECT colunas      -> o que eu quero ver
     FROM   tabela       -> de onde
     WHERE  condicao     -> quais linhas (filtro)
     ORDER BY coluna     -> em que ordem

     SELECT *            -> todas as colunas
     SELECT DISTINCT     -> sem repetir
     SELECT TOP 3        -> so as 3 primeiras linhas

   ---------------------------------------------------------------------
   2) FILTROS DO WHERE
   ---------------------------------------------------------------------
     =  <>  >  <  >=  <=       igual, diferente, maior, menor...
     AND                       as duas coisas tem que ser verdade
     OR                        basta uma ser verdade
     NOT                       inverte
     BETWEEN 10 AND 20         entre 10 e 20 (10 e 20 entram)
     IN (1, 2, 3)              igual a algum da lista
     LIKE                      procura texto:
         'MAR%'   comeca com MAR
         '%MAR'   termina com MAR
         '%MAR%'  tem MAR em qualquer lugar
         '_A%'    segunda letra e A  ( _ = uma letra qualquer )
     IS NULL                   campo vazio
     IS NOT NULL               campo preenchido

   ---------------------------------------------------------------------
   3) ORDENAR E CALCULAR
   ---------------------------------------------------------------------
     ORDER BY PRECO            do menor para o maior (ASC)
     ORDER BY PRECO DESC       do maior para o menor
     PRECO * 0.90 AS COM_DESCONTO     conta com apelido (AS)

   CUIDADO NA PROVA:
     - campo vazio NAO se testa com = NULL. Use IS NULL.
     - texto vai entre aspas simples: 'SP'
     - AND e resolvido antes do OR. Na duvida, use parenteses.
   --------------------------------------------------------------------- */

USE P2_LIVRARIA
GO

-- =====================================================================
-- EXEMPLOS
-- =====================================================================

-- algumas colunas / todas as colunas
SELECT TITULO, AUTOR, PRECO FROM LIVRO
SELECT * FROM CIDADE

-- WHERE com comparacao
SELECT TITULO, PRECO FROM LIVRO WHERE PRECO > 80
SELECT NOME, UF FROM CIDADE WHERE UF <> 'SP'

-- AND e OR
SELECT TITULO, PRECO, ESTOQUE FROM LIVRO WHERE PRECO < 50 AND ESTOQUE >= 30
SELECT TITULO FROM LIVRO WHERE COD_CATEGORIA = 4 OR COD_CATEGORIA = 5

-- BETWEEN (com numero e com data)
SELECT TITULO, PRECO FROM LIVRO WHERE PRECO BETWEEN 40 AND 60
SELECT NUM_PEDIDO, DATA_PEDIDO FROM PEDIDO
WHERE DATA_PEDIDO BETWEEN '20250101' AND '20250331'     -- 1o trimestre de 2025

-- LIKE
SELECT NOME FROM CLIENTE WHERE NOME LIKE 'MAR%'      -- comeca com MAR
SELECT TITULO FROM LIVRO WHERE TITULO LIKE '%LUA'    -- termina com LUA
SELECT TITULO FROM LIVRO WHERE TITULO LIKE '%DE%'    -- tem DE no meio

-- IN
SELECT NOME, UF FROM CIDADE WHERE UF IN ('PR', 'MG', 'RJ')

-- IS NULL
SELECT NOME FROM CLIENTE WHERE EMAIL IS NULL               -- sem email
SELECT NUM_PEDIDO FROM PEDIDO WHERE DATA_ENTREGA IS NULL   -- nao entregues

-- ORDER BY
SELECT TITULO, PRECO FROM LIVRO ORDER BY PRECO DESC

-- conta com apelido
SELECT TITULO, PRECO, PRECO * 0.90 AS PRECO_COM_DESCONTO FROM LIVRO

-- DISTINCT: autores sem repetir
SELECT DISTINCT AUTOR FROM LIVRO

-- TOP: os 3 livros mais caros
SELECT TOP 3 TITULO, PRECO FROM LIVRO ORDER BY PRECO DESC


-- =====================================================================
-- EXERCICIOS
-- =====================================================================

-- E1) Mostre o nome, o cargo e o salario de todos os funcionarios.


-- E2) Mostre os livros que estao sem estoque (estoque 0).


-- E3) Mostre titulo e ano dos livros de 2020 para frente, do mais novo
--     para o mais velho.


-- E4) Mostre os funcionarios que ganham entre 2500 e 5000.


-- E5) Mostre os clientes que tem 'IA' em qualquer parte do nome.


-- E6) Mostre os livros das categorias 2, 3 e 5 que custam menos de 70.


-- E7) Mostre os funcionarios que NAO tem chefe.


-- E8) Mostre titulo, preco e o preco com 15% de desconto
--     (apelido PRECO_PROMO).


-- E9) Quais UFs tem cidade cadastrada? (sem repetir)


-- E10) Mostre os 2 funcionarios mais antigos (pela data de admissao).



/* =====================================================================
   RESPOSTAS - so desca ate aqui depois de tentar!
   =====================================================================















   ===================================================================== */
/* ==== RESPOSTAS

-- E1
SELECT NOME, CARGO, SALARIO FROM FUNCIONARIO

-- E2
SELECT TITULO, ESTOQUE FROM LIVRO WHERE ESTOQUE = 0

-- E3
SELECT TITULO, ANO_PUBLICACAO FROM LIVRO
WHERE ANO_PUBLICACAO >= 2020
ORDER BY ANO_PUBLICACAO DESC

-- E4
SELECT NOME, SALARIO FROM FUNCIONARIO WHERE SALARIO BETWEEN 2500 AND 5000

-- E5
SELECT NOME FROM CLIENTE WHERE NOME LIKE '%IA%'

-- E6
SELECT TITULO, PRECO FROM LIVRO
WHERE COD_CATEGORIA IN (2, 3, 5) AND PRECO < 70

-- E7
SELECT NOME, CARGO FROM FUNCIONARIO WHERE COD_CHEFE IS NULL

-- E8
SELECT TITULO, PRECO, PRECO * 0.85 AS PRECO_PROMO FROM LIVRO

-- E9
SELECT DISTINCT UF FROM CIDADE

-- E10
SELECT TOP 2 NOME, DATA_ADMISSAO FROM FUNCIONARIO ORDER BY DATA_ADMISSAO

==== FIM RESPOSTAS */
