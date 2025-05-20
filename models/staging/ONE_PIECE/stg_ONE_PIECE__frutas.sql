{{ 
  config(
    materialized = 'incremental',
    unique_key = 'id'
  ) 
}}

with frutas as (

    select * from {{ source('ONE_PIECE', 'frutas') }}

), frutas_limpias as (

    select
        id,
        name as fruta,
        coalesce(type, 'Desconocido') as tipo_fruta,
        description as descripcion,
        roman_name as nombre_fruta_occidental
    from frutas

)

select
    id,
    fruta,
    tipo_fruta,
    descripcion,
    nombre_fruta_occidental
from frutas_limpias

{% if is_incremental() %}
  where id > (select max(id) from {{ this }})
{% endif %}
