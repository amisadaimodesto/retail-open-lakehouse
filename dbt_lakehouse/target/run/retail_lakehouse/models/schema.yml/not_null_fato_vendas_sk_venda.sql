select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select sk_venda
from "lakehouse"."main"."fato_vendas"
where sk_venda is null



      
    ) dbt_internal_test