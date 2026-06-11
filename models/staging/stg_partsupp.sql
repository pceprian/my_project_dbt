with
source as (
  select * from {{ source('snowflake_sample', 'partsupp') }}
),
transformed as (
  select
    {{ dbt_utils.generate_surrogate_key(['ps_partkey', 'ps_suppkey']) }} as part_supplier_id,
    ps_partkey as part_id,
    ps_suppkey as supplier_id,
    ps_availqty as part_supplier_available_quantity,
    ps_supplycost,
    (coalesce(part_supplier_available_quantity, 0) * coalesce(ps_supplycost, 0)) as total_inventory_valuation,
    cast({{ dbt.current_timestamp() }} as {{ dbt.type_timestamp() }}) as loaded_at
  from source
)
select * from transformed