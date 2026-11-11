WITH source AS (
    SELECT * FROM {{ source('bronze', 'produtos') }}
),

renamed AS (
    SELECT
        CAST(id_produto AS INTEGER) AS id_produto,
        TRIM(CAST(nome_produto AS VARCHAR)) AS nome_produto,
        TRIM(CAST(categoria AS VARCHAR)) AS categoria,
        CAST(preco_unitario AS DECIMAL(10, 2)) AS preco_unitario,
        CAST(custo_unitario AS DECIMAL(10, 2)) AS custo_unitario,
        CAST(_ingested_at AS TIMESTAMP) AS _bronze_ingested_at
    FROM source
)

SELECT * FROM renamed
