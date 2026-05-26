with parts as (
    select * from {{ ref('stg_parts') }}
)
select *
from parts