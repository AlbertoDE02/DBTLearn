{{ config(
    materialized = 'table',
    alias = 'dim_fecha'
) }}

with date_spine as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('1900-01-01' as date)",
        end_date="cast('2100-12-31' as date)"
    ) }}
)

select
    date_day as fecha,
    extract(year from date_day) as anio,
    extract(month from date_day) as mes,
    extract(day from date_day) as dia,
    to_char(date_day, 'Day') as nombre_dia,
    to_char(date_day, 'Month') as nombre_mes,
    extract(dayofweek from date_day) as dia_semana,
    extract(week from date_day) as semana_anual,
    extract(quarter from date_day) as trimestre,
    case when extract(dayofweek from date_day) in (1, 7) then true else false end as es_fin_de_semana
from date_spine
