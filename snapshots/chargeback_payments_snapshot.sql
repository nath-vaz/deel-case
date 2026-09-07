{% snapshot chargeback_payments_snapshot %}
{{
    config(
        target_schema='snapshots',
        unique_key='globepay_payment_id',
        strategy='check',
        check_cols=['is_chargeback']
    )
}}
select * from {{ ref('stg_globepay__chargeback_payments') }}
{% endsnapshot %}