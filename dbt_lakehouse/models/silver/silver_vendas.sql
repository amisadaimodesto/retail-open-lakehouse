WITH source AS (
    SELECT * FROM {{ source('bronze', 'vendas') }}
),

ranked AS (
    SELECT
        CAST(id_venda AS INTEGER) AS id_venda,
        CAST(id_cliente AS INTEGER) AS id_cliente,
        CAST(id_loja AS INTEGER) AS id_loja,
        CAST(id_produto AS INTEGER) AS id_produto,
        CAST(quantidade AS INTEGER) AS quantidade,
        CAST(desconto_percentual AS DECIMAL(5, 2)) AS desconto_percentual,
        UPPER(TRIM(CAST(status_pagamento AS VARCHAR))) AS status_pagamento,
        CAST(data_venda AS TIMESTAMP) AS data_venda,
        CAST(_ingested_at AS TIMESTAMP) AS _bronze_ingested_at,
        ROW_NUMBER() OVER (
            PARTITION BY id_venda 
            ORDER BY _ingested_at DESC
        ) AS rn
    FROM source
)

SELECT
    id_venda,
    id_cliente,
    id_loja,
    id_produto,
    quantidade,
    desconto_percentual,
    status_pagamento,
    data_venda,
    _bronze_ingested_at
FROM ranked
WHERE rn = 1
