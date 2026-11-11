select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select sk_cliente
from "lakehouse"."main"."dim_clientes"
where sk_cliente is null



      
    ) dbt_internal_test