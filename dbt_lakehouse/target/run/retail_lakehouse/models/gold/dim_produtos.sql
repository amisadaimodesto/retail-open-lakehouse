create or replace view "lakehouse"."main"."dim_produtos__dbt_int" as (
        select * from '../data_lake/gold/dim_produtos.parquet'
    );