-- ============================================
-- CONCEITOS BÁSICOS SQL
-- Seleção, inserção e visualização de dados
-- ============================================

-- Seleciona a base de dados para trabalhar
use base_de_dados;

-- Mostra todas as tabelas da base de dados
show tables;

-- Descreve as colunas e tipos de dados da tabela users
describe users;

-- ============================================
-- INSERT - Inserir registros na tabela
-- ============================================
insert into users 
(first_name, last_name, email, password_hash) values
("Helena", "A.", "1@email.com", "3_hash"),
("Joana", "B.", "2@email.com", "4_hash"),
("Rosana", "C.", "3@email.com", "5_hash");

-- ============================================
-- SELECT - Selecionar colunas específicas
-- ============================================
-- Seleciona colunas e usa aliases (apelidos) para renomeá-las
-- 'as' é opcional, mas recomendado para clareza
select 
u.email as uemail, 
u.id as uid, 
u.first_name as ufirst_name
from users as u;

-- ============================================
-- SELECT * - Selecionar todas as colunas
-- ============================================
select * from users;
