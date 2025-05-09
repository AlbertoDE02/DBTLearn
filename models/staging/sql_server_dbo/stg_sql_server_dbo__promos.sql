{{ config(materialized="view") }}


WITH src_promos AS (
    SELECT * 
    FROM {{ source("sql_server_dbo", "promos") }}
    UNION ALL
    SELECT
        'no promo' AS promo_id,
        0 AS discount,
        'active' AS status,
        NULL AS _fivetran_deleted,
        sysdate() AS _fivetran_synced
    ),
    id_promo_hash AS (
        SELECT
            {{ dbt_utils.generate_surrogate_key(["promo_id"]) }} AS promo_id,
            promo_id AS promo_desc,
            discount,
            status,
            convert_timezone('Europe/Madrid', 'UTC', CAST(_fivetran_synced AS TIMESTAMP_NTZ)) as _fiventran_synced,
            COALESCE(_fivetran_deleted, FALSE) as _fivetran_deleted
        FROM src_promos
    )
SELECT *
FROM id_promo_hash
