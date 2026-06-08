{% snapshot snp_customers %}

{{
    config(
      target_database=env_var('DBT_DATABASE', target.database),
      target_schema='snapshots',
      unique_key='customer_id',
      strategy='check',
      check_cols=['customer_name', 'marketing_segment'],
    )
}}

select 
    customer_id,
    customer_name,
    marketing_segment
from {{ ref('stg_customers') }}

{% endsnapshot %}