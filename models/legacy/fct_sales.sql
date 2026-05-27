with
lines as (
    select * from {{ ref('stg_lineitem') }}
),
orders as (
    select * from {{ ref('stg_orders') }}
),
parts_supplier as (
    select * from {{ ref('stg_partsupp') }}
),

dim_customers as (
    select * from {{ ref('dim_customers') }}
),
dim_parts as (
    select * from {{ ref('dim_parts') }}
),
dim_supplier as (
    select * from {{ ref('dim_suppliers') }}
),

fact as (
    select
        L.lineitem_id,
        L.order_id,
        O.customer_id,   
        L.part_id,   
        L.supplier_id,   
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
        on L.order_id = O.order_id
    left join parts_supplier P 
        on L.part_id = P.part_id 
        and L.supplier_id = P.supplier_id
)
select
    F.lineitem_id,
    F.order_id,
    F.customer_id,
    cust.customer_name,
    cust.marketing_segment,
    F.part_id,
    part.part_name,
    part.part_brand,
    part.part_type,
    part.part_size_group, 
    F.supplier_id,
    supp.supplier_name,
    supp.supplier_nation_name,
    F.order_date,
    F.order_status,
    F.lineitem_ship_date,
    F.lineitem_quantity as quantity,
    F.lineitem_extended_price as gross_price,
    F.lineitem_discount as discount,
    F.lineitem_tax as tax,
    F.line_item_networth_sales as net_sales,
    F.supplier_cost as unit_cost_supplier,
    F.total_purchases_cost as total_cost_purchases,
    F.benefit as net_benefit
from fact F
left join dim_customers cust on F.customer_id = cust.customer_id
left join dim_parts part     on F.part_id = part.part_id
left join dim_supplier supp  on F.supplier_id = supp.supplier_id