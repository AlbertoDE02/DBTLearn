{{ config(materialized = 'incremental', unique_key = 'ID_TRIPULACION') }}

with base as (
  select * from {{ ref('base_personajes') }}
)

select distinct
  ID_TRIPULACION,
  NOMBRE_TRIPULACION as NOMBRE
from base

{% if is_incremental() %}
  where ID_TRIPULACION > (select max(ID_TRIPULACION) from {{ this }})
{% endif %}
