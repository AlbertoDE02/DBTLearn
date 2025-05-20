{{ config(materialized = 'view') }}

with recompensas_limpias as (
    select
        id,
        nombre,
        recompensa,
        
        case 
            when regexp_like(recompensa, '^[0-9,. ]+$') then 
                try_cast(replace(replace(recompensa, ',', ''), '.', '') as float)
            else null
        end as recompensa_numerica
    from {{ source('ONE_PIECE', 'personajes') }}
    where recompensa is not null
)

select
    id,
    nombre,
    recompensa_numerica,

    case 
        when recompensa_numerica >= 1000000000 then '≥ 1B'
        when recompensa_numerica >= 100000000 then '100M - 1B'
        when recompensa_numerica >= 10000000 then '10M - 100M'
        when recompensa_numerica is not null then '< 10M'
        else 'Desconocida'
    end as rango_recompensa
from recompensas_limpias
