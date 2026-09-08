{% macro get_currency_rate(currency_rates, payment_currency) %}

    cast(json_extract({{ currency_rates }}, '$.' || {{ payment_currency }}) as numeric)

{% endmacro %}
