-- ============================================
-- AULA 7B - COMANDOS DML
-- Material: "BD - Aula 14 A - Comandos DML" (SQL Server / T-SQL)
-- INSERT, DELETE, UPDATE, TRUNCATE
-- ============================================

-- ============================================
-- PREPARANDO O AMBIENTE
-- ============================================

-- Entra no banco master pra poder criar um banco novo
USE MASTER
GO

-- Cria o banco CORP_PEDIDOS definindo arquivo de dados (.MDF) e de log (.LDF)
-- SIZE = tamanho inicial, MAXSIZE = limite, FILEGROWTH = quanto cresce por vez
CREATE DATABASE CORP_PEDIDOS ON PRIMARY
(
  NAME = N'CORP_PEDIDOS',
  FILENAME = N'C:\TEST\CORP_PEDIDOS.MDF',
  SIZE = 4 MB,
  MAXSIZE = 10 MB,
  FILEGROWTH = 2 MB
)
LOG ON
(
  NAME = N'CORP_PEDIDOS_LOG',
  FILENAME = N'C:\TEST\CORP_PEDIDOS_LOG.LDF',
  SIZE = 2 MB,
  MAXSIZE = 10 MB,
  FILEGROWTH = 2 MB
)
GO

-- Troca a conexão pro banco que acabou de ser criado
USE CORP_PEDIDOS
GO

-- Cria o schema "test" (tipo uma "pasta" pra agrupar as tabelas), dono = dbo
CREATE SCHEMA test AUTHORIZATION dbo
GO

-- Cria a tabela de clientes com chave primária no código
CREATE TABLE test.Cliente (
  Cod_Cliente   int not null,
  Nome_Cliente  varchar(30) not null,
  UF            char(02),
  constraint pk_Cliente Primary Key(cod_Cliente)
)
GO

-- ============================================
-- INSERT - Insere registros na tabela
-- ============================================

-- Insere linha a linha, informando as colunas na mesma ordem da tabela
insert into test.Cliente (Cod_Cliente, Nome_Cliente, UF)
values (6,'FERNANDA', 'SP')
GO
insert into test.Cliente (Cod_Cliente, Nome_Cliente, UF)
values (7,'MARINA', 'RJ')
GO
insert into test.Cliente (Cod_Cliente, Nome_Cliente, UF)
values (8,'EDUARDO', 'RJ')
GO
insert into test.Cliente (Cod_Cliente, Nome_Cliente, UF)
values (9,'SERGIO', 'RJ')
GO
insert into test.Cliente (Cod_Cliente, Nome_Cliente, UF)
values (10,'AMANDA', 'RJ')
GO

-- Insere informando as colunas em outra ordem: os valores seguem a ordem que VOCÊ escreveu
insert into test.Cliente (UF, Nome_Cliente, Cod_Cliente)
values ('MG','FABIANA',11)
GO
insert into test.Cliente (UF, Nome_Cliente, Cod_Cliente)
values ('TO','ERICA',12)
GO

-- Insere omitindo uma coluna (UF): ela fica NULL (só funciona se a coluna aceitar NULL)
insert into test.Cliente (Cod_Cliente, Nome_Cliente)
values (13,'JESSICA')
GO
insert into test.Cliente (Cod_Cliente, Nome_Cliente)
values (14,'ADRIANA')
GO

-- Confere os clientes inseridos até aqui
select * from test.Cliente
GO

-- Insere passando NULL explicitamente na coluna que não tem valor
insert into test.Cliente (Cod_Cliente, Nome_Cliente, UF)
values (15,'CRISTINA', NULL)
GO
insert into test.Cliente (Cod_Cliente, Nome_Cliente, UF)
values (16,'DANIELA', NULL)
GO

-- Insere EM LOTE: várias linhas num único INSERT (SQL Server 2008+)
insert into test.Cliente (Cod_Cliente, Nome_Cliente, UF)
values (17,'REGINA', 'AM'),
       (18,'AMALIA', 'SP'),
       (19,'FELIPE', 'PR'),
       (20,'CLAUDIA','RJ'),
       (21,'SIMONE', 'RO')
GO

-- Confere todos os clientes
select * from test.Cliente
GO

-- Exemplo do slide: INSERT ... SELECT copia pra uma tabela o resultado de uma consulta
-- (as tabelas Funcionarios/Estagiarios não existem neste script, por isso está comentado)
-- INSERT INTO Funcionarios
-- SELECT Estagiarios.* FROM Estagiarios WHERE DataDaContratacao < GETDATE() - 30

-- ============================================
-- TABELAS DE PRODUTO, PEDIDO E ITENS
-- ============================================

-- Cria a tabela de produtos
-- IDENTITY(1,1): o código é gerado sozinho (começa em 1 e soma 1)
-- CHECK: compra tem que ser > 0 e venda tem que ser maior que a compra
CREATE TABLE test.Produto (
  Cod_Prod     int not null identity(1,1),
  Desc_Prod    varchar(30) not null,
  Valor_Compra money,
  Valor_Venda  money,
  Constraint pk_Produto Primary key(Cod_Prod),
  Constraint ck_VrCompra Check (Valor_Compra > 0),
  Constraint ck_VrVenda  Check (Valor_Venda > Valor_Compra)
)
GO

-- Insere produtos em lote sem informar Cod_Prod (o IDENTITY preenche)
INSERT INTO test.Produto (Desc_Prod, Valor_Compra, Valor_Venda)
values ('SABONETE',      1.50,  2.50),
       ('SABAO EM PO',   4.25,  5.80),
       ('TOMATE',        2.50,  4.50),
       ('DETERGENTE',    3.75,  6.80),
       ('TOALHA',       10.50, 15.40),
       ('ALCOOL EM GEL', 4.50,  6.50),
       ('ALFINETE',      0.25,  1.98)
GO

-- Confere os produtos
select * from test.Produto
GO

-- Cria a tabela de pedidos
-- DEFAULT getdate(): se não informar a data, usa a data/hora atual
-- FOREIGN KEY: todo pedido tem que apontar pra um cliente que existe
CREATE TABLE test.Pedido (
  Cod_Pedido   int not null identity(1,1),
  Data_Pedido  datetime not null constraint df_Data_Pedido default getdate(),
  Cod_Cliente  int,
  constraint pk_Pedido Primary key(cod_Pedido),
  constraint ck_Data_Pedido Check (Data_Pedido >= getdate()),
  constraint fk_Pedido_Cliente Foreign Key(Cod_Cliente)
      references test.Cliente(Cod_Cliente)
)
GO

-- Insere pedidos informando só o cliente (código e data são automáticos)
insert into test.Pedido (Cod_cliente)
values (6),
       (6),
       (6),
       (7),
       (7),
       (8),
       (9),
       (9)
GO

-- Confere os pedidos
select * from test.Pedido
GO

-- Cria a tabela de itens do pedido
-- Chave primária COMPOSTA (Cod_Pedido + Item) e duas FKs (pedido e produto)
CREATE TABLE test.Itens_Pedido (
  Cod_Pedido   int not null,
  Item         tinyint not null,
  Cod_Prod     integer,
  Quantidade   integer,
  Valor_Venda  money,
  constraint pk_Itens_Pedido Primary key(Cod_Pedido,Item),
  constraint fk_IP_Cod_Pedido Foreign Key(Cod_Pedido)
    references test.Pedido(Cod_Pedido),
  constraint fk_IP_Cod_Produto Foreign Key(Cod_Prod)
      references test.Produto(Cod_Prod)
)
GO

-- Insere alguns itens pra ter relacionamento entre as tabelas (usado nos DELETEs abaixo)
insert into test.Itens_Pedido (Cod_Pedido, Item, Cod_Prod, Quantidade, Valor_Venda)
values (1, 1, 1, 2,  2.50),
       (1, 2, 2, 1,  5.80),
       (1, 3, 3, 5,  4.50),
       (1, 4, 4, 1,  6.80),
       (2, 1, 5, 1, 15.40),
       (2, 2, 6, 3,  6.50)
GO

-- Confere os itens de pedido
select * from test.Itens_Pedido
GO

-- ============================================
-- DELETE - Apaga registros da tabela
-- ============================================

-- Exemplos do slide (tabela Pedidos não existe aqui, por isso comentado):
-- DELETE sem WHERE apaga TUDO; com WHERE apaga só o que bate com a condição
-- DELETE FROM Pedidos
-- DELETE FROM Pedidos WHERE Pedidos.paisDeDestino = 'ALEMANHA'

-- Olha os produtos antes de apagar (boa prática: SELECT antes de DELETE)
select * from test.Produto
GO

-- Tenta apagar um produto que está num item de pedido: dá ERRO por causa da FK
delete FROM test.Produto WHERE Cod_Prod = 1
GO

-- Apaga um produto pela chave primária (jeito mais seguro de apagar)
-- BEGIN TRAN + ROLLBACK: testa o DELETE e depois desfaz, nada é apagado de verdade
begin tran
DELETE FROM test.Produto WHERE Cod_Prod = 7
select * from test.Produto
rollback
GO

-- DELETE sem WHERE tenta apagar TODOS os registros
-- aqui dá ERRO porque tem produto relacionado em Itens_Pedido (sem relacionamento, apagaria tudo!)
delete FROM test.Produto
GO

-- Apaga usando condição de faixa (BETWEEN)
DELETE FROM test.Produto
WHERE Cod_Prod between 18 and 21
GO

-- Em tabela com chave primária composta, olha o registro pelas duas colunas da chave
SELECT * FROM test.Itens_Pedido
WHERE Cod_Pedido = 1 and Item = 2
GO

-- Apaga UM item específico (informando as duas colunas da chave composta)
DELETE FROM test.Itens_Pedido
WHERE Cod_Pedido = 1 AND Item = 4
GO

-- Apaga TODOS os itens de um pedido (informando só parte da chave)
DELETE FROM test.Itens_Pedido
WHERE Cod_Pedido = 2
GO

-- ============================================
-- UPDATE - Atualiza registros
-- ============================================
-- Sem WHERE, atualiza TODAS as linhas! Sempre faça um SELECT antes.

-- A tabela Cliente não tem a coluna Cidade, então adiciona ela pros exemplos do slide
ALTER TABLE test.Cliente ADD Cidade varchar(30)
GO

-- Atualiza um cliente específico pela chave primária
UPDATE test.Cliente SET Cidade = 'JUNDIAI'
WHERE Cod_Cliente = 6
GO

-- Confere antes: produtos com valor de compra até 1
SELECT * FROM test.Produto WHERE Valor_Compra <= 1
GO

-- Atualiza usando condição em coluna que NÃO é chave (pode pegar várias linhas)
UPDATE test.Produto SET Valor_Venda = 5
WHERE Valor_Compra <= 1
GO

-- Atualizando FAIXAS de valores: atualiza a faixa MAIOR primeiro e depois a MENOR,
-- pra um mesmo produto não ser reajustado duas vezes

-- Confere a primeira faixa (compra entre 6 e 15)
select * from test.Produto WHERE Valor_Compra between 6 AND 15
GO

-- Reajusta em 20% a venda da faixa maior
UPDATE test.Produto SET Valor_Venda = Valor_Venda * 1.2
WHERE Valor_Compra between 6 AND 15
GO

-- Confere a segunda faixa (compra entre 1 e 5)
select * from test.Produto WHERE Valor_Compra between 1 AND 5
GO

-- Reajusta em 10% a venda da faixa menor
UPDATE test.Produto SET Valor_Venda = Valor_Venda * 1.10
WHERE Valor_Compra between 1 AND 5
GO

-- Confere antes de atualizar tudo
select * from test.Cliente
GO

-- UPDATE sem WHERE: muda a Cidade de TODOS os clientes
UPDATE test.Cliente SET Cidade = 'DOURADOS'
GO

-- ============================================
-- TRUNCATE - Esvazia a tabela inteira
-- ============================================
-- Apaga TODOS os registros, não aceita WHERE, é mais rápido que DELETE
-- (quase não grava no log de transação) e precisa de permissão ALTER.
-- Não funciona em tabela referenciada por FK (ex: test.Produto).

-- Esvazia a tabela de itens de pedido (nenhuma tabela aponta pra ela)
TRUNCATE TABLE test.Itens_Pedido
GO

-- Confere que ficou vazia
select * from test.Itens_Pedido
GO
