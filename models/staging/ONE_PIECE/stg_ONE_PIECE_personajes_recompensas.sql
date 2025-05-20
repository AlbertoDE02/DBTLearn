{{ config(materialized = 'view') }}

with limpias as (
    select
        id,
        nombre,
        regexp_replace(recompensa, '[^0-9]', '', 'g') as recompensa_limpia_raw,
        try_cast(regexp_replace(recompensa, '[^0-9]', '', 'g') as float) as recompensa_numerica
    from {{ source('ONE_PIECE', 'personajes') }}
    where recompensa is not null
)

select
    id,
    nombre,
    recompensa_numerica,

    case 
        when recompensa_numerica >= 1000000 then
            to_char(round(recompensa_numerica / 1000000, 0), '999G999G999') || ' M'
        when recompensa_numerica >= 1000 then
            to_char(round(recompensa_numerica / 1000, 0), '999G999') || ' K'
        when recompensa_numerica is not null then
            to_char(recompensa_numerica, '999G999')
        else
            'Sin recompensa'
    end as recompensa_formateada,

    case 
        when recompensa_numerica >= 1000000000 then '≥ 1B'
        when recompensa_numerica >= 100000000 then '100M - 1B'
        when recompensa_numerica >= 10000000 then '10M - 100M'
        when recompensa_numerica is not null then '< 10M'
        else 'Desconocida'
    end as rango_recompensa

from limpias
