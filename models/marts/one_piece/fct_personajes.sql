{{ config(
    materialized = 'table',
    alias = 'fct_personajes'
) }}

with base as (

    select
        p.nombre_personaje,
        t.nombre_tripulacion,
        coalesce(p.nombre_fruta, 'No Tiene') as nombre_fruta,
        coalesce(p.tipo_fruta, 'No Tiene') as tipo_fruta,
        p.estado,
        p.edad,
        coalesce(p.recompensa, 'No especificada') as recompensa

    from {{ ref('dim_personajes') }} p
    left join {{ ref('dim_tripulaciones') }} t 
        on p.id_tripulacion = t.id_tripulacion
    left join {{ ref('dim_frutas') }} f 
        on p.nombre_fruta = f.nombre_fruta
    left join {{ ref('dim_estado') }} e 
        on p.estado = e.estado
)

select * from base
