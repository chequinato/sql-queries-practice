-- ============================================
-- AGREGAÇÃO DE DADOS
-- GROUP BY, funções de agregação
-- ============================================

use base_de_dados;

-- ============================================
-- GROUP BY - Agrupa valores
-- ============================================
-- Agrupa por first_name e conta quantos registros
SELECT first_name, COUNT(id) as total FROM users
GROUP BY first_name
ORDER BY total DESC;

-- GROUP BY com JOIN
select u.first_name, COUNT(u.id) as total from users u
left join profiles as p
on p.user_id = u.id
WHERE u.id IN (617, 539, 537, 611)
GROUP BY first_name
ORDER BY total DESC
LIMIT 5;

-- ============================================
-- Funções de agregação
-- ============================================
-- MAX = maior valor
-- MIN = menor valor
-- AVG = média
-- SUM = soma total
-- COUNT = quantidade de registros
SELECT 
max(salary) as max_salary,
min(salary) as min_salary,
avg(salary) as avg_salary,
sum(salary) as sum_salary,
count(salary) as count_salary
FROM users;

-- ============================================
-- Agregação com GROUP BY e JOIN
-- ============================================
select 
u.first_name,
max(u.salary) as max_salary,
min(u.salary) as min_salary,
avg(u.salary) as avg_salary,
sum(u.salary) as sum_salary,
COUNT(u.id) as total
from users u
left join profiles as p
on p.user_id = u.id
GROUP BY u.first_name
ORDER BY total DESC;

-- ============================================
-- HAVING - Filtra grupos (após GROUP BY)
-- ============================================
-- WHERE filtra antes do agrupamento
-- HAVING filtra após o agrupamento
SELECT first_name, COUNT(id) as total 
FROM users
GROUP BY first_name
HAVING total > 1
ORDER BY total DESC;
