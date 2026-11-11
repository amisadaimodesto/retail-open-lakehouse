

SELECT
    MD5(CAST(id_produto AS VARCHAR)) AS sk_produto,
    id_produto,
    nome_produto,
    categoria,
    preco_unitario,
    custo_unitario,
    ROUND(preco_unitario - custo_unitario, 2) AS margem_unitaria_bruta
FROM "lakehouse"."main"."silver_produtos"