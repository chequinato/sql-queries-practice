-- ============================================
-- CONCEITOS AVANÇADOS
-- Subqueries, INSERT SELECT, operações complexas
-- ============================================

use base_de_dados;

-- ============================================
-- INSERT SELECT - Insere usando dados de outra tabela
-- ============================================
insert into profiles
(bio, description, user_id)
select 
concat('Bio de ', first_name), 
concat('Description de', ' ', first_name), 
id 
from users;

-- ============================================
-- Subquery no SELECT
-- ============================================
-- Executa uma query dentro de outra
select 
id, 
(select id from roles order by rand() limit 1) as qualquer 
from users;

-- ============================================
-- INSERT com subquery
-- ============================================
insert into users_roles (user_id, role_id)
select 
id, 
(select id from roles order by rand() limit 1) as qualquer 
from users;

-- ============================================
-- INSERT IGNORE - Ignora erros de duplicidade
-- ============================================
insert ignore into users_roles (user_id, role_id)
select 
id, 
(select id from roles order by rand() limit 1) as qualquer 
from users order by rand() limit 5;

-- ============================================
-- Funções úteis
-- ============================================
-- RAND() = número aleatório entre 0 e 1
-- ROUND(valor, casas) = arredondamento
-- CONCAT(str1, str2) = concatena strings

-- Configura salário aleatório para users
update users set salary = round(rand() * 10000, 2);

select salary from users where 
salary BETWEEN 1000 and 1500
order by salary asc;

-- ============================================
-- Inserção de roles
-- ============================================
INSERT INTO roles (name)
VALUES
('POST'),('PUT'),('DELETE'),('GET');

-- Inserção específica em tabela de relacionamento
INSERT INTO users_roles (user_id, role_id)
VALUES
(518, 4);

SELECT user_id, role_id from users_roles WHERE
user_id = 518 and role_id = 4;
