with
source as (
  select * from {{ source('snowflake_sample', 'customer') }}
),
transformed as (
  select
    c_custkey as customer_id,
    c_name as customer_name,
    c_address as customer_address,
    c_nationkey as customer_nation,
    c_phone as customer_phone,
    c_acctbal as customer_account_balance,
    c_mktsegment as marketing_segment
  from source
)
select * from transformed