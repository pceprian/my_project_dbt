with
source as (
  select * from {{ source('snowflake_sample', 'orders') }}
),
transformed as (
  select
    o_orderkey as order_id,
    o_custkey as customer_id,
    case o_orderstatus
      when 'O' then 'Open'
      when 'F' then 'Finished'
      when 'P' then 'Partial'
      else 'Unknown'
    end as order_status,
    o_totalprice as order_total_price,
    coalesce(o_orderdate, '1990-01-01'::date) as order_date,
    cast(regexp_substr(o_orderpriority, '\\d+') as integer) as order_priority_code,
    trim(regexp_substr(o_orderpriority, '[A-Z ][A-Z ]+')) as order_priority_name,
    o_clerk as order_clerk,
    o_shippriority as order_ship_priority,
    cast({{ dbt.current_timestamp() }} as {{ dbt.type_timestamp() }}) as loaded_at
  from source
)
select * from transformed