

WITH vendas AS (
    SELECT * FROM "lakehouse"."main"."silver_vendas"
),
produtos AS (
    SELECT * FROM "lakehouse"."main"."silver_produtos"
)

SELECT
    MD5(CAST(v.id_venda AS VARCHAR)) AS sk_venda,
    MD5(CAST(v.id_cliente AS VARCHAR)) AS sk_cliente,
    MD5(CAST(v.id_loja AS VARCHAR)) AS sk_loja,
    MD5(CAST(v.id_produto AS VARCHAR)) AS sk_produto,
    CAST(strftime(v.data_venda, '%Y%m%d') AS INTEGER) AS id_tempo,
    v.id_venda,
    v.data_venda,
    v.status_pagamento,
    v.quantidade,
    p.preco_unitario,
    p.custo_unitario,
    v.desconto_percentual,
    ROUND(v.quantidade * p.preco_unitario, 2) AS valor_bruto,
    ROUND(v.quantidade * p.preco_unitario * v.desconto_percentual, 2) AS valor_desconto,
    ROUND((v.quantidade * p.preco_unitario) * (1 - v.desconto_percentual), 2) AS valor_liquido,
    ROUND(v.quantidade * p.custo_unitario, 2) AS custo_total,
    ROUND(((v.quantidade * p.preco_unitario) * (1 - v.desconto_percentual)) - (v.quantidade * p.custo_unitario), 2) AS lucro_bruto
FROM vendas v
LEFT JOIN produtos p ON v.id_produto = p.id_produto