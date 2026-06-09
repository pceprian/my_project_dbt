{% macro compare_sales_relations() %}
--para ejecutarla: dbt run-operation compare_sales_relations

{% if execute %}
    {% set old_relation = ref('fct_sales_deprecated') %}
    {% set new_relation = ref('fct_sales') %}

    {% set audit_query = audit_helper.compare_relations(
        a_relation=old_relation,
        b_relation=new_relation,
        primary_key="order_id"
    ) %}

    {% set audit_results = run_query(audit_query) %}
    
    {{ log(" Log :", info=True) }}
    {% do audit_results.print_table() %}
    {{ log("End Log", info=True) }}

{% endif %}
{% endmacro %}