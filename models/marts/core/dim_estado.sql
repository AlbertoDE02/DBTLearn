{{ config(
    materialized = 'table',
    alias = 'dim_estado'
) }}

with estados_unicos as (

    select distinct
        ESTADO
    from {{ ref('dim_personajes') }}
    where ESTADO is not null

), con_ids as (

    select
        row_number() over (order by ESTADO) as id_estado,
        ESTADO as estado,
        case
            when upper(ESTADO) = 'VIVO' then 'Personaje confirmado como vivo'
            when upper(ESTADO) = 'MUERTO' then 'Personaje confirmado como muerto'
            else 'Estado desconocido o ambiguo'
        end as descripcion_estado

    from estados_unicos

)

select * from con_ids
