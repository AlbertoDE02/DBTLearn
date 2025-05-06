{{
  config(
    materialized='view'
  )
}}

WITH src_budget AS (
    SELECT * 
    FROM {{ source('google_sheets', 'budget') }}
    ),

renamed_casted AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['month','product_id']) }}
        ,  product_id
        ,  quantity
        ,  month
        , _fivetran_synced AS date_load
    FROM src_budget
    )

SELECT * FROM renamed_casted