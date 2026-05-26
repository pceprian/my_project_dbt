{% macro insert_timestamp() %}
    CAST({{ dbt.current_timestamp() }} AS {{ dbt.type_timestamp() }})
{% endmacro %}