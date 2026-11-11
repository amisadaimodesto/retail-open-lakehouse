select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

with all_values as (

    select
        status_pagamento as value_field,
        count(*) as n_records

    from "lakehouse"."main"."silver_vendas"
    group by status_pagamento

)

select *
from all_values
where value_field not in (
    'APROVADO','CANCELADO'
)



      
    ) dbt_internal_test