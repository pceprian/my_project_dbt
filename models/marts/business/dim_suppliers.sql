select
    S.supplier_id,
    S.supplier_name,
    S.supplier_address,
    S.supplier_phone,
    S.supplier_account_balance,
    N.nation_name as supplier_nation_name,
    R.region_name as supplier_region_name
from {{ ref('stg_supplier') }} S
left join {{ ref('stg_nation') }} N on S.supplier_nation_id = N.nation_id
left join {{ ref('stg_region') }} R on N.region_id = R.region_id;