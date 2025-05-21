{{ config(
    materialized = 'table',
    alias = 'dim_personajes'
) }}

with raw as (

    select * from {{ source('ONE_PIECE', 'personajes') }}

), limpiado as (

    select
        ID as id_personaje,
        NOMBRE as nombre_personaje,
        coalesce(trim(TAMANO), 'No especificada') as tamano,
        EDAD as edad,
        RECOMPENSA as recompensa,
        TRABAJO as puesto,
        ESTADO as estado,
        NOMBRE_TRIPULACION as nombre_tripulacion,
        ID_TRIPULACION as id_tripulacion,
        FRUTO as nombre_fruta,
        TIPO_FRUTO as tipo_fruta,
        FRUTO_ROMANIZADO as fruto_romanizado

    from raw

)

select * from limpiado
