{{ config(materialized = 'table') }}

select
  trim("PERSONAJES") as nombre,
  trim("SAGAS") as saga
from {{ source('ONE_PIECE', 'personajes_arcos') }}
where "SAGAS" is not null
