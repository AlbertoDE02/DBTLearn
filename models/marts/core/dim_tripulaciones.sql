{{ config(
    materialized = 'table',
    alias = 'dim_tripulaciones'
) }}

with raw as (

    select distinct
        ID_TRIPULACION,
        NOMBRE_TRIPULACION
    from {{ ref('dim_personajes') }}
    where ID_TRIPULACION is not null

)

select
    ID_TRIPULACION as id_tripulacion,
    NOMBRE_TRIPULACION as nombre_tripulacion
from raw
