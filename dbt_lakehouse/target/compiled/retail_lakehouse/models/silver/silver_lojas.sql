WITH source AS (
    SELECT * FROM '../data_lake/bronze/lojas.parquet'
),

renamed AS (
    SELECT
        CAST(id_loja AS INTEGER) AS id_loja,
        TRIM(CAST(nome_loja AS VARCHAR)) AS nome_loja,
        TRIM(CAST(cidade AS VARCHAR)) AS cidade,
        TRIM(CAST(uf AS VARCHAR)) AS uf,
        TRIM(CAST(regiao AS VARCHAR)) AS regiao,
        CAST(data_abertura AS DATE) AS data_abertura,
        CAST(_ingested_at AS TIMESTAMP) AS _bronze_ingested_at
    FROM source
)

SELECT * FROM renamed