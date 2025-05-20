select
  id,
  estado,
  case when estado ilike 'alive' then 1 else 0 end as Vivo
from {{ ref('base_personajes') }}