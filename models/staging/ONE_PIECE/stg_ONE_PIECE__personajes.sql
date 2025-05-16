with 

personajes as (

    select * from {{ source('ONE_PIECE', 'personajes') }}

),

personajes_ as (

    select
        id,
        nombre,
        tamano,
        edad,
        recompensa,
        trabajo,
        estado,
        nombre_tripulacion,
        id_tripulacion,
        fruto,
        tipo_fruto,
        fruto_romanizado

    from personajes

)

select * from personajes_
