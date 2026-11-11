select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select sk_loja
from "lakehouse"."main"."dim_lojas"
where sk_loja is null



      
    ) dbt_internal_test