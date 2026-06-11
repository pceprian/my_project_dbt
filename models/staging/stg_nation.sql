with
source as (
  select * from {{ source('snowflake_sample', 'nation') }}
),
transformed as (
  select
    n_nationkey as nation_id,
    n_name as nation_name,
    n_regionkey as region_id,
    cast({{ dbt.current_timestamp() }} as {{ dbt.type_timestamp() }}) as loaded_at
  from source
)
select * from transformed