with lines as (
    select * from {{ ref('stg_lineitem') }}
),
orders as (
    select * from {{ ref('stg_orders') }}
)
select
    L.lineitem_id,
    L.order_id,
    O.customer_id,
    L.part_id,
    L.supplier_id,
    L.lineitem_quantity,
    L.lineitem_extended_price,
    L.lineitem_discount,
    L.lineitem_tax,
    L.lineitem_price_after_discount,
    L.lineitem_price_after_discount_and_tax as lineitem_net_sales,
    O.order_date,
    O.order_status
from lines L
left join orders O on L.order_id = O.order_id