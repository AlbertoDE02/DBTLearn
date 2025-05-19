with 

personajes as (

    select * from {{ source('ONE_PIECE', 'personajes') }}

),

personajes_ as (
    select
        id,
        nombre,
        tamano AS Altura,
        edad,
        recompensa,
        trabajo AS Puesto,
        estado,
        nombre_tripulacion as Tripulacion,
        id_tripulacion,
        fruto as Fruta,
        tipo_fruto,
        fruto_romanizado AS Nombre_Fruta_Occidental
    from personajes

)

select * from personajes_
