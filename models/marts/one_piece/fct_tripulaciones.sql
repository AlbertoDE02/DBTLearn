{{ config(
    materialized = 'table',
    alias = 'mart_metricas_tripulaciones'
) }}

with personajes as (
    select
        nombre_tripulacion,
        lower(trim(estado)) as estado,

        lower(trim(
            case 
                when tipo_fruta is null or trim(tipo_fruta) = '' then 'no tiene'
                else tipo_fruta
            end
        )) as tipo_fruta,

        case 
            when recompensa != 'No especificada' 
            then cast(replace(recompensa, '.', '') as numeric)
        end as recompensa

    from {{ ref('fct_personajes') }}
    where nombre_tripulacion is not null
),

conteo_estados as (
    select
        nombre_tripulacion,
        count(*) as total_personajes,
        count(case when estado = 'alive' then 1 end) as vivos,
        count(case when estado = 'dead' then 1 end) as muertos,
        round(avg(recompensa), 2) as recompensa_promedio,
        max(recompensa) as recompensa_maxima,
        count(case when tipo_fruta != 'no tiene' then 1 end) as personajes_con_fruta,

        round(
            100.0 * count(case when tipo_fruta != 'no tiene' then 1 end)
            / nullif(count(case when tipo_fruta is not null then 1 end), 0),
        2) as porcentaje_con_fruta,

        round(
            100.0 * count(case 
                when tipo_fruta = 'no tiene' and recompensa is not null and recompensa > 0 then 1 
            end)
            / nullif(count(case when tipo_fruta = 'no tiene' then 1 end), 0),
            2) as porcentaje_sin_fruta_con_recompensa

    from personajes
    group by nombre_tripulacion
)

select
    nombre_tripulacion,
    total_personajes,
    vivos - muertos as tripulantes_vivos,
    coalesce(recompensa_promedio, 0) as recompensa_promedio,
    coalesce(recompensa_maxima, 0) as recompensa_maxima,
    personajes_con_fruta,
    porcentaje_con_fruta || '%',
    porcentaje_sin_fruta_con_recompensa || '%'
from conteo_estados
order by tripulantes_vivos desc
