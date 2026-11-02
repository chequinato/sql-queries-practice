/* =====================================================================
   P2 - BANCO DE DADOS | 04 - JUNCOES (JOIN): JUNTAR TABELAS
   ---------------------------------------------------------------------
   Aulas do professor: 11 (Juncoes Oracle e SQL Server, sintaxe velha
   e nova) e 10 (Exercicio Universidade).

   Antes: rode o p2-00-base-livraria.sql
   Rode um bloco por vez: selecione o bloco e aperte F5.
   ===================================================================== */


/* ---------------------------------------------------------------------
   1) PARA QUE SERVE
   ---------------------------------------------------------------------
   O LIVRO guarda so o COD_CATEGORIA (um numero). O NOME da categoria
   esta na tabela CATEGORIA. Para mostrar os dois juntos, eu ligo as
   tabelas pela coluna em comum: LIVRO.COD_CATEGORIA = CATEGORIA.COD_CATEGORIA

   ---------------------------------------------------------------------
   2) AS DUAS FORMAS DE ESCREVER (o professor cobra as duas)
   ---------------------------------------------------------------------
     ANTIGA (tabelas separadas por virgula, ligacao no WHERE):
       SELECT L.TITULO, C.NOME
       FROM LIVRO L, CATEGORIA C
       WHERE L.COD_CATEGORIA = C.COD_CATEGORIA

     NOVA (INNER JOIN ... ON):
       SELECT L.TITULO, C.NOME
       FROM LIVRO L
           INNER JOIN CATEGORIA C ON L.COD_CATEGORIA = C.COD_CATEGORIA

     L e C sao APELIDOS das tabelas (para escrever menos).

   ---------------------------------------------------------------------
   3) TIPOS DE JOIN
   ---------------------------------------------------------------------
     INNER JOIN  -> so as linhas que tem par nas duas tabelas
     LEFT JOIN   -> TODAS da tabela da esquerda (mesmo sem par)
     RIGHT JOIN  -> TODAS da tabela da direita (mesmo sem par)
     CROSS JOIN  -> todo mundo com todo mundo (produto cartesiano)
     Quando nao tem par, as colunas da outra tabela vem NULL.

     AUTOJUNCAO  -> a tabela junta com ela mesma
                    (ex: funcionario e o chefe dele, que tambem e funcionario)

   CUIDADO NA PROVA:
     - esqueceu a ligacao (o WHERE ou o ON)? Vira PRODUTO CARTESIANO:
       cada linha de uma tabela com cada linha da outra.
     - 3 tabelas precisam de 2 ligacoes; 4 tabelas, de 3 ligacoes.
     - coluna com o mesmo nome nas duas tabelas (ex: NOME em CLIENTE e
       em CIDADE): escreva o apelido antes: CL.NOME, CI.NOME
     - "quem NAO tem ...": LEFT JOIN + WHERE coluna_da_outra IS NULL
     - no Oracle o LEFT/RIGHT antigo usa (+). No SQL Server use LEFT JOIN.
   --------------------------------------------------------------------- */

USE P2_LIVRARIA
GO

-- =====================================================================
-- EXEMPLOS
-- =====================================================================

-- Exemplo 1: livro + nome da categoria (forma antiga)
SELECT L.TITULO, C.NOME AS CATEGORIA
FROM LIVRO L, CATEGORIA C
WHERE L.COD_CATEGORIA = C.COD_CATEGORIA

-- Exemplo 2: a mesma coisa (forma nova)
SELECT L.TITULO, C.NOME AS CATEGORIA
FROM LIVRO L
    INNER JOIN CATEGORIA C ON L.COD_CATEGORIA = C.COD_CATEGORIA

-- Exemplo 3: JOIN + filtro (so clientes de JUNDIAI)
SELECT CL.NOME AS CLIENTE, CI.NOME AS CIDADE
FROM CLIENTE CL
    INNER JOIN CIDADE CI ON CL.COD_CIDADE = CI.COD_CIDADE
WHERE CI.NOME = 'JUNDIAI'

-- Exemplo 4: 3 tabelas -> pedido, nome do cliente e nome do vendedor
SELECT P.NUM_PEDIDO, CL.NOME AS CLIENTE, F.NOME AS VENDEDOR
FROM PEDIDO P
    INNER JOIN CLIENTE CL    ON P.COD_CLIENTE = CL.COD_CLIENTE
    INNER JOIN FUNCIONARIO F ON P.COD_FUNC    = F.COD_FUNC

-- Exemplo 5: produto cartesiano (esqueci a ligacao): 15 livros x 6 = 90 linhas
SELECT L.TITULO, C.NOME FROM LIVRO L, CATEGORIA C

-- Exemplo 6: INNER x LEFT
-- INNER: a ANA PAULA (sem departamento) NAO aparece
SELECT F.NOME, D.NOME AS DEPTO
FROM FUNCIONARIO F INNER JOIN DEPARTAMENTO D ON F.COD_DEPTO = D.COD_DEPTO
-- LEFT: todos os funcionarios; a ANA PAULA aparece com DEPTO NULL
SELECT F.NOME, D.NOME AS DEPTO
FROM FUNCIONARIO F LEFT JOIN DEPARTAMENTO D ON F.COD_DEPTO = D.COD_DEPTO

-- Exemplo 7: "quem NAO tem": departamento sem funcionario
SELECT D.NOME
FROM DEPARTAMENTO D
    LEFT JOIN FUNCIONARIO F ON D.COD_DEPTO = F.COD_DEPTO
WHERE F.COD_FUNC IS NULL                      -- resposta: MARKETING

-- Exemplo 8: autojuncao -> funcionario e o nome do chefe
-- F = o funcionario, C = o chefe (as duas sao a tabela FUNCIONARIO)
SELECT F.NOME AS FUNCIONARIO, C.NOME AS CHEFE
FROM FUNCIONARIO F
    INNER JOIN FUNCIONARIO C ON F.COD_CHEFE = C.COD_FUNC

-- Exemplo 9: juncao sem coluna igual (nao-identica): faixa salarial
SELECT F.NOME, F.SALARIO, FX.NIVEL
FROM FUNCIONARIO F
    INNER JOIN FAIXA_SALARIAL FX ON F.SALARIO BETWEEN FX.SAL_MIN AND FX.SAL_MAX


-- =====================================================================
-- EXERCICIOS
-- =====================================================================

-- E1) Mostre o nome de cada funcionario e o nome do departamento dele.
--     Faca na forma antiga e na forma nova.


-- E2) Mostre o titulo dos livros da categoria TECNOLOGIA (use o nome da
--     categoria no WHERE, nao o codigo).


-- E3) Mostre o nome dos clientes e a cidade, so de quem mora fora de SP.


-- E4) Quais livros a cliente BEATRIZ SANTOS comprou?
--     (CLIENTE -> PEDIDO -> ITEM_PEDIDO -> LIVRO)


-- E5) Mostre todas as categorias e os livros de cada uma, inclusive a
--     categoria que nao tem livro.


-- E6) Quais clientes nunca fizeram pedido?


-- E7) Mostre o nome de cada funcionario e o nome do chefe. Quem nao tem
--     chefe tambem deve aparecer.


-- E8) Quantas linhas aparecem em SELECT * FROM CIDADE, DEPARTAMENTO ?
--     Por que?



/* =====================================================================
   RESPOSTAS - so desca ate aqui depois de tentar!
   =====================================================================















   ===================================================================== */
/* ==== RESPOSTAS

-- E1  forma antiga
SELECT F.NOME, D.NOME AS DEPTO
FROM FUNCIONARIO F, DEPARTAMENTO D
WHERE F.COD_DEPTO = D.COD_DEPTO
-- forma nova
SELECT F.NOME, D.NOME AS DEPTO
FROM FUNCIONARIO F
    INNER JOIN DEPARTAMENTO D ON F.COD_DEPTO = D.COD_DEPTO

-- E2
SELECT L.TITULO
FROM LIVRO L
    INNER JOIN CATEGORIA C ON L.COD_CATEGORIA = C.COD_CATEGORIA
WHERE C.NOME = 'TECNOLOGIA'

-- E3
SELECT CL.NOME, CI.NOME AS CIDADE, CI.UF
FROM CLIENTE CL
    INNER JOIN CIDADE CI ON CL.COD_CIDADE = CI.COD_CIDADE
WHERE CI.UF <> 'SP'

-- E4  (4 tabelas = 3 ligacoes)
SELECT L.TITULO
FROM CLIENTE CL
    INNER JOIN PEDIDO P      ON CL.COD_CLIENTE = P.COD_CLIENTE
    INNER JOIN ITEM_PEDIDO I ON P.NUM_PEDIDO   = I.NUM_PEDIDO
    INNER JOIN LIVRO L       ON I.COD_LIVRO    = L.COD_LIVRO
WHERE CL.NOME = 'BEATRIZ SANTOS'

-- E5  (POESIA aparece com TITULO NULL)
SELECT C.NOME AS CATEGORIA, L.TITULO
FROM CATEGORIA C
    LEFT JOIN LIVRO L ON C.COD_CATEGORIA = L.COD_CATEGORIA

-- E6  (resposta: VINICIUS ARAUJO)
SELECT CL.NOME
FROM CLIENTE CL
    LEFT JOIN PEDIDO P ON CL.COD_CLIENTE = P.COD_CLIENTE
WHERE P.NUM_PEDIDO IS NULL

-- E7  (LEFT para a HELENA, que nao tem chefe, aparecer)
SELECT F.NOME AS FUNCIONARIO, C.NOME AS CHEFE
FROM FUNCIONARIO F
    LEFT JOIN FUNCIONARIO C ON F.COD_CHEFE = C.COD_FUNC

-- E8
-- 40 linhas: 8 cidades x 5 departamentos. Nao tem ligacao entre as
-- tabelas, entao vira produto cartesiano (cada cidade com cada depto).

==== FIM RESPOSTAS */
