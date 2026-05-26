with lines as (
    select * from {{ ref('stg_lineitem') }}
),
orders as (
    select * from {{ ref('stg_orders') }}
),
parts_supplier as (
    select * from {{ ref('stg_partsupp') }}
)
select
    L.lineitem_id,
    L.order_id,
    
    O.customer_id,       --dim_customers
    L.part_id,      -- dim_parts
    L.supplier_id,     --  dim_supplier
    
    O.order_date,
    O.order_status,
    L.lineitem_ship_date,
    
    L.lineitem_quantity,
    L.lineitem_extended_price,
    L.lineitem_discount,
    L.lineitem_tax,
    
   (L.lineitem_extended_price * (1 - L.lineitem_discount) * (1 + L.lineitem_tax)) as line_item_networth_sales,
    P.supplier_cost,
    (P.supplier_cost * L.lineitem_quantity) as total_purchases_cost,
    ((L.lineitem_extended_price * (1 - L.lineitem_discount) * (1 + L.lineitem_tax)) - (P.supplier_cost * L.lineitem_quantity)) as benefit

from lines L
left join orders O 
    on L.id_pedido = O.id_pedido
left join parts_supplier P 
    on L.id_producto = P.id_producto 
    and L.id_proveedor = P.id_proveedor