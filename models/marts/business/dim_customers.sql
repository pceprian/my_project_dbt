with customers as (
    select * from {{ ref('stg_customers') }}
),
nation as (
    select * from {{ ref('stg_nation') }}
),
region as (
    select * from {{ ref('stg_region') }}
)
select
    C.customer_id,
    C.customer_name,
    C.customer_address,
    C.customer_phone,
    C.nation_name as customer_nation_name,
    R.region_name as customer_region_name
from customer C
left join nation N on C.customer_nation_id = N.nation_id
left join region R on N.region_id = R.region_id