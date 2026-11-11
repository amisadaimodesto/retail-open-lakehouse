
    
    

select
    sk_loja as unique_field,
    count(*) as n_records

from "lakehouse"."main"."dim_lojas"
where sk_loja is not null
group by sk_loja
having count(*) > 1


