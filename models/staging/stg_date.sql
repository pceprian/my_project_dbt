with date_dim as (

    {{ dbt_date.get_date_dimension("1992-01-01", "1998-12-31") }}

)
select * from date_dim