with
lines as (
    select * from {{ ref('stg_lineitem') }}
),
staging_orders as (
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
dim_orders as (
    select * from {{ ref('dim_orders') }}
),
dim_date as (
    select * from {{ ref('dim_date') }} 
),

fact_metrics as (
    select
        L.lineitem_id,
        L.order_id,
        O.customer_id,   
        L.part_id,   
        L.supplier_id,   
        O.order_date,
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
    left join staging_orders O on L.order_id = O.order_id
    left join parts_supplier P on L.part_id = P.part_id and L.supplier_id = P.supplier_id
)

--Create the final fact:
select
    F.lineitem_id,
    F.order_id,
    
    --Customer attributes
    F.customer_id,
    cust.customer_name,
    cust.marketing_segment,
    
    --Part attributes
    F.part_id,
    part.part_name,
    part.part_brand,
    part.part_type,
    part.part_size_group, 
    
    --Supplier attributes
    F.supplier_id,
    supp.supplier_name,
    supp.supplier_nation_name,
    
    --Order attributes
    ord.order_status,
    ord.order_priority,
    ord.order_clerk,
    
    -- Date Keys (FKs to connect with dim_date later in BI tools like PowerBI)
    F.order_date as order_date_key,
    F.lineitem_ship_date as ship_date_key,
    
    --Quantitative metrics obtained through the stgs
    F.lineitem_quantity as quantity,
    F.lineitem_extended_price as gross_price,
    F.lineitem_discount as discount,
    F.lineitem_tax as tax,
    F.line_item_networth_sales as net_sales,
    F.supplier_cost as unit_cost_supplier,
    F.total_purchases_cost as total_cost_purchases,
    F.benefit as net_benefit

from fact_metrics F
left join dim_customers cust on F.customer_id = cust.customer_id
left join dim_parts part     on F.part_id = part.part_id
left join dim_supplier supp  on F.supplier_id = supp.supplier_id
left join dim_orders ord     on F.order_id = ord.order_id  -- El nuevo join limpio de dimensión