create or replace view "lakehouse"."main"."fato_vendas__dbt_int" as (
        select * from '../data_lake/gold/fato_vendas.parquet'
    );