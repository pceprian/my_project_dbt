{% macro replace_null_text(column, replace_text='No Information') %}
    CASE 
        -- Forzar el CAST a VARCHAR para asegurar que el TRIM funcione con cualquier tipo de dato (Date, Number, etc.)
        WHEN {{ column }} IS NULL OR TRIM(CAST({{ column }} AS VARCHAR)) = '' THEN '{{ replace_text }}'
        ELSE TRIM(CAST({{ column }} AS VARCHAR))
    END
{% endmacro %}