
    
    

select
    sk_venda as unique_field,
    count(*) as n_records

from "lakehouse"."main"."fato_vendas"
where sk_venda is not null
group by sk_venda
having count(*) > 1


