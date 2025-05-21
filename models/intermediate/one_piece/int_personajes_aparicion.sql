{{ config(
    materialized = 'table',
    alias = 'int_personajes_aparicion'
) }}

with base as (
    select
        nombre,
        saga,
        fecha_inicio_manga,
        fecha_inicio_anime,
        coalesce(fecha_inicio_manga, fecha_inicio_anime) as fecha_aparicion_estimada
    from {{ ref('int_ONE_PIECE_personajes_sagas') }}
)

select * from base
