
    
    

select
    id_tempo as unique_field,
    count(*) as n_records

from "lakehouse"."main"."dim_calendario"
where id_tempo is not null
group by id_tempo
having count(*) > 1


