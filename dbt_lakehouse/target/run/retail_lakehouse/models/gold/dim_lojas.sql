create or replace view "lakehouse"."main"."dim_lojas__dbt_int" as (
        select * from '../data_lake/gold/dim_lojas.parquet'
    );