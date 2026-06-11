{% test no_spaces(model, column_name) %}

select {{ column_name }}
from {{ model }}
where {{ column_name }} != trim({{ column_name }})

{% endtest %}