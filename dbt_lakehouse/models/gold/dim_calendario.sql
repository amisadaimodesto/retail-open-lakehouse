{{ config(
    materialized='external',
    location='../data_lake/gold/dim_calendario.parquet'
) }}

WITH date_spine AS (
    SELECT 
        CAST('2024-01-01' AS DATE) + CAST(i AS INTEGER) AS data_dia
    FROM range(0, 1095) t(i)
)

SELECT
    CAST(strftime(data_dia, '%Y%m%d') AS INTEGER) AS id_tempo,
    data_dia,
    EXTRACT(YEAR FROM data_dia) AS ano,
    EXTRACT(MONTH FROM data_dia) AS mes,
    strftime(data_dia, '%B') AS nome_mes,
    EXTRACT(DAY FROM data_dia) AS dia,
    EXTRACT(QUARTER FROM data_dia) AS trimestre,
    EXTRACT(DAYOFWEEK FROM data_dia) AS dia_semana,
    CASE WHEN EXTRACT(DAYOFWEEK FROM data_dia) IN (0, 6) THEN TRUE ELSE FALSE END AS flag_fim_de_semana
FROM date_spine
