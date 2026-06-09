with
source as (
  select * from {{ source('snowflake_sample', 'part') }}
),
transformed as (
  select
    p_partkey as part_id,
    p_name as part_name,
    p_mfgr as part_manufacturer,
    p_brand as part_brand,
    p_type as part_type,
    p_size as part_size,
    {{ size_parts('p_size') }} as part_size_group,
    p_container as part_container,
    p_retailprice as part_retail_price,
    {{ dbt_utils.current_timestamp() }} as loaded_at
  from source
)
select * from transformed