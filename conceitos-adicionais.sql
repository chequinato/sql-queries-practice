-- ============================================
-- CONCEITOS ADICIONAIS SQL
-- DISTINCT, CASE, UNION, funções e mais
-- ============================================

use base_de_dados;

-- ============================================
-- DISTINCT - Remove duplicatas
-- ============================================
-- Retorna valores únicos de uma coluna
SELECT DISTINCT first_name FROM users;

-- DISTINCT em múltiplas colunas
SELECT DISTINCT first_name, last_name FROM users;

-- Contar valores únicos
SELECT COUNT(DISTINCT email) FROM users;

-- ============================================
-- CASE WHEN - Expressões condicionais
-- ============================================
-- Similar ao IF/ELSE em outras linguagens
SELECT 
first_name,
salary,
CASE 
    WHEN salary < 2000 THEN 'Baixo'
    WHEN salary BETWEEN 2000 AND 5000 THEN 'Médio'
    WHEN salary > 5000 THEN 'Alto'
    ELSE 'Não informado'
END as faixa_salarial
FROM users;

-- CASE com agregação
SELECT 
COUNT(CASE WHEN salary < 2000 THEN 1 END) as baixo,
COUNT(CASE WHEN salary BETWEEN 2000 AND 5000 THEN 1 END) as medio,
COUNT(CASE WHEN salary > 5000 THEN 1 END) as alto
FROM users;

-- ============================================
-- UNION / UNION ALL - Combinar resultados
-- ============================================
-- UNION remove duplicatas
-- UNION ALL mantém duplicatas (mais rápido)

SELECT first_name FROM users
UNION
SELECT first_name FROM admin_users;

-- UNION ALL (inclui duplicatas)
SELECT first_name FROM users
UNION ALL
SELECT first_name FROM admin_users;

-- Regras: mesmo número de colunas, tipos compatíveis

-- ============================================
-- COALESCE - Primeiro valor não NULL
-- ============================================
-- Retorna o primeiro valor não NULL da lista
SELECT 
first_name,
COALESCE(last_name, 'Sobrenome não informado') as last_name
FROM users;

-- ============================================
-- NULLIF - Retorna NULL se valores iguais
-- ============================================
SELECT 
NULLIF(salary, 0) as salary
FROM users;

-- ============================================
-- EXISTS / NOT EXISTS - Verificar existência
-- ============================================
-- Retorna TRUE se subquery retornar ao menos uma linha
SELECT * FROM users u
WHERE EXISTS (
    SELECT 1 FROM profiles p 
    WHERE p.user_id = u.id
);

-- NOT EXISTS
SELECT * FROM users u
WHERE NOT EXISTS (
    SELECT 1 FROM profiles p 
    WHERE p.user_id = u.id
);

-- ============================================
-- Funções de Data
-- ============================================
-- Data atual
SELECT NOW();
SELECT CURRENT_DATE();
SELECT CURRENT_TIME();

-- Extrair partes da data
SELECT 
YEAR(created_at) as ano,
MONTH(created_at) as mes,
DAY(created_at) as dia,
HOUR(created_at) as hora
FROM users;

-- Formatar data
SELECT DATE_FORMAT(created_at, '%d/%m/%Y %H:%i') 
FROM users;

-- Adicionar/subtrair datas
SELECT DATE_ADD(NOW(), INTERVAL 7 DAY);
SELECT DATE_SUB(NOW(), INTERVAL 1 MONTH);

-- Diferença entre datas
SELECT DATEDIFF('2021-12-31', '2021-01-01');

-- ============================================
-- Funções de String
-- ============================================
-- Concatenar
SELECT CONCAT(first_name, ' ', last_name) as nome_completo
FROM users;

-- Maiúsculas / Minúsculas
SELECT UPPER(email) FROM users;
SELECT LOWER(email) FROM users;

-- Tamanho da string
SELECT LENGTH(first_name) FROM users;

-- Extrair parte da string
SELECT SUBSTRING(email, 1, 5) FROM users;

-- Substituir
SELECT REPLACE(email, '@', '[arroba]') FROM users;

-- Remover espaços
SELECT TRIM('  texto  ') as texto;

-- Posição de um caractere
SELECT LOCATE('@', email) FROM users;

-- ============================================
-- CTE (Common Table Expression)
-- ============================================
-- Subquery nomeada, melhora legibilidade
WITH usuarios_com_salario AS (
    SELECT first_name, salary 
    FROM users 
    WHERE salary > 3000
)
SELECT * FROM usuarios_com_salario
WHERE salary < 5000;

-- CTE com múltiplas subqueries
WITH media_salarial AS (
    SELECT AVG(salary) as media FROM users
),
acima_media AS (
    SELECT first_name, salary 
    FROM users, media_salarial
    WHERE salary > media_salarial.media
)
SELECT * FROM acima_media;

-- ============================================
-- Window Functions
-- ============================================
-- ROW_NUMBER - numera linhas
SELECT 
first_name,
salary,
ROW_NUMBER() OVER (ORDER BY salary DESC) as ranking
FROM users;

-- RANK - mesma posição para empates, pula posições
SELECT 
first_name,
salary,
RANK() OVER (ORDER BY salary DESC) as ranking
FROM users;

-- DENSE_RANK - mesma posição para empates, não pula
SELECT 
first_name,
salary,
DENSE_RANK() OVER (ORDER BY salary DESC) as ranking
FROM users;

-- SUM com OVER (acumulativo)
SELECT 
first_name,
salary,
SUM(salary) OVER (ORDER BY salary) as acumulado
FROM users;

-- ============================================
-- Views (Visões)
-- ============================================
-- Salva uma query como uma "tabela virtual"
CREATE VIEW usuarios_ativos AS
SELECT id, first_name, email 
FROM users 
WHERE created_at > '2020-01-01';

-- Usar a view
SELECT * FROM usuarios_ativos;

-- Remover view
DROP VIEW usuarios_ativos;

-- ============================================
-- Transactions (Transações)
-- ============================================
-- Agrupa operações, todas ou nenhuma é executada
START TRANSACTION;

INSERT INTO users (first_name, email) VALUES ('Teste', 'teste@email.com');
UPDATE users SET salary = 5000 WHERE first_name = 'Teste';

-- Commit confirma as alterações
COMMIT;

-- Rollback desfaz tudo
-- ROLLBACK;

-- ============================================
-- DDL (Data Definition Language)
-- ============================================
-- CREATE TABLE
CREATE TABLE nova_tabela (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL
);

-- ALTER TABLE - modificar estrutura
ALTER TABLE users ADD COLUMN telefone VARCHAR(20);
ALTER TABLE users DROP COLUMN telefone;
ALTER TABLE users MODIFY COLUMN nome VARCHAR(200);

-- DROP TABLE - remover tabela
DROP TABLE nova_tabela;

-- TRUNCATE TABLE - remover todos os registros
TRUNCATE TABLE users;
