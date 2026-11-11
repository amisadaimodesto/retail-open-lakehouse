create or replace view "lakehouse"."main"."dim_clientes__dbt_int" as (
        select * from '../data_lake/gold/dim_clientes.parquet'
    );