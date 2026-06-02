{% macro size_parts(part_size) %}
    CASE 
        WHEN {{ part_size }} IS NULL THEN 'Unknown'
        WHEN {{ part_size }} < 20 THEN 'Small'
        WHEN {{ part_size }} >= 20 AND {{ part_size }} < 40 THEN 'Medium'
        ELSE 'Large'
    END
{% endmacro %}