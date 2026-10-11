-- ============================================
-- AULA 7A - PROJETANDO BANCO DE DADOS
-- Material: "BD - Aula 06 A - Projetando BD" (SQL Server / T-SQL)
-- Modelo conceitual -> modelo lógico -> modelo físico
-- e a divisão da linguagem SQL (DDL, DML, DQL, DCL)
-- ============================================

-- ============================================
-- MODELO LÓGICO DO EXEMPLO DA AULA
-- ============================================
-- Aluno(mat_aluno, nome, endereco)
-- Turma(cod_turma, sala, periodo)
-- O modelo lógico só diz QUAIS tabelas e colunas existem.
-- O modelo físico (abaixo) é a tradução disso pro SGBD escolhido.

-- ============================================
-- DDL (Data Definition Language)
-- Cria/altera/apaga a ESTRUTURA do banco
-- ============================================

-- Cria a tabela Aluno com chave primária na matrícula
CREATE TABLE Aluno (
    mat_aluno  int not null,
    nome       varchar(50) not null,
    endereco   varchar(100),
    constraint pk_Aluno Primary Key(mat_aluno)
)
GO

-- Cria a tabela Turma com chave primária no código
CREATE TABLE Turma (
    cod_turma  int not null,
    sala       int,
    periodo    varchar(10),
    constraint pk_Turma Primary Key(cod_turma)
)
GO

-- Adiciona uma coluna numa tabela que já existe
ALTER TABLE Aluno ADD email varchar(60)
GO

-- Cria um índice pra acelerar buscas pelo nome do aluno
CREATE INDEX ix_Aluno_Nome ON Aluno (nome)
GO

-- ============================================
-- DML (Data Manipulation Language)
-- Mexe nos DADOS: INSERT, UPDATE, DELETE
-- ============================================

-- Insere os alunos do exemplo da aula
INSERT INTO Aluno (mat_aluno, nome, endereco)
VALUES (1, 'Cecília Ortiz Rezende', 'Rua dos Ipês, 37'),
       (2, 'Abílio José Dias', 'Avenida Presidente Jânio Quadros, 357'),
       (3, 'Renata Oliveira Franco', 'Rua Nove de Julho, 45')
GO

-- Insere as turmas do exemplo da aula
INSERT INTO Turma (cod_turma, sala, periodo)
VALUES (1, 8, 'Manhã'),
       (2, 5, 'Noite')
GO

-- Atualiza o período de uma turma específica
UPDATE Turma SET periodo = 'Tarde' WHERE cod_turma = 1
GO

-- Apaga um aluno específico pela chave primária
DELETE FROM Aluno WHERE mat_aluno = 3
GO

-- ============================================
-- DQL (Data Query Language)
-- Consulta os dados: SELECT
-- ============================================

-- Lista todos os alunos
SELECT * FROM Aluno
GO

-- Lista só as turmas da noite
SELECT cod_turma, sala FROM Turma WHERE periodo = 'Noite'
GO

-- ============================================
-- DCL (Data Control Language)
-- Segurança: usuários e permissões
-- ============================================

-- Cria um login no servidor e um usuário no banco ligado a ele
CREATE LOGIN aluno_login WITH PASSWORD = 'Troque@Essa123'
GO
CREATE USER aluno_user FOR LOGIN aluno_login
GO

-- Dá permissão de leitura na tabela Aluno
GRANT SELECT ON Aluno TO aluno_user
GO

-- Tira a permissão de volta
REVOKE SELECT ON Aluno FROM aluno_user
GO

-- ============================================
-- LIMPEZA (DDL de novo)
-- ============================================

-- Apaga o índice, as tabelas, o usuário e o login criados acima
DROP INDEX ix_Aluno_Nome ON Aluno
GO
DROP TABLE Aluno
GO
DROP TABLE Turma
GO
DROP USER aluno_user
GO
DROP LOGIN aluno_login
GO
