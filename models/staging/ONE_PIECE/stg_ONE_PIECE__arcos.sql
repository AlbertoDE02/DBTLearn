with 

arcos as (

    select * from {{ source('ONE_PIECE', 'arcos') }}

),

arcos_ as (

    SELECT
        saga,
        capitulos_manga,
        TO_DATE(inicio_manga, 'DD/MM/YYYY') AS Inicio_Manga,
        TO_DATE(fin_manga, 'DD/MM/YYYY') AS Fin_Manga,
        TO_DATE(inicio_anime, 'DD/MM/YYYY') AS Inicio_Anime,
        TO_DATE(fin_anime, 'DD/MM/YYYY') AS Fin_Anime
FROM arcos
)

select * from arcos_
