-- ============================================
-- ÍNDICES (INDEX)
-- O que são, quando usar e como criar
-- ============================================

use base_de_dados;

-- ============================================
-- O QUE SÃO ÍNDICES?
-- ============================================
-- Índices são estruturas de dados que melhoram a velocidade
-- de consultas (SELECT) em colunas frequentemente usadas em WHERE, JOIN, ORDER BY
-- Similar ao índice de um livro: facilita encontrar conteúdo sem ler tudo

-- ============================================
-- QUANDO USAR ÍNDICES?
-- ============================================
-- Colunas usadas frequentemente em WHERE
-- Colunas usadas em JOINs
-- Colunas usadas em ORDER BY
-- Colunas com muitos valores únicos (alta cardinalidade)

-- QUANDO NÃO USAR:
-- Tabelas pequenas (poucos registros)
-- Tabelas com muitas inserções/atualizações (índices deixam INSERT/UPDATE mais lentos)
-- Colunas com poucos valores únicos (baixa cardinalidade)

-- ============================================
-- CRIAR ÍNDICE SIMPLES
-- ============================================
-- Sintaxe: CREATE INDEX nome_indice ON tabela(coluna);
CREATE INDEX idx_users_email ON users(email);

-- ============================================
-- CRIAR ÍNDICE COMPOSTO (MÚLTIPLAS COLUNAS)
-- ============================================
-- Útil quando filtra por múltiplas colunas juntas
CREATE INDEX idx_users_name_email ON users(first_name, last_name);

-- ============================================
-- ÍNDICE ÚNICO (UNIQUE)
-- ============================================
-- Garante que não haja valores duplicados na coluna
CREATE UNIQUE INDEX idx_users_email_unique ON users(email);

-- ============================================
-- REMOVER ÍNDICE
-- ============================================
-- Sintaxe: DROP INDEX nome_indice ON tabela;
DROP INDEX idx_users_email ON users;

-- ============================================
-- LISTAR ÍNDICES DE UMA TABELA
-- ============================================
SHOW INDEX FROM users;

-- ============================================
-- ÍNDICE NA CRIAÇÃO DA TABELA
-- ============================================
CREATE TABLE exemplo (
    id INT PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100),
    INDEX idx_nome (nome),
    UNIQUE INDEX idx_email (email)
);

-- ============================================
-- FULLTEXT INDEX (BUSCA DE TEXTO)
-- ============================================
-- Para buscas de texto completo em colunas TEXT/VARCHAR
CREATE FULLTEXT INDEX idx_bio ON profiles(bio);

-- Usar na query com MATCH ... AGAINST
SELECT * FROM profiles 
WHERE MATCH(bio) AGAINST('palavra');

-- ============================================
-- EXEMPLO PRÁTICO
-- ============================================
-- Sem índice: varre toda a tabela
SELECT * FROM users WHERE email = 'teste@email.com';

-- Com índice: vai direto ao registro
CREATE INDEX idx_email ON users(email);
SELECT * FROM users WHERE email = 'teste@email.com';

-- ============================================
-- DICAS DE DESEMPENHO
-- ============================================
-- Use EXPLAIN para ver se o índice está sendo usado
EXPLAIN SELECT * FROM users WHERE email = 'teste@email.com';

-- Evite índices em colunas que mudam frequentemente
-- Não crie índices desnecessários - cada índice ocupa espaço
-- Considere o custo/benefício: mais rápido SELECT vs mais lento INSERT/UPDATE
