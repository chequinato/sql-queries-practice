# P2 de Banco de Dados: SQL

Material de estudo para a P2, feito a partir dos arquivos que o professor publicou da P1 em diante (aulas 07 a 15). Todos os comandos são de **SQL Server (T-SQL)**, o mesmo banco usado nas aulas.

Cada arquivo segue o mesmo formato:

1. **Resumo**: explicação curta do assunto, com o que costuma cair na prova.
2. **Exemplos**: comandos comentados que rodam na base de treino.
3. **Exercícios**: para você escrever a resposta embaixo de cada um.
4. **Respostas**: no fim do arquivo, dentro de um comentário. Só desça até lá depois de tentar.

## Como usar

1. Abra o SQL Server Management Studio (SSMS).
2. Abra e rode o arquivo `p2-00-base-livraria.sql` (F5). Ele cria o banco `P2_LIVRARIA` com dados prontos.
3. Siga os arquivos na ordem. Rode um exemplo por vez: selecione o bloco e aperte F5.
4. Se bagunçar os dados treinando, rode o `00` de novo e tudo volta ao começo.

## O que cai e onde está

| Arquivo | Assunto | Aulas do professor |
|---|---|---|
| `p2-00-base-livraria.sql` | Cria o banco de treino (livraria) | — |
| `p2-01-ddl-create-alter-drop.sql` | Divisão do SQL (DDL, DML, DQL, DCL), `CREATE TABLE`, tipos, PK, FK, `CHECK`, `DEFAULT`, `IDENTITY`, `ALTER TABLE`, `DROP TABLE` | 07 A, 08, 09 |
| `p2-02-dml-insert-update-delete.sql` | `INSERT` (uma linha, várias linhas, sem algumas colunas), `UPDATE`, `DELETE`, `TRUNCATE`, `BEGIN TRAN` / `COMMIT` / `ROLLBACK`, erro de FK | 07 B, 08, 09 |
| `p2-03-select-basico.sql` | `SELECT`, `WHERE`, `AND` / `OR`, `BETWEEN`, `LIKE`, `IN`, `IS NULL`, `ORDER BY`, contas com apelido, `DISTINCT`, `TOP` | 10 |
| `p2-04-juncoes-join.sql` | Junção na sintaxe antiga e nova, `INNER` / `LEFT` / `RIGHT` / `CROSS JOIN`, produto cartesiano, autojunção, "quem não tem" | 10, 11 |
| `p2-05-agrupamento-group-by.sql` | `COUNT`, `SUM`, `AVG`, `MAX`, `MIN`, `GROUP BY`, `HAVING`, `ISNULL`, `ROLLUP`, `CASE` | 10, 13, 14 |
| `p2-06-subselect-e-ranking.sql` | Subselect com `=`, `IN`, `NOT IN`, `EXISTS`, correlacionado, `ANY` / `ALL`, `TOP`, `ROW_NUMBER`, `RANK`, `DENSE_RANK`, `PARTITION BY` | 14 |
| `p2-07-views.sql` | `CREATE` / `ALTER` / `DROP VIEW`, para que serve, tipos de view, regras (sem `ORDER BY`) | 15 C |
| `p2-08-procedures-e-tsql.sql` | `CREATE PROCEDURE` com e sem parâmetro, valor padrão, `EXEC`, `ALTER` / `DROP PROCEDURE`, função, `CASE` | 14, 15 B, 15 D |
| `p2-09-simulado-p2.sql` | Simulado com tudo misturado | todas |

## A base de treino

Uma livraria com cidades, departamentos, funcionários (cada um com um chefe), clientes, livros por categoria, pedidos e itens de pedido. Alguns dados foram colocados de propósito para os exercícios, por exemplo um departamento sem funcionário e um cliente que nunca comprou. A lista completa está no começo do `p2-00-base-livraria.sql`.

## Diferenças entre SQL Server e Oracle que aparecem no material

O professor mostrou as duas sintaxes nas aulas de junção. Na prova, preste atenção em qual banco a questão pede:

| | SQL Server | Oracle |
|---|---|---|
| Juntar texto | `NOME + ' ' + SOBRENOME` | `NOME \|\| ' ' \|\| SOBRENOME` |
| Junção externa na sintaxe antiga | não existe mais, use `LEFT JOIN` | `WHERE E.COD(+) = D.COD` |
| `NATURAL JOIN` | não existe | existe |
