{% macro get_currency_rate(currency_rates, payment_currency) %}

    {%- set cleaned_currency_rates -%}
        replace(replace({{ currency_rates }}, '''', '"'), 'None', 'null')
    {%- endset -%}

    cast(json_extract({{ cleaned_currency_rates }}, '$.' || {{ payment_currency }}) as numeric)

{% endmacro %}