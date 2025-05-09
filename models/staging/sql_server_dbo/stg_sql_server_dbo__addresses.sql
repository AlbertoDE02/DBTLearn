with

    addresses_src as (select * from {{ source("sql_server_dbo", "addresses") }}),

    converted_address as (
        select
            {{ dbt_utils.generate_surrogate_key(["address_id"]) }} as address_id_hash,
            LPAD (CAST(zipcode AS STRING),5,'0')AS zipcode,
            country,
            address,
            state,
            _fivetran_deleted,
            _fivetran_synced
        from addresses_src
    )

select *
from converted_address
