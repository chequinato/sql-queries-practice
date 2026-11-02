/* =====================================================================
   P2 - BANCO DE DADOS | 00 - BASE DE TREINO (LIVRARIA)
   ---------------------------------------------------------------------
   RODE ESTE ARQUIVO PRIMEIRO (no SQL Server / SSMS, aperte F5).
   Ele cria o banco P2_LIVRARIA com tudo pronto para treinar.
   Os arquivos 02 a 08 usam esse banco.
   Estragou os dados treinando? E so rodar este arquivo de novo.

   As tabelas (PK = chave primaria, FK = chave estrangeira):

     CIDADE        (COD_CIDADE PK, NOME, UF)
     DEPARTAMENTO  (COD_DEPTO PK, NOME)
     FUNCIONARIO   (COD_FUNC PK, NOME, CARGO, SALARIO, DATA_ADMISSAO,
                    COD_DEPTO FK, COD_CHEFE FK, COD_CIDADE FK)
                    -> COD_CHEFE aponta para outro FUNCIONARIO
     CLIENTE       (COD_CLIENTE PK, NOME, EMAIL, DATA_CADASTRO, COD_CIDADE FK)
     CATEGORIA     (COD_CATEGORIA PK, NOME)
     LIVRO         (COD_LIVRO PK, TITULO, AUTOR, ANO_PUBLICACAO, PRECO,
                    ESTOQUE, COD_CATEGORIA FK)
     PEDIDO        (NUM_PEDIDO PK, DATA_PEDIDO, DATA_ENTREGA,
                    COD_CLIENTE FK, COD_FUNC FK)
                    -> DATA_ENTREGA vazia (NULL) = ainda nao foi entregue
     ITEM_PEDIDO   (NUM_PEDIDO PK FK, ITEM PK, COD_LIVRO FK,
                    QUANTIDADE, PRECO_UNIT)
     FAIXA_SALARIAL (NIVEL PK, SAL_MIN, SAL_MAX)

   Como as tabelas se ligam:

     CIDADE ---< CLIENTE ---< PEDIDO >--- FUNCIONARIO >--- DEPARTAMENTO
                                |
                                ^
                           ITEM_PEDIDO >--- LIVRO >--- CATEGORIA

     ( A ---< B  quer dizer: um A tem varios B )

   Alguns dados foram colocados de proposito para os exercicios:
     - o departamento MARKETING nao tem funcionario
     - a categoria POESIA nao tem livro
     - a cidade MANAUS nao tem cliente nem funcionario
     - o cliente VINICIUS nunca fez pedido
     - a funcionaria ANA PAULA nao tem departamento
     - a diretora HELENA nao tem chefe
     - os livros 3 e 15 nunca foram vendidos

   Datas: escrevi no formato 'AAAAMMDD' (ex: '20250108' = 08/01/2025),
   que funciona em qualquer SQL Server.
   ===================================================================== */

USE master
GO

-- se o banco ja existir, apaga para criar de novo do zero
IF DB_ID('P2_LIVRARIA') IS NOT NULL
BEGIN
    ALTER DATABASE P2_LIVRARIA SET SINGLE_USER WITH ROLLBACK IMMEDIATE
    DROP DATABASE P2_LIVRARIA
END
GO

CREATE DATABASE P2_LIVRARIA
GO

USE P2_LIVRARIA
GO

-- ---------------------------------------------------------------------
-- TABELAS (primeiro as que nao dependem de ninguem)
-- ---------------------------------------------------------------------
CREATE TABLE CIDADE (
    COD_CIDADE  INT         NOT NULL,
    NOME        VARCHAR(30) NOT NULL,
    UF          CHAR(2)     NOT NULL,
    CONSTRAINT PK_CIDADE PRIMARY KEY (COD_CIDADE)
)
GO

CREATE TABLE DEPARTAMENTO (
    COD_DEPTO   CHAR(3)     NOT NULL,
    NOME        VARCHAR(30) NOT NULL,
    CONSTRAINT PK_DEPARTAMENTO PRIMARY KEY (COD_DEPTO)
)
GO

CREATE TABLE FAIXA_SALARIAL (
    NIVEL       CHAR(1)       NOT NULL,
    SAL_MIN     NUMERIC(10,2) NOT NULL,
    SAL_MAX     NUMERIC(10,2) NOT NULL,
    CONSTRAINT PK_FAIXA_SALARIAL PRIMARY KEY (NIVEL)
)
GO

CREATE TABLE FUNCIONARIO (
    COD_FUNC       INT           NOT NULL,
    NOME           VARCHAR(40)   NOT NULL,
    CARGO          VARCHAR(30)   NOT NULL,
    SALARIO        NUMERIC(10,2) NOT NULL,
    DATA_ADMISSAO  DATE          NOT NULL,
    COD_DEPTO      CHAR(3),
    COD_CHEFE      INT,
    COD_CIDADE     INT,
    CONSTRAINT PK_FUNCIONARIO PRIMARY KEY (COD_FUNC),
    CONSTRAINT FK_FUNC_DEPTO  FOREIGN KEY (COD_DEPTO)  REFERENCES DEPARTAMENTO (COD_DEPTO),
    CONSTRAINT FK_FUNC_CHEFE  FOREIGN KEY (COD_CHEFE)  REFERENCES FUNCIONARIO (COD_FUNC),
    CONSTRAINT FK_FUNC_CIDADE FOREIGN KEY (COD_CIDADE) REFERENCES CIDADE (COD_CIDADE)
)
GO

CREATE TABLE CLIENTE (
    COD_CLIENTE    INT         NOT NULL,
    NOME           VARCHAR(40) NOT NULL,
    EMAIL          VARCHAR(40),
    DATA_CADASTRO  DATE        NOT NULL,
    COD_CIDADE     INT,
    CONSTRAINT PK_CLIENTE PRIMARY KEY (COD_CLIENTE),
    CONSTRAINT FK_CLIENTE_CIDADE FOREIGN KEY (COD_CIDADE) REFERENCES CIDADE (COD_CIDADE)
)
GO

CREATE TABLE CATEGORIA (
    COD_CATEGORIA  INT         NOT NULL,
    NOME           VARCHAR(30) NOT NULL,
    CONSTRAINT PK_CATEGORIA PRIMARY KEY (COD_CATEGORIA)
)
GO

CREATE TABLE LIVRO (
    COD_LIVRO       INT           NOT NULL,
    TITULO          VARCHAR(40)   NOT NULL,
    AUTOR           VARCHAR(30)   NOT NULL,
    ANO_PUBLICACAO  INT,
    PRECO           NUMERIC(10,2) NOT NULL,
    ESTOQUE         INT           NOT NULL,
    COD_CATEGORIA   INT           NOT NULL,
    CONSTRAINT PK_LIVRO PRIMARY KEY (COD_LIVRO),
    CONSTRAINT FK_LIVRO_CATEGORIA FOREIGN KEY (COD_CATEGORIA) REFERENCES CATEGORIA (COD_CATEGORIA),
    CONSTRAINT CK_LIVRO_PRECO CHECK (PRECO > 0)
)
GO

CREATE TABLE PEDIDO (
    NUM_PEDIDO    INT  NOT NULL,
    DATA_PEDIDO   DATE NOT NULL,
    DATA_ENTREGA  DATE,
    COD_CLIENTE   INT  NOT NULL,
    COD_FUNC      INT  NOT NULL,
    CONSTRAINT PK_PEDIDO PRIMARY KEY (NUM_PEDIDO),
    CONSTRAINT FK_PEDIDO_CLIENTE FOREIGN KEY (COD_CLIENTE) REFERENCES CLIENTE (COD_CLIENTE),
    CONSTRAINT FK_PEDIDO_FUNC    FOREIGN KEY (COD_FUNC)    REFERENCES FUNCIONARIO (COD_FUNC)
)
GO

CREATE TABLE ITEM_PEDIDO (
    NUM_PEDIDO  INT           NOT NULL,
    ITEM        INT           NOT NULL,
    COD_LIVRO   INT           NOT NULL,
    QUANTIDADE  INT           NOT NULL,
    PRECO_UNIT  NUMERIC(10,2) NOT NULL,
    CONSTRAINT PK_ITEM_PEDIDO PRIMARY KEY (NUM_PEDIDO, ITEM),
    CONSTRAINT FK_ITEM_PEDIDO FOREIGN KEY (NUM_PEDIDO) REFERENCES PEDIDO (NUM_PEDIDO),
    CONSTRAINT FK_ITEM_LIVRO  FOREIGN KEY (COD_LIVRO)  REFERENCES LIVRO (COD_LIVRO)
)
GO

-- ---------------------------------------------------------------------
-- DADOS (primeiro o "pai", depois o "filho" que aponta para ele)
-- ---------------------------------------------------------------------
INSERT INTO CIDADE (COD_CIDADE, NOME, UF) VALUES
    (1, 'JUNDIAI',        'SP'),
    (2, 'CAMPINAS',       'SP'),
    (3, 'SAO PAULO',      'SP'),
    (4, 'VALINHOS',       'SP'),
    (5, 'CURITIBA',       'PR'),
    (6, 'BELO HORIZONTE', 'MG'),
    (7, 'RIO DE JANEIRO', 'RJ'),
    (8, 'MANAUS',         'AM')
GO

INSERT INTO DEPARTAMENTO (COD_DEPTO, NOME) VALUES
    ('DIR', 'DIRETORIA'),
    ('VEN', 'VENDAS'),
    ('EST', 'ESTOQUE'),
    ('FIN', 'FINANCEIRO'),
    ('MKT', 'MARKETING')
GO

INSERT INTO FAIXA_SALARIAL (NIVEL, SAL_MIN, SAL_MAX) VALUES
    ('A',     0.00,  2499.99),
    ('B',  2500.00,  4999.99),
    ('C',  5000.00,  9999.99),
    ('D', 10000.00, 99999.99)
GO

INSERT INTO FUNCIONARIO (COD_FUNC, NOME, CARGO, SALARIO, DATA_ADMISSAO, COD_DEPTO, COD_CHEFE, COD_CIDADE) VALUES
    (1,  'HELENA COSTA',   'DIRETORA',            15000.00, '20150301', 'DIR', NULL, 1),
    (2,  'MARCOS LIMA',    'GERENTE DE VENDAS',    8000.00, '20170615', 'VEN', 1,    1),
    (3,  'JULIA ROCHA',    'VENDEDORA',            3200.00, '20200210', 'VEN', 2,    1),
    (4,  'PEDRO ALVES',    'VENDEDOR',             2900.00, '20210801', 'VEN', 2,    4),
    (5,  'BRUNA DIAS',     'VENDEDORA',            3500.00, '20191120', 'VEN', 2,    2),
    (6,  'CARLOS MENDES',  'ESTOQUISTA',           2200.00, '20220105', 'EST', 1,    1),
    (7,  'RAFAEL SOUZA',   'ESTOQUISTA',           2100.00, '20230417', 'EST', 6,    1),
    (8,  'LARISSA GOMES',  'ANALISTA FINANCEIRO',  5200.00, '20180903', 'FIN', 1,    3),
    (9,  'TIAGO RIBEIRO',  'VENDEDOR',             2700.00, '20240311', 'VEN', 2,    1),
    (10, 'ANA PAULA REIS', 'ESTAGIARIA',           1500.00, '20250701', NULL,  8,    1)
GO

INSERT INTO CLIENTE (COD_CLIENTE, NOME, EMAIL, DATA_CADASTRO, COD_CIDADE) VALUES
    (1,  'BEATRIZ SANTOS',    'bia@email.com',     '20230110', 1),
    (2,  'LUCAS PEREIRA',     NULL,                '20230522', 1),
    (3,  'MARIANA SOUZA',     'mari@email.com',    '20230814', 2),
    (4,  'GABRIEL MARTINS',   'gabriel@email.com', '20240201', 3),
    (5,  'FERNANDA OLIVEIRA', NULL,                '20240418', 3),
    (6,  'RODRIGO BARBOSA',   'rodrigo@email.com', '20240630', 5),
    (7,  'CAMILA FERREIRA',   'camila@email.com',  '20240909', 6),
    (8,  'DIEGO CARVALHO',    NULL,                '20250115', 4),
    (9,  'ISABELA NUNES',     'isa@email.com',     '20250303', 1),
    (10, 'VINICIUS ARAUJO',   'vini@email.com',    '20251020', 7)
GO

INSERT INTO CATEGORIA (COD_CATEGORIA, NOME) VALUES
    (1, 'ROMANCE'),
    (2, 'FICCAO CIENTIFICA'),
    (3, 'TECNOLOGIA'),
    (4, 'INFANTIL'),
    (5, 'HISTORIA'),
    (6, 'POESIA')
GO

INSERT INTO LIVRO (COD_LIVRO, TITULO, AUTOR, ANO_PUBLICACAO, PRECO, ESTOQUE, COD_CATEGORIA) VALUES
    (1,  'O SOL DA TARDE',                  'ANA LUZ',        2019,  49.90, 30, 1),
    (2,  'CARTAS PARA MARINA',              'PAULO NERY',     2021,  39.90, 12, 1),
    (3,  'NOITES DE INVERNO',               'ANA LUZ',        2023,  54.90,  0, 1),
    (4,  'A ULTIMA ESTACAO',                'RUI CAMPOS',     2018,  59.90, 25, 2),
    (5,  'ROBOS DE MARTE',                  'LIA TORRES',     2022,  64.90,  8, 2),
    (6,  'O PLANETA AZUL',                  'RUI CAMPOS',     2020,  44.90, 40, 2),
    (7,  'SQL SEM MEDO',                    'CARLOS VIANA',   2024,  89.90, 15, 3),
    (8,  'PYTHON NA PRATICA',               'CARLOS VIANA',   2023,  99.90, 20, 3),
    (9,  'REDES DE COMPUTADORES',           'MARTA SILVEIRA', 2017, 120.00,  5, 3),
    (10, 'BANCO DE DADOS DO ZERO',          'JOAO PRADO',     2025,  79.90, 10, 3),
    (11, 'O GATO E A LUA',                  'BIA FONTES',     2016,  29.90, 50, 4),
    (12, 'TURMA DA ARVORE',                 'BIA FONTES',     2021,  34.90, 35, 4),
    (13, 'HISTORIA DO BRASIL EM 100 FATOS', 'HUGO MATOS',     2019,  69.90, 18, 5),
    (14, 'IMPERIOS ANTIGOS',                'HUGO MATOS',     2022,  74.90,  7, 5),
    (15, 'GUERRAS DO SECULO XX',            'NINA ROCHA',     2020,  84.90,  0, 5)
GO

INSERT INTO PEDIDO (NUM_PEDIDO, DATA_PEDIDO, DATA_ENTREGA, COD_CLIENTE, COD_FUNC) VALUES
    (1,  '20250108', '20250112', 1, 3),
    (2,  '20250120', '20250125', 2, 3),
    (3,  '20250203', '20250207', 3, 5),
    (4,  '20250214', '20250218', 1, 4),
    (5,  '20250310', '20250315', 4, 5),
    (6,  '20250422', '20250426', 5, 3),
    (7,  '20250505', '20250512', 6, 2),
    (8,  '20250618', '20250624', 7, 5),
    (9,  '20250801', '20250805', 1, 3),
    (10, '20250912', '20250915', 8, 4),
    (11, '20251030', NULL,       9, 5),
    (12, '20251115', NULL,       3, 3),
    (13, '20260109', NULL,       4, 4),
    (14, '20260220', NULL,       2, 5)
GO

INSERT INTO ITEM_PEDIDO (NUM_PEDIDO, ITEM, COD_LIVRO, QUANTIDADE, PRECO_UNIT) VALUES
    (1,  1,  1, 2,  49.90),
    (1,  2, 11, 1,  29.90),
    (2,  1,  7, 1,  89.90),
    (3,  1,  4, 1,  59.90),
    (3,  2,  5, 1,  64.90),
    (3,  3,  6, 2,  44.90),
    (4,  1,  8, 1,  99.90),
    (4,  2,  7, 1,  89.90),
    (5,  1, 13, 1,  69.90),
    (6,  1,  2, 3,  39.90),
    (6,  2, 12, 2,  34.90),
    (7,  1,  9, 1, 120.00),
    (7,  2, 10, 1,  79.90),
    (8,  1, 11, 4,  29.90),
    (9,  1,  1, 1,  49.90),
    (9,  2, 14, 1,  74.90),
    (10, 1,  6, 1,  44.90),
    (11, 1,  7, 2,  89.90),
    (11, 2,  8, 1,  99.90),
    (12, 1, 12, 1,  34.90),
    (13, 1, 10, 1,  79.90),
    (13, 2,  5, 1,  64.90),
    (14, 1,  4, 1,  59.90)
GO

-- conferindo: de uma olhada nas tabelas
SELECT * FROM CLIENTE
SELECT * FROM LIVRO
SELECT * FROM PEDIDO
GO
