create or replace view "lakehouse"."main"."dm_vendas_mensal_categoria__dbt_int" as (
        select * from '../data_lake/gold/dm_vendas_mensal_categoria.parquet'
    );