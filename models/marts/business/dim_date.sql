with date_dimension as (
    select * from {{ ref('stg_date') }}
),

full_date as (
    {{ dbt_date.get_base_dates(start_date="1992-01-01", end_date="1998-12-31") }}
),

full_date_tr as (
select d.*,
    f.date_day as fulldate,
    {{ dbt_date.convert_timezone("f.date_day", "America/New York", "UTC") }} as dulldatez,
    {{ dbt_date.convert_timezone("f.date_day", "America/New York", source_tz="UTC") }} as dulldatezt,
    {{ dbt_date.convert_timezone("f.date_day", "America/New York") }} as test,
    f.date_day::timestamp "direct_dts",
    f.date_day::timestamp AT TIME ZONE 'UTC' as "ts_utc"
from
    date_dimension date_day
    left join fulldate f on d.date_day = cast(f.date_day as date)    
)
select {{ dbt_utils.generate_surrogate_key(['direct_dts']) }} as date_key,
    *
from full_date_tr