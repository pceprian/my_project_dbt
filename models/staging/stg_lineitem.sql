{{ config(
	materialized='incremental'
   )
}}


with
source as (
  select * from {{ source('snowflake_sample', 'lineitem') }}
),
transformed as (
  select
    concat(l_orderkey, '-', l_partkey, '-', l_suppkey,'-', l_linenumber) as lineitem_id,
    l_orderkey as order_id,
    l_partkey as part_id,
    l_suppkey as supplier_id,
    l_linenumber as lineitem_number,
    l_quantity as lineitem_quantity,
    l_extendedprice as lineitem_extended_price,
    l_discount as lineitem_discount,
    l_tax as lineitem_tax,
    l_returnflag as line_item_return_flag,
    l_linestatus as line_status,
    cast(l_shipdate as date) as lineitem_ship_date,
    cast(l_commitdate as date) as lineitem_commit_date,
    cast(l_receiptdate as date) as lineitem_receipt_date,
    l_shipinstruct as lineitem_ship_instruct,
    l_shipmode as lineitem_ship_mode
  from source
)
select * from transformed


{% if is_incremental() %}
    where lineitem_ship_date > (select max(lineitem_ship_date) from {{ this }})
{% endif %}