-- ============================================
-- JOINS - União de tabelas
-- INNER, LEFT, RIGHT JOIN
-- ============================================

use base_de_dados;

-- ============================================
-- JOIN implícito (estilo antigo)
-- ============================================
-- Une tabelas na cláusula WHERE
SELECT u.id as uid, p.id as pid,
p.bio, u.first_name 
FROM users as u, profiles as p
WHERE u.id = p.user_id;

-- ============================================
-- INNER JOIN - Apenas registros com correspondência
-- ============================================
-- Retorna apenas quando há match em AMBAS as tabelas
SELECT u.id as uid, p.id as pid,
p.bio, u.first_name
FROM users as u
INNER JOIN profiles p
ON u.id = p.user_id
WHERE u.first_name LIKE '%a'
ORDER BY u.first_name DESC
LIMIT 5;

-- ============================================
-- LEFT JOIN - Todos da tabela esquerda
-- ============================================
-- Tabela da esquerda (users) = todos os registros
-- Tabela da direita (profiles) = apenas quando houver match
-- NULL quando não há correspondência
SELECT u.id as uid, p.id as pid,
p.bio, u.first_name
FROM users as u
LEFT JOIN profiles p
ON u.id = p.user_id
WHERE u.first_name LIKE '%a'
ORDER BY u.first_name DESC
LIMIT 5;

-- ============================================
-- RIGHT JOIN - Todos da tabela direita
-- ============================================
-- Tabela da esquerda (users) = apenas quando houver match
-- Tabela da direita (profiles) = todos os registros
-- NULL quando não há correspondência
SELECT u.id as uid, p.id as pid,
p.bio, u.first_name
FROM users as u
RIGHT JOIN profiles p
ON u.id = p.user_id
WHERE u.first_name LIKE '%a'
ORDER BY u.first_name DESC
LIMIT 5;

-- ============================================
-- Resumo dos tipos de JOIN
-- ============================================
-- INNER JOIN: Apenas registros com match em ambas
-- LEFT JOIN: Todos da esquerda, match da direita (opcional)
-- RIGHT JOIN: Match da esquerda (opcional), todos da direita
-- FULL JOIN: Todos de ambas (não suportado em MySQL)
