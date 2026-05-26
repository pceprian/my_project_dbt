with
source as (
  select * from {{ source('snowflake_sample', 'partsupp') }}
),
transformed as (
  select
    concat(ps_partkey, '-', ps_suppkey) as part_supplier_id,
    ps_partkey as part_id,
    ps_suppkey as supplier_id,
    ps_availqty as part_supplier_available_quantity,
    ps_supplycost as supplier_cost,
    {{ insert_timestamp() }} AS loaded_at
  from source
)
select * from transformed