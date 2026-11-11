create or replace view "lakehouse"."main"."dim_calendario__dbt_int" as (
        select * from '../data_lake/gold/dim_calendario.parquet'
    );