{{ config(
    materialized='external',
    location='../data_lake/gold/dm_vendas_mensal_categoria.parquet',
    format='parquet'
) }}

WITH fato_vendas AS (
    SELECT * FROM {{ ref('fato_vendas') }}
),

dim_produtos AS (
    SELECT * FROM {{ ref('dim_produtos') }}
)

SELECT
    f.ano_venda AS ano,
    f.mes_venda AS mes,
    p.categoria,
    COUNT(f.sk_venda) AS total_pedidos,
    SUM(f.quantidade) AS total_itens_vendidos,
    ROUND(SUM(f.valor_bruto), 2) AS receita_bruta_total,
    ROUND(SUM(f.valor_liquido), 2) AS receita_liquida_total,
    ROUND(SUM(f.lucro_bruto), 2) AS lucro_bruto_total,
    ROUND(AVG(f.valor_liquido), 2) AS ticket_medio
FROM fato_vendas f
JOIN dim_produtos p ON f.sk_produto = p.sk_produto
WHERE f.status_pagamento = 'APROVADO'
GROUP BY 
    f.ano_venda,
    f.mes_venda,
    p.categoria
ORDER BY 
    ano, 
    mes, 
    receita_liquida_total DESC
