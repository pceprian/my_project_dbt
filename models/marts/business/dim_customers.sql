select
    C.customer_id,
    C.customer_name,
    C.customer_address,
    C.customer_phone,
    C.marketing_segment,
    N.nation_name as customer_nation_name,
    R.region_name as customer_region_name
from {{ ref('stg_customers') }} as C
left join {{ ref('stg_nation') }} as N on C.customer_nation_id = N.nation_id
left join {{ ref('stg_region') }} as R on N.region_id = R.region_id
