{{ config(
    materialized='incremental',
    unique_key='lineitem_id'
) }}

with
source as (
  select * from {{ source('snowflake_sample', 'lineitem') }}
  {% if is_incremental() %}
    where l_shipdate > (
        select max(try_to_date(lineitem_ship_date)) from {{ this }}
    )
  {% endif %}
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
    l_extendedprice * (1 - l_discount) as lineitem_price_after_discount,
    l_tax as lineitem_tax,
    (l_extendedprice * (1 - l_discount)) * (1 + l_tax) as lineitem_price_after_discount_and_tax,
    l_linestatus as line_status,
    l_returnflag as lineitem_return_flag,
    {{ replace_null_text('cast(l_shipdate as date)', 'No Date') }} as lineitem_ship_date,
    {{ replace_null_text('cast(l_commitdate as date)', 'No Date') }} as lineitem_commit_date,
    {{ replace_null_text('cast(l_receiptdate as date)', 'No Date') }} as lineitem_receipt_date,
    l_shipinstruct as lineitem_ship_instruct,
    l_shipmode as lineitem_ship_mode,
    {{ insert_timestamp() }} as loaded_at
  from source
)
select * from transformed