{{ config(
    tags = ["check_business"],
    severity = "warn"
) }}

with intermediate_data as (
    select sum(lineitem_net_sales) as total_previo
    from {{ ref('int_lines_items_detailed') }}
),
marts_data as (
    select sum(net_sales) as total_final
    from {{ ref('fct_sales') }}
)
select 
    i.total_previo,
    m.total_final,
    abs(i.total_previo - m.total_final) as diferencia
from intermediate_data i
cross join marts_data m
where abs(i.total_previo - m.total_final) > 0.01