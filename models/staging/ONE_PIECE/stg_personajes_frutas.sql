{{ config(materialized = 'incremental', unique_key = 'id') }}

with base as (
    select * from {{ ref('base_personajes') }}
),

frutas as (
    select
        id,
        roman_name as nombre_fruta_occidental
    from {{ source('ONE_PIECE', 'frutas') }}
)

select
    b.id,
    b.fruta,
    b.tipo_fruta,
    coalesce(f.nombre_fruta_occidental, 'Sin nombre') as nombre_fruta_occidental
from base b
left join frutas f on b.id = f.id
where b.fruta is not null and upper(b.fruta) != 'SIN FRUTA'

{% if is_incremental() %}
  and b.id > (select max(id) from {{ this }})
{% endif %}
