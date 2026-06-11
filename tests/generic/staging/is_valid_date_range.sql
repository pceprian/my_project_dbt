{% test is_valid_date_range(model, column_name, min_allowed_date='1992-01-01') %}

select *
from {{ model }}
where {{ column_name }} < '{{ min_allowed_date }}'
   or {{ column_name }} > current_date()

{% endtest %}