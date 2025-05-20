{{ config(materialized = 'incremental', unique_key=['nombre', 'saga']) }}

with personajes_sagas as (
    select * from {{ ref('int_ONE_PIECE_personajes_sagas') }}
),

personajes_base as (
    select
        id,
        nombre,
        nombre_tripulacion,
        estado
    from {{ ref('base_personajes') }}
),

recompensas as (
    select id, rango_recompensa
    from {{ ref('stg_ONE_PIECE_personajes_recompensas') }}
),

estado as (
    select id, vivo
    from {{ ref('stg_ONE_PIECE_estado') }}
),

frutas as (
    select id, fruta, tipo_fruta, nombre_fruta_occidental
    from {{ ref('stg_ONE_PIECE_personajes_frutas') }}
)

select
  ps.nombre,
  ps.saga,
  bp.nombre_tripulacion,
  coalesce(r.rango_recompensa, 'Sin recompensa') as rango_recompensa,
  --bp.estado,
  coalesce(e.vivo, 0) as vivo,
  coalesce(f.fruta, 'Sin fruta') as fruta,
  coalesce(f.tipo_fruta, 'Sin tipo') as tipo_fruta,
  coalesce(f.nombre_fruta_occidental, 'Sin nombre') as nombre_fruta_occidental,
  ps.capitulos_manga,
  ps.fecha_inicio_manga,
  ps.fecha_fin_manga,
  ps.fecha_inicio_anime,
  ps.fecha_fin_anime

from personajes_sagas ps
left join personajes_base bp on ps.nombre = bp.nombre
left join recompensas r on bp.id = r.id
left join estado e on bp.id = e.id
left join frutas f on bp.id = f.id

{% if is_incremental() %}
  where concat(ps.nombre, '_', ps.saga) not in (
    select concat(nombre, '_', saga) from {{ this }}
  )
{% endif %}
