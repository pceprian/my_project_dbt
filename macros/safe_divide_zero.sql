{% macro safe_divide_zero(numerator, denominator) %}
    
    CASE
        WHEN {{ denominator }} = 0 THEN 'Invalid Result'
        ELSE {{ numerator }} / {{ denominator }}
    END

{% endmacro %}