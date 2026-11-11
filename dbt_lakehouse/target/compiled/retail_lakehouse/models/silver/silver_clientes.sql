WITH source AS (
    SELECT * FROM '../data_lake/bronze/clientes.parquet'
),

renamed AS (
    SELECT
        CAST(id_cliente AS INTEGER) AS id_cliente,
        TRIM(CAST(nome_cliente AS VARCHAR)) AS nome_cliente,
        LOWER(TRIM(CAST(email AS VARCHAR))) AS email,
        TRIM(CAST(telefone AS VARCHAR)) AS telefone,
        CAST(data_cadastro AS DATE) AS data_cadastro,
        CAST(_ingested_at AS TIMESTAMP) AS _bronze_ingested_at
    FROM source
)

SELECT * FROM renamed