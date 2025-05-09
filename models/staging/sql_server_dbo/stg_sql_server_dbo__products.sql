with 

src_products as (
    select * from {{ source('sql_server_dbo', 'products') }}
),

converted_products as (
    select
       {{ dbt_utils.generate_surrogate_key(["product_id"]) }} AS product_id_hash,
        name,
        inventory,
        _fivetran_deleted,
        _fivetran_synced
    from src_products
)

select * from converted_products
