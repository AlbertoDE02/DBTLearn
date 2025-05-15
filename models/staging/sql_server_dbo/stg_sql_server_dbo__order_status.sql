with
    status_src as (select * from {{ source("sql_server_dbo", "orders") }}),
    casted_status as (
        select
        {{ dbt_utils.generate_surrogate_key(["status"]) }} as status_id, 
        from status_src
    )

select *
from casted_status
