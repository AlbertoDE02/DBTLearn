{{ config(materialized = 'view') }}

select
  id,
  nombre,
  estado
from {{ ref('base_personajes') }}
where FRUTA = 'Sin fruta'
