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
    L.lineitem_quantity,
    L.lineitem_extended_price,
    L.lineitem_discount,
    L.lineitem_tax,
    (L.lineitem_extended_price * (1 - L.lineitem_discount) * (1 + L.lineitem_tax)) as line_item_profit,
    O.order_date,
    O.order_status
from lines L
left join orders O 
ON L.order_id = O.order_id