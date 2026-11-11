{{ config(
    materialized='external',
    location='../data_lake/gold/fato_vendas',
    format='parquet',
    options={'partition_by': '(ano_venda, mes_venda)'}
) }}

WITH silver_vendas AS (
    SELECT * FROM {{ ref('silver_vendas') }}
),

dim_clientes AS (
    SELECT sk_cliente, id_cliente FROM {{ ref('dim_clientes') }}
),

dim_lojas AS (
    SELECT sk_loja, id_loja FROM {{ ref('dim_lojas') }}
),

dim_produtos AS (
    SELECT sk_produto, id_produto, preco_unitario, custo_unitario FROM {{ ref('dim_produtos') }}
)

SELECT
    md5(cast(v.id_venda as varchar)) AS sk_venda,
    v.id_venda,
    c.sk_cliente,
    l.sk_loja,
    p.sk_produto,
    cast(v.data_venda as date) AS data_venda,
    year(cast(v.data_venda as date)) AS ano_venda,
    month(cast(v.data_venda as date)) AS mes_venda,
    v.quantidade,
    round(v.quantidade * p.preco_unitario, 2) AS valor_bruto,
    round((v.quantidade * p.preco_unitario) * v.desconto_percentual, 2) AS desconto,
    round((v.quantidade * p.preco_unitario) * (1 - v.desconto_percentual), 2) AS valor_liquido,
    round(p.custo_unitario * v.quantidade, 2) AS custo_total,
    round(((v.quantidade * p.preco_unitario) * (1 - v.desconto_percentual)) - (p.custo_unitario * v.quantidade), 2) AS lucro_bruto,
    v.status_pagamento,
    current_timestamp AS _processed_at
FROM silver_vendas v
INNER JOIN dim_clientes c ON v.id_cliente = c.id_cliente
INNER JOIN dim_lojas l ON v.id_loja = l.id_loja
INNER JOIN dim_produtos p ON v.id_produto = p.id_produto
