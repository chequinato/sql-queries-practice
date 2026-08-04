-- ============================================
-- CONSTRAINTS (RESTRIÇÕES)
-- Regras para garantir integridade dos dados
-- ============================================

use base_de_dados;

-- ============================================
-- PRIMARY KEY (CHAVE PRIMÁRIA)
-- ============================================
-- Identifica exclusivamente cada registro
-- Não permite NULL, não permite duplicatas
-- Uma tabela só pode ter uma PRIMARY KEY

CREATE TABLE exemplo_pk (
    id INT PRIMARY KEY,
    nome VARCHAR(100)
);

-- Ou após criar a tabela
ALTER TABLE exemplo_pk ADD PRIMARY KEY (id);

-- PRIMARY KEY composta (múltiplas colunas)
CREATE TABLE exemplo_pk_composta (
    user_id INT,
    product_id INT,
    quantidade INT,
    PRIMARY KEY (user_id, product_id)
);

-- ============================================
-- FOREIGN KEY (CHAVE ESTRANGEIRA)
-- ============================================
-- Garante relacionamento entre tabelas
-- Impede inserção de registros que violam a relação
-- Protege contra exclusão de registros referenciados

CREATE TABLE orders (
    id INT PRIMARY KEY,
    user_id INT,
    total DECIMAL(10,2),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Adicionar FOREIGN KEY após criar tabela
ALTER TABLE orders 
ADD CONSTRAINT fk_orders_user 
FOREIGN KEY (user_id) REFERENCES users(id);

-- Opções de ON DELETE / ON UPDATE:
-- CASCADE - deleta/atualiza registros relacionados
-- SET NULL - define NULL nos registros relacionados
-- RESTRICT - impede ação se houver registros relacionados (padrão)
-- NO ACTION - similar a RESTRICT

ALTER TABLE orders 
ADD CONSTRAINT fk_orders_user 
FOREIGN KEY (user_id) REFERENCES users(id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- ============================================
-- UNIQUE (ÚNICO)
-- ============================================
-- Garante que não haja valores duplicados
-- Permite NULL (diferente de PRIMARY KEY)

CREATE TABLE exemplo_unique (
    id INT PRIMARY KEY,
    email VARCHAR(100) UNIQUE,
    cpf VARCHAR(11) UNIQUE
);

-- Adicionar UNIQUE após criar tabela
ALTER TABLE users ADD UNIQUE INDEX idx_email_unique (email);

-- ============================================
-- NOT NULL (NÃO NULO)
-- ============================================
-- Garante que a coluna sempre tenha um valor
-- Não permite NULL

CREATE TABLE exemplo_not_null (
    id INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL
);

-- Adicionar NOT NULL após criar tabela
ALTER TABLE users MODIFY first_name VARCHAR(100) NOT NULL;

-- ============================================
-- DEFAULT (VALOR PADRÃO)
-- ============================================
-- Define um valor padrão se nenhum for especificado

CREATE TABLE exemplo_default (
    id INT PRIMARY KEY,
    status VARCHAR(20) DEFAULT 'ativo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Adicionar DEFAULT após criar tabela
ALTER TABLE users 
ALTER COLUMN status SET DEFAULT 'ativo';

-- ============================================
-- CHECK (VERIFICAÇÃO)
-- ============================================
-- Valida se o valor atende uma condição
-- (Suporte varia por banco de dados)

CREATE TABLE exemplo_check (
    id INT PRIMARY KEY,
    idade INT CHECK (idade >= 18),
    salario DECIMAL(10,2) CHECK (salario > 0)
);

-- ============================================
-- REMOVER CONSTRAINT
-- ============================================
-- Remover FOREIGN KEY
ALTER TABLE orders DROP FOREIGN KEY fk_orders_user;

-- Remover PRIMARY KEY
ALTER TABLE exemplo_pk DROP PRIMARY KEY;

-- Remover UNIQUE
ALTER TABLE users DROP INDEX idx_email_unique;

-- ============================================
-- LISTAR CONSTRAINTS
-- ============================================
-- No MySQL
SELECT * FROM information_schema.TABLE_CONSTRAINTS 
WHERE TABLE_NAME = 'users';

-- ============================================
-- EXEMPLO COMPLETO
-- ============================================
CREATE TABLE produtos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) CHECK (preco > 0),
    estoque INT DEFAULT 0,
    sku VARCHAR(50) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE pedidos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    produto_id INT,
    quantidade INT CHECK (quantidade > 0),
    total DECIMAL(10,2),
    FOREIGN KEY (produto_id) REFERENCES produtos(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);
