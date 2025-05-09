with 

users_src as (

    select * from {{ source('sql_server_dbo', 'users') }}

),

casted_users as (

    select
        {{ dbt_utils.generate_surrogate_key(["user_id"]) }} as user_id_hash,
        convert_timezone('Europe/Madrid', 'UTC', CAST(updated_at AS TIMESTAMP_NTZ)) as updated_at,
        {{ dbt_utils.generate_surrogate_key(["address_id"]) }} as address_id_hash,
        last_name,
        convert_timezone('Europe/Madrid', 'UTC', CAST(created_at AS TIMESTAMP_NTZ)) as created_at,
           CASE 
            WHEN phone_number RLIKE '^\d{9}$' THEN 'Válido'
            ELSE 'Inválido'
        END AS phone_number_valid,
        first_name,
            CASE 
            WHEN email RLIKE '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' THEN 'Válido'
            ELSE 'Inválido'
        END AS email,
        convert_timezone('Europe/Madrid', 'UTC', CAST(_fivetran_synced AS TIMESTAMP_NTZ)) as _fivetran_synced,
        COALESCE(_fivetran_deleted, FALSE) as _fivetran_deleted
    from users_src

)

select * from casted_users
