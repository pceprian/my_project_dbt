--busca si se ha registrado alguna venta de un producto (part_id) que no está figura en la fct_inventory
--si devuelve filas, hay un problema  de sincronizacion en la carga origen

{{ config(
    tags = ["check_business"],
    severity = "warn"
) }}

select 
    sales.part_id,
    sales.lineitem_id
from {{ ref('fct_sales') }} sales
left join {{ ref('fct_inventory') }} inv 
    on sales.part_id = inv.part_id
where inv.part_id is null