{{ config(
    materialized = 'table',
    alias = 'dim_sagas'
) }}

with raw as (

    select * from {{ source('ONE_PIECE', 'arcos') }}

), transformado as (

    select
        SAGA as nombre_saga,
        CAPITULOS_MANGA as capitulos_manga,
        to_date(INICIO_MANGA, 'DD/MM/YYYY') as inicio_manga,
        to_date(FIN_MANGA, 'DD/MM/YYYY') as fin_manga,
        EPISODIOS_ANIME as episodios_anime,
        to_date(INICIO_ANIME, 'DD/MM/YYYY') as inicio_anime,
        to_date(FIN_ANIME, 'DD/MM/YYYY') as fin_anime
    from raw

)

select * from transformado
