with 

frutas as (

    select * from {{ source('ONE_PIECE', 'frutas') }}

),

frutas_ as (

    select
        id,
        name,
        description,
        roman_name,
        type

    from frutas

)

select * from frutas_
