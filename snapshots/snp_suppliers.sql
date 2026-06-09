{% snapshot snp_suppliers %}

{{
    config(
      target_database=env_var('DBT_DATABASE', target.database),
      target_schema='snapshots',
      unique_key='supplier_id',
      strategy='check',
      check_cols=['supplier_name', 'supplier_address', 'supplier_phone', 'supplier_account_balance'],
    )
}}

select 
    supplier_id,
    supplier_name,
    supplier_address,
    supplier_phone,
    supplier_account_balance
from {{ ref('stg_supplier') }}

{% endsnapshot %}