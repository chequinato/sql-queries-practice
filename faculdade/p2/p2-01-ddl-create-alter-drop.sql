/* =====================================================================
   P2 - BANCO DE DADOS | 01 - DDL: CRIAR, ALTERAR E APAGAR TABELAS
   ---------------------------------------------------------------------
   Aulas do professor: 07 A (divisao do SQL), 08 e 09 (Trabalho SQL
   Basico e exercicio Pacientes/Consultas).

   Este arquivo NAO precisa da livraria: ele cria o proprio banco (P2_DDL).
   Rode um bloco por vez: selecione o bloco e aperte F5.
   ===================================================================== */


/* ---------------------------------------------------------------------
   1) A DIVISAO DO SQL (cai em teoria)
   ---------------------------------------------------------------------
     DDL = mexe na ESTRUTURA  -> CREATE, ALTER, DROP
     DML = mexe nos DADOS     -> INSERT, UPDATE, DELETE
     DQL = CONSULTA           -> SELECT
     DCL = PERMISSOES         -> GRANT, REVOKE

   Jeito facil de lembrar:
     criou/mudou/apagou a TABELA ou a COLUNA? -> DDL
     criou/mudou/apagou uma LINHA?            -> DML

   ---------------------------------------------------------------------
   2) CREATE TABLE
   ---------------------------------------------------------------------
     CREATE TABLE NOME_DA_TABELA (
         COLUNA  TIPO  NULL ou NOT NULL,
         ...
         CONSTRAINT PK_... PRIMARY KEY (COLUNA)
     )

   Tipos mais usados:
     INT              numero inteiro
     NUMERIC(5,2)     numero com virgula: 5 digitos, 2 depois da virgula
                      (vai ate 999.99)
     MONEY            dinheiro
     CHAR(2)          texto de tamanho FIXO (UF, sigla)
     VARCHAR(40)      texto de tamanho VARIAVEL (nome, endereco)
     DATE / TIME      data / hora

   Regras (constraints):
     NOT NULL       -> campo obrigatorio
     PRIMARY KEY    -> identifica a linha (nao repete, nao fica vazio)
     FOREIGN KEY    -> liga com a PK de outra tabela
     CHECK          -> regra: CHECK (PRECO > 0)
     DEFAULT        -> valor automatico se nao informar: DEFAULT GETDATE()
     IDENTITY(1,1)  -> numero automatico 1, 2, 3... (nao informa no INSERT)

   ---------------------------------------------------------------------
   3) ALTER TABLE e DROP TABLE
   ---------------------------------------------------------------------
     ALTER TABLE T ADD COLUNA TIPO          -> cria coluna
     ALTER TABLE T DROP COLUMN COLUNA       -> apaga coluna
     ALTER TABLE T ALTER COLUMN COLUNA TIPO -> muda o tipo/tamanho
     DROP TABLE T                           -> apaga a tabela inteira

   CUIDADO NA PROVA:
     - CRIAR: primeiro a tabela "pai", depois a "filha" (a que tem a FK)
     - APAGAR: o contrario, primeiro a filha, depois o pai
     - DATA e palavra reservada: se a coluna se chamar DATA, use [DATA]
   --------------------------------------------------------------------- */


-- =====================================================================
-- EXEMPLOS (cenario: academia)
-- =====================================================================

-- cria um banco so para treinar (apaga antes se ja existir)
USE master
GO
IF DB_ID('P2_DDL') IS NOT NULL
BEGIN
    ALTER DATABASE P2_DDL SET SINGLE_USER WITH ROLLBACK IMMEDIATE
    DROP DATABASE P2_DDL
END
GO
CREATE DATABASE P2_DDL
GO
USE P2_DDL
GO

-- Exemplo 1: tabela PAI (nao depende de ninguem)
CREATE TABLE PLANO (
    COD_PLANO     INT          NOT NULL,
    DESCRICAO     VARCHAR(30)  NOT NULL,
    VALOR_MENSAL  NUMERIC(6,2) NOT NULL,
    CONSTRAINT PK_PLANO PRIMARY KEY (COD_PLANO),
    CONSTRAINT CK_PLANO_VALOR CHECK (VALOR_MENSAL > 0)
)
GO

-- Exemplo 2: tabela FILHA (tem FK para PLANO)
CREATE TABLE ALUNO (
    COD_ALUNO       INT         NOT NULL IDENTITY(1,1),   -- numero automatico
    NOME            VARCHAR(40) NOT NULL,
    DATA_MATRICULA  DATE        DEFAULT GETDATE(),        -- se nao informar, pega hoje
    COD_PLANO       INT         NOT NULL,
    CONSTRAINT PK_ALUNO PRIMARY KEY (COD_ALUNO),
    CONSTRAINT FK_ALUNO_PLANO FOREIGN KEY (COD_PLANO) REFERENCES PLANO (COD_PLANO)
)
GO

-- Exemplo 3: chave primaria COMPOSTA (duas colunas juntas)
-- um aluno tem varias avaliacoes: avaliacao 1, 2, 3... de cada aluno
CREATE TABLE AVALIACAO (
    COD_ALUNO  INT          NOT NULL,
    NUM_AVAL   INT          NOT NULL,
    [DATA]     DATE         NOT NULL,
    PESO       NUMERIC(5,2),
    CONSTRAINT PK_AVALIACAO PRIMARY KEY (COD_ALUNO, NUM_AVAL),
    CONSTRAINT FK_AVAL_ALUNO FOREIGN KEY (COD_ALUNO) REFERENCES ALUNO (COD_ALUNO)
)
GO

-- colocando dados para ver o IDENTITY e o DEFAULT funcionando
INSERT INTO PLANO (COD_PLANO, DESCRICAO, VALOR_MENSAL) VALUES (1, 'MENSAL', 120.00)
INSERT INTO ALUNO (NOME, COD_PLANO) VALUES ('JOAO', 1)    -- nao passei COD_ALUNO nem DATA
SELECT * FROM ALUNO                                       -- COD_ALUNO = 1, DATA = hoje
GO

-- Exemplo 4: ALTER TABLE
ALTER TABLE ALUNO ADD TELEFONE VARCHAR(15)          -- cria a coluna
GO
ALTER TABLE ALUNO ALTER COLUMN TELEFONE VARCHAR(20) -- aumenta o tamanho
GO
ALTER TABLE ALUNO DROP COLUMN TELEFONE              -- apaga a coluna
GO

-- Exemplo 5: DROP TABLE na ordem certa (filhas primeiro)
DROP TABLE AVALIACAO
DROP TABLE ALUNO
DROP TABLE PLANO
GO


-- =====================================================================
-- EXERCICIOS (cenario: clinica veterinaria)
-- Escreva a resposta embaixo de cada um e rode.
-- =====================================================================
/*
   Tabela TUTOR (o dono do animal)
     COD_TUTOR   inteiro       obrigatorio   PK
     NOME        texto 40      obrigatorio
     TELEFONE    texto 11      opcional

   Tabela ANIMAL
     COD_ANIMAL  inteiro automatico (1,1)    PK
     NOME        texto 30      obrigatorio
     ESPECIE     texto 15      obrigatorio
     PESO        numero 5,2    opcional      tem que ser maior que zero
     COD_TUTOR   inteiro       obrigatorio   FK -> TUTOR
*/

-- E1) Crie a tabela TUTOR.


-- E2) Crie a tabela ANIMAL.


-- E3) Adicione a coluna EMAIL (texto 40) na tabela TUTOR.


-- E4) Apague a coluna TELEFONE da tabela TUTOR.


-- E5) Apague as duas tabelas na ordem certa. Por que a ordem importa?


-- E6) (teoria) Diga se e DDL, DML, DQL ou DCL:
--     a) CREATE TABLE   b) INSERT   c) SELECT   d) ALTER TABLE
--     e) DELETE         f) GRANT    g) DROP TABLE   h) UPDATE



/* =====================================================================
   RESPOSTAS - so desca ate aqui depois de tentar!
   =====================================================================















   ===================================================================== */
/* ==== RESPOSTAS

-- E1
CREATE TABLE TUTOR (
    COD_TUTOR  INT          NOT NULL,
    NOME       VARCHAR(40)  NOT NULL,
    TELEFONE   VARCHAR(11),
    CONSTRAINT PK_TUTOR PRIMARY KEY (COD_TUTOR)
)
GO

-- E2
CREATE TABLE ANIMAL (
    COD_ANIMAL  INT          NOT NULL IDENTITY(1,1),
    NOME        VARCHAR(30)  NOT NULL,
    ESPECIE     VARCHAR(15)  NOT NULL,
    PESO        NUMERIC(5,2),
    COD_TUTOR   INT          NOT NULL,
    CONSTRAINT PK_ANIMAL PRIMARY KEY (COD_ANIMAL),
    CONSTRAINT CK_ANIMAL_PESO CHECK (PESO > 0),
    CONSTRAINT FK_ANIMAL_TUTOR FOREIGN KEY (COD_TUTOR) REFERENCES TUTOR (COD_TUTOR)
)
GO

-- E3
ALTER TABLE TUTOR ADD EMAIL VARCHAR(40)
GO

-- E4
ALTER TABLE TUTOR DROP COLUMN TELEFONE
GO

-- E5
DROP TABLE ANIMAL
DROP TABLE TUTOR
GO
-- ANIMAL primeiro, porque ele aponta (FK) para TUTOR. Se tentar apagar
-- TUTOR antes, o SQL Server da erro: ainda tem animal ligado nele.

-- E6
-- a) DDL   b) DML   c) DQL   d) DDL
-- e) DML   f) DCL   g) DDL   h) DML

==== FIM RESPOSTAS */
