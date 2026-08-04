-- ============================================
-- MANIPULAÇÃO DE DADOS
-- UPDATE, DELETE
-- ============================================

use base_de_dados;

-- ============================================
-- DELETE - Apaga registros da tabela
-- ============================================
-- CUIDADO: Sem WHERE, apaga TUDO!
DELETE FROM users where id = 115;

-- BOA PRÁTICA: Use SELECT antes para verificar
select * from users where id BETWEEN 110 and 115;

-- ============================================
-- UPDATE - Atualiza registros
-- ============================================
-- Pode atualizar múltiplas colunas de uma vez
update users set 
first_name = 'Luiz',
last_name = 'Miranda'
where id between 119 and 121;

-- Verificar o resultado
select * from users where id between 119 and 121;

-- ============================================
-- UPDATE com JOIN - Atualiza usando dados de outra tabela
-- ============================================
-- Primeiro, verificar o que será atualizado
select u.first_name, p.bio from users u
join profiles as p
on p.user_id = u.id
where u.first_name = 'Katelyn';

-- Atualiza profiles baseado em users
update users as u
join profiles as p
on p.user_id = u.id
set p.bio = CONCAT(p.bio, ' atualizado') 
where u.first_name = 'Katelyn';

-- ============================================
-- DELETE com JOIN - Apaga registros relacionados
-- ============================================
-- Primeiro, verificar o que será apagado
select u.first_name, p.bio from users u
left join profiles as p
on p.user_id = u.id
where u.first_name = 'Katelyn';

-- Apaga de ambas as tabelas
delete p, u from users u
left join profiles as p
on p.user_id = u.id
where u.first_name = 'Katelyn';

-- ============================================
-- Dica de segurança
-- ============================================
-- Sempre use SELECT antes de UPDATE/DELETE
-- para confirmar quais registros serão afetados
