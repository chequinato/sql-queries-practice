-- ============================================
-- ORDENAÇÃO E LIMITAÇÃO
-- ORDER BY, LIMIT, OFFSET
-- ============================================

use base_de_dados;

-- ============================================
-- ORDER BY - Ordena os resultados
-- ============================================
-- ASC = crescente (padrão)
-- DESC = decrescente
-- Pode ordenar por múltiplas colunas (prioridade pela ordem)
select id, first_name, email as uemail 
from users
where id between 100 and 150
order by first_name desc;

-- Ordenação múltipla: prioriza id, depois first_name
select id, first_name, email 
from users
order by id asc, first_name desc;

-- ============================================
-- LIMIT - Limita quantidade de registros
-- ============================================
select id, first_name, email 
from users
limit 10;

-- ============================================
-- OFFSET - Desloca o cursor (pula registros)
-- ============================================
-- Sintaxe: LIMIT offset, quantidade
-- LIMIT 9,3 = pula 9 registros, mostra 3
select id, first_name, email as uemail 
from users
where id between 100 and 150
order by id asc
limit 9, 3;

-- Paginação comum:
-- Página 1: LIMIT 0, 10
-- Página 2: LIMIT 10, 10
-- Página 3: LIMIT 20, 10
