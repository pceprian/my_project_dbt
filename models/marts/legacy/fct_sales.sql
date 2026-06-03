with
detailed_lines as (
    select * from {{ ref('int_lines_items_detailed') }}
),
dim_customers as (
    select * from {{ ref('dim_customers') }}
),
dim_parts as (
    select * from {{ ref('dim_parts') }}
),
dim_supplier as (
    select * from {{ ref('dim_suppliers') }}
)
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
    
    --Supplier attributes
    F.supplier_id,
    supp.supplier_name,
    supp.supplier_nation_name,
    
    F.order_status,
    
    --Dates for using it later on PowerBI tools like PowerBI
    F.order_date as order_date_key,
    
    --Quantitave metrics
    F.lineitem_quantity as quantity,
    F.lineitem_extended_price as gross_price,
    F.lineitem_discount as discount,
    F.lineitem_tax as tax,
    --adjusting fct_sales
    F.lineitem_price_after_discount as price_after_discount,
    F.lineitem_net_sales as net_sales

from detailed_lines F
left join dim_customers cust on F.customer_id = cust.customer_id
left join dim_parts part     on F.part_id = part.part_id
left join dim_supplier supp  on F.supplier_id = supp.supplier_id