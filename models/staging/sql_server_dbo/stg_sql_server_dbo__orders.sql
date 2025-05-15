with 

orders_src as (
    select * from {{ source('sql_server_dbo', 'orders') }}
),

casted_orders as (
    select
        {{ dbt_utils.generate_surrogate_key(["order_id"]) }} as order_id,
         COALESCE(NULLIF(shipping_service, ''), 'No disponible') as shipping_service,
        shipping_cost,
        {{ dbt_utils.generate_surrogate_key(["address_id"]) }} as address_id,
        convert_timezone('Europe/Madrid', 'UTC', CAST(created_at AS TIMESTAMP_NTZ)) as created_at,
        {{ dbt_utils.generate_surrogate_key(["promo_id"]) }} as promo_id,
        convert_timezone('Europe/Madrid', 'UTC', CAST(estimated_delivery_at AS TIMESTAMP_NTZ)) as estimated_delivery_at,
        order_cost,
        {{ dbt_utils.generate_surrogate_key(["user_id"]) }} as user_id,
        order_total,
        convert_timezone('Europe/Madrid', 'UTC', CAST(delivered_at AS TIMESTAMP_NTZ)) as delivered_at,
        status,
        COALESCE(_fivetran_deleted, FALSE) as _fivetran_deleted,
        convert_timezone('Europe/Madrid', 'UTC', CAST(_fivetran_synced AS TIMESTAMP_NTZ)) as _fiventran_synced
    from orders_src
)

select * from casted_orders
