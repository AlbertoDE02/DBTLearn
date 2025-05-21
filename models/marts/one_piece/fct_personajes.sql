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
        a.SAGA as nombre_saga,
        a.FECHA_APARICION_ESTIMADA as fecha_aparicion_estimada,
        p.edad,
        coalesce(p.recompensa, 'No especificada') as recompensa,

    from {{ ref('dim_personajes') }} p
    left join {{ ref('dim_tripulaciones') }} t 
        on p.id_tripulacion = t.id_tripulacion
    left join {{ ref('dim_frutas') }} f 
        on p.nombre_fruta = f.nombre_fruta
    left join {{ ref('dim_estado') }} e 
        on p.estado = e.estado
    left join (
        select NOMBRE, SAGA, FECHA_APARICION_ESTIMADA
        from {{ ref('int_personajes_aparicion') }}
    ) a 
        on p.nombre_personaje = a.NOMBRE

)

select * from base
