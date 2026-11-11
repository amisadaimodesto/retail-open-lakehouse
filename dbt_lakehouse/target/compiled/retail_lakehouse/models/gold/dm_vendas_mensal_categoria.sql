

SELECT
    c.ano,
    c.mes,
    c.nome_mes,
    p.categoria,
    COUNT(f.sk_venda) AS total_pedidos,
    SUM(f.quantidade) AS total_itens_vendidos,
    ROUND(SUM(f.valor_bruto), 2) AS receita_bruta_total,
    ROUND(SUM(f.valor_liquido), 2) AS receita_liquida_total,
    ROUND(SUM(f.lucro_bruto), 2) AS lucro_bruto_total,
    ROUND(AVG(f.valor_liquido), 2) AS ticket_medio
FROM "lakehouse"."main"."fato_vendas" f
JOIN "lakehouse"."main"."dim_calendario" c ON f.id_tempo = c.id_tempo
JOIN "lakehouse"."main"."dim_produtos" p ON f.sk_produto = p.sk_produto
WHERE f.status_pagamento = 'APROVADO'
GROUP BY 1, 2, 3, 4