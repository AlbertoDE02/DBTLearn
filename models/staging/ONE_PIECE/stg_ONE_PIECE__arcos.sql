{{ 
  config(
    materialized = 'incremental',
    unique_key = 'saga'
  ) 
}}

with arcos as (

    select * from {{ source('ONE_PIECE', 'arcos') }}

), arcos_limpios as (

    select
        saga,
        capitulos_manga,
        to_date(inicio_manga, 'DD/MM/YYYY') as inicio_manga,
        to_date(fin_manga, 'DD/MM/YYYY') as fin_manga,
        to_date(inicio_anime, 'DD/MM/YYYY') as inicio_anime,
        to_date(fin_anime, 'DD/MM/YYYY') as fin_anime

    from arcos

)

select
    saga,
    capitulos_manga,
    inicio_manga,
    fin_manga,
    inicio_anime,
    fin_anime
from arcos_limpios

{% if is_incremental() %}
  where saga > (select max(saga) from {{ this }})
{% endif %}
