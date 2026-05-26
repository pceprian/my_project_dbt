with
source as (
  select * from {{ source('snowflake_sample', 'supplier') }}
),
transformed as (
  select
    s_suppkey as supplier_id,
    s_name as supplier_name,
    s_address as supplier_address,
    s_nationkey as supplier_nation_id,
    s_phone as supplier_phone,
    s_acctbal as supplier_account_balance,
    {{ insert_timestamp() }} AS loaded_at
  from source
)
select * from transformed