{{ config(
    materialized='external',
    location='../data_lake/gold/dim_clientes.parquet'
) }}

SELECT
    MD5(CAST(id_cliente AS VARCHAR)) AS sk_cliente,
    id_cliente,
    nome_cliente,
    email,
    telefone,
    data_cadastro
FROM {{ ref('silver_clientes') }}
