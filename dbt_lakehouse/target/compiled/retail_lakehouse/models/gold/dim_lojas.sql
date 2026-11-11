

SELECT
    MD5(CAST(id_loja AS VARCHAR)) AS sk_loja,
    id_loja,
    nome_loja,
    cidade,
    uf,
    regiao,
    data_abertura
FROM "lakehouse"."main"."silver_lojas"