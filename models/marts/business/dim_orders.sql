select
  order_id,
  order_status,
  order_priority,
  order_clerk,
  order_ship_priority
from {{ ref('stg_orders') }}