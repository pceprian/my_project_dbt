with
source as (
  select * from {{ source('snowflake_sample', 'region') }}
),
transformed as (
  select
    r_regionkey as region_id,
    r_name as region_name,
    {{ dbt_utils.current_timestamp() }} as loaded_at
  from source
)
select * from transformed