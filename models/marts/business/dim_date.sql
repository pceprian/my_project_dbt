select
    {{ dbt_utils.generate_surrogate_key(['date_day']) }} as date_key,
    *
from {{ ref('stg_date') }}