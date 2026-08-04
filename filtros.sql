-- ============================================
-- FILTROS SQL
-- WHERE, BETWEEN, IN, LIKE
-- ============================================

use base_de_dados;

-- ============================================
-- WHERE - Filtra registros com condições
-- ============================================
-- Operadores de comparação: =, <, <=, >, >=, <>, !=
-- Operadores lógicos: AND, OR
select * from users
where 
created_at < '2020-12-15 23:33:41'
and first_name = 'Luiz' 
and password_hash = 'a_hash';

-- ============================================
-- BETWEEN - Seleciona um intervalo de valores
-- ============================================
-- Inclui os valores extremos (inclusive)
select * from users
where 
created_at between 
'2020-06-12 00:00:00' 
and '2020-09-04 23:59:59'
and id between 163 and 210;

-- ============================================
-- IN - Seleciona elementos entre valores específicos
-- ============================================
-- Equivalente a múltiplas condições OR
select * from users
where id in (110, 115, 120, 125, 130, 1000, 12200, 1212545)
and first_name in ('Luiz', 'Keelie');

-- ============================================
-- LIKE - Busca padrões de texto
-- ============================================
-- % = qualquer quantidade de caracteres
-- _ = exatamente um caractere
select * from users
where first_name like '%ma%_';
-- Exemplos:
-- 'a%' = começa com 'a'
-- '%a' = termina com 'a'
-- '%a%' = contém 'a' em qualquer posição
-- '_a' = tem 'a' como segunda letra
