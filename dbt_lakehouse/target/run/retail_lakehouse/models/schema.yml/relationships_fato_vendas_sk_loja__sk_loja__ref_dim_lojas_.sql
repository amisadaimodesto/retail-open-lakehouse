select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

with child as (
    select sk_loja as from_field
    from "lakehouse"."main"."fato_vendas"
    where sk_loja is not null
),

parent as (
    select sk_loja as to_field
    from "lakehouse"."main"."dim_lojas"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null



      
    ) dbt_internal_test