with
partsupp as (
    select  * from {{ ref('stg_partsupp') }}
),
dim_parts as (
    select * from {{ ref('dim_parts') }}
),
dim_supplier as (
    select * from {{ ref('dim_suppliers') }}
),

inventory_calculations as (
    select
        {{ dbt_utils.generate_surrogate_key(['part_id', 'supplier_id']) }} as inventory_id,
        part_id,
        supplier_id,
        part_supplier_available_quantity,
        (coalesce(part_supplier_available_quantity, 0)) as total_inventory_valuation
    from partsupp
)

select
    I.inventory_id,
    
    -- Part attributes
    I.part_id,
    part.part_name,
    part.part_brand,
    part.part_type,

     --Supplier attributes
    I.supplier_id,
    supp.supplier_name,
    supp.supplier_nation_name,
    
    -- Qauntitave metrics of inventory
    I.part_supplier_available_quantity,
    I.total_inventory_valuation

from inventory_calculations I
left join dim_parts part     on I.part_id = part.part_id
left join dim_supplier supp  on I.supplier_id = supp.supplier_id