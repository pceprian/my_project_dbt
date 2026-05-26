with
source as (
  select * from {{ source('snowflake_sample', 'orders') }}
),
transformed as (
  select
    o_orderkey as order_id,
    o_custkey as customer_id,
    o_orderstatus as order_status,
    o_totalprice as order_total_price,
    {{ replace_null('cast(o_orderdate as date)', 'No Date') }} as order_date,
    o_orderpriority as order_priority, 
    o_clerk as order_clerk,
    o_shippriority as order_ship_priority,
    {{ insert_timestamp() }} AS loaded_at
  from source
)
select * from transformed