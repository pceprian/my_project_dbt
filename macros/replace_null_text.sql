{% macro replace_null_text(column, replace_text='No Information') %}
    CASE 
        WHEN {{ column }} IS NULL OR TRIM({{ column }}) = '' THEN '{{ replace_text }}'
        ELSE TRIM({{ column }})
    END
{% endmacro %}