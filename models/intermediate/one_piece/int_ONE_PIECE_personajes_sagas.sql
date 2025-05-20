{{ config(materialized = 'incremental', unique_key=['nombre', 'saga']) }}

select
  sp.nombre,
  sp.saga,
  a.capitulos_manga,
  a.inicio_manga as fecha_inicio_manga,
  a.fin_manga as fecha_fin_manga,
  a.inicio_anime as fecha_inicio_anime,
  a.fin_anime as fecha_fin_anime
from {{ ref('stg_ONE_PIECE_sagas_personajes') }} sp
left join {{ ref('stg_ONE_PIECE__arcos') }} a
  on lower(trim(sp.saga)) = lower(trim(a.saga))

{% if is_incremental() %}
  where concat(sp.nombre, '_', sp.saga) not in (
    select concat(nombre, '_', saga) from {{ this }}
  )
{% endif %}
