# SQL Queries Practice

Repositório com conceitos e exemplos práticos de SQL e banco de dados.

## 📁 Estrutura dos Arquivos

- **conceitos-basicos.sql** - Comandos básicos: SELECT, INSERT, SHOW, DESCRIBE
- **filtros.sql** - Filtragem de dados: WHERE, BETWEEN, IN, LIKE
- **ordenacao-limit.sql** - Ordenação e paginação: ORDER BY, LIMIT, OFFSET
- **joins.sql** - União de tabelas: INNER, LEFT, RIGHT JOIN
- **manipulacao-dados.sql** - Modificação de dados: UPDATE, DELETE
- **agregacao.sql** - Agrupamento e funções: GROUP BY, COUNT, SUM, AVG
- **avancado.sql** - Conceitos avançados: subqueries, INSERT SELECT
- **indices.sql** - Índices: o que são, quando usar, como criar
- **constraints.sql** - Restrições: PRIMARY KEY, FOREIGN KEY, UNIQUE, NOT NULL
- **conceitos-adicionais.sql** - DISTINCT, CASE, UNION, funções, CTE, Views, Transactions, DDL
- **exercicios.sql** - 10 exercícios práticos para praticar
- **exemplo-woocommerce.sql** - Exemplo real com múltiplos JOINs
- **dados-exemplo.sql** - Dados de exemplo para testes

## 🚀 Como Usar

1. Configure sua base de dados:
```sql
CREATE DATABASE base_de_dados;
USE base_de_dados;
```

2. Crie as tabelas necessárias (users, profiles, roles, users_roles)

3. Execute os arquivos em ordem de dificuldade:
   - Comece por `conceitos-basicos.sql`
   - Avance para `filtros.sql` e `ordenacao-limit.sql`
   - Pratique com `joins.sql`
   - Aprenda manipulação com `manipulacao-dados.sql`
   - Domine agregação com `agregacao.sql`
   - Desafie-se com `avancado.sql`
   - Aprenda sobre índices em `indices.sql`
   - Entenda constraints em `constraints.sql`
   - Explore conceitos adicionais em `conceitos-adicionais.sql`
   - Teste seus conhecimentos em `exercicios.sql`

## 📚 Conceitos Cobertos

### Básico
- Seleção de dados (SELECT)
- Inserção de registros (INSERT)
- Visualização de estrutura (SHOW, DESCRIBE)

### Filtros
- Condições (WHERE)
- Intervalos (BETWEEN)
- Listas (IN)
- Padrões de texto (LIKE)

### Ordenação
- Ordenação (ORDER BY)
- Limite de resultados (LIMIT)
- Paginação (OFFSET)

### Joins
- INNER JOIN
- LEFT JOIN
- RIGHT JOIN

### Manipulação
- Atualização (UPDATE)
- Exclusão (DELETE)
- Operações com JOIN

### Agregação
- Agrupamento (GROUP BY)
- Funções: COUNT, SUM, AVG, MAX, MIN
- Filtro de grupos (HAVING)

### Avançado
- Subqueries
- INSERT SELECT
- Operações complexas

### Índices
- O que são e quando usar
- CREATE INDEX
- Índices compostos
- Índices únicos (UNIQUE)
- FULLTEXT INDEX
- DROP INDEX

### Constraints
- PRIMARY KEY
- FOREIGN KEY
- UNIQUE
- NOT NULL
- DEFAULT
- CHECK
- ON DELETE / ON UPDATE

### Conceitos Adicionais
- DISTINCT (remover duplicatas)
- CASE WHEN (condicionais)
- UNION / UNION ALL (combinar resultados)
- COALESCE, NULLIF (tratamento de NULL)
- EXISTS / NOT EXISTS
- Funções de data (NOW, DATE_FORMAT, DATEDIFF)
- Funções de string (CONCAT, SUBSTRING, REPLACE)
- CTE (Common Table Expressions)
- Window Functions (ROW_NUMBER, RANK)
- Views (visões)
- Transactions (COMMIT, ROLLBACK)
- DDL (CREATE TABLE, ALTER TABLE, DROP TABLE)

## 💡 Dicas

- Sempre use `SELECT` antes de `UPDATE` ou `DELETE` para verificar os dados
- Use comentários para documentar suas queries
- Teste com pequenos conjuntos de dados antes de aplicar em produção
