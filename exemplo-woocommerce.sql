-- ============================================
-- EXEMPLO REAL: WooCommerce
-- Consulta complexa com múltiplos LEFT JOINs
-- ============================================

-- Contexto: Sistema de e-commerce WordPress/WooCommerce
-- Tabelas principais:
-- - wp_woocommerce_order_items: itens do pedido
-- - wp_woocommerce_order_itemmeta: metadados dos itens (qtd, cor, tamanho, etc)

-- ============================================
-- Consulta: Extrair detalhes de um pedido específico
-- ============================================
SELECT 
pedidos.order_item_name produto,
qtd.meta_value qtd,
cor.meta_value cor,
tamanho.meta_value tamanho,
total.meta_value total
FROM wp_wc.wp_woocommerce_order_items pedidos
-- JOIN para quantidade
LEFT JOIN wp_wc.wp_woocommerce_order_itemmeta qtd 
ON pedidos.order_item_id = qtd.order_item_id
AND qtd.meta_key = '_qty'
-- JOIN para cor do produto
LEFT JOIN wp_wc.wp_woocommerce_order_itemmeta cor 
ON pedidos.order_item_id = cor.order_item_id
AND cor.meta_key = 'pa_cor-da-camiseta'
-- JOIN para tamanho
LEFT JOIN wp_wc.wp_woocommerce_order_itemmeta tamanho 
ON pedidos.order_item_id = tamanho.order_item_id
AND tamanho.meta_key = 'pa_tamanho'
-- JOIN para valor total (pode ser _line_total ou cost)
LEFT JOIN wp_wc.wp_woocommerce_order_itemmeta total 
ON pedidos.order_item_id = total.order_item_id
AND (
total.meta_key = '_line_total'
OR total.meta_key = 'cost'
)
WHERE pedidos.order_id = 123;

-- ============================================
-- Explicação da estrutura
-- ============================================
-- 1. Tabela principal: wp_woocommerce_order_items (pedidos)
-- 2. Múltiplos LEFT JOINs na mesma tabela (order_itemmeta)
-- 3. Cada JOIN filtra por meta_key específico:
--    - _qty = quantidade
--    - pa_cor-da-camiseta = cor
--    - pa_tamanho = tamanho
--    - _line_total ou cost = valor total
-- 4. WHERE filtra pelo ID do pedido (123)

-- Este padrão é comum em sistemas WordPress onde
-- metadados são armazenados em tabelas chave-valor
