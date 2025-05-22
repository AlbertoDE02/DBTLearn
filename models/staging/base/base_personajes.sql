{{ config(materialized='table') }}

select
    id,
    nombre,
    coalesce(tamano, 'No especificada') as tamano,
    edad,
    cast(null as string) as recompensa,  -- ← este campo lo anulamos totalmente
    estado,
    trabajo,
    coalesce(id_tripulacion, -1) as id_tripulacion,
    nombre_tripulacion,
    coalesce(fruto, 'Sin fruta') as fruta,
    coalesce(tipo_fruto, 'Desconocido') as tipo_fruta,
    fruto_romanizado as nombre_fruta_occidental
from {{ source('ONE_PIECE', 'personajes') }}

{% if is_incremental() %}
  where id > (select max(id) from {{ this }})
{% endif %}
