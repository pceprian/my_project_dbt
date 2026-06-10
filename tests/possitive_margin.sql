--no habria quer vender productos por debajo de su coste de adquisicion
--esto avisa si el precio cobrado al cliente es menor que lo que costó segun el inventario

{{ config(
    tags = ["check_business"],
    severity = "warn"
) }}

select 
    s.lineitem_id,
    s.price_after_discount,
    i.part_supply_cost
from {{ ref('fct_sales') }} s
join {{ ref('fct_inventory') }} i 
    on s.part_id = i.part_id and s.supplier_id = i.supplier_id
where s.price_after_discount < i.part_supply_cost