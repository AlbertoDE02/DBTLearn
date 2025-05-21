{{ config(
    materialized = 'table',
    alias = 'dim_frutas'
) }}

with raw as (

    select * from {{ source('ONE_PIECE', 'frutas') }}

), limpiado as (

    select
        id as id_fruta,
        name as nombre_fruta,
        description as descripcion,
        roman_name as fruto_romanizado,
        type as tipo_fruta
    from raw

)

select * from limpiado
