{{
    config(
        materialized='incremental'
    )
}}

with source as (
    select *
    from {{ ref('globepay_acceptance_payments') }}

    {% if is_incremental() %}

        where date_time > (select max(created_at) from {{ this }})

    {% endif %}
),

renamed as (
    select
        external_ref as globepay_payment_id,
        ref as deel_payment_id,
        cast(date_time as timestamp) as created_at,
        status as payment_status,
        case
            when state = 'ACCEPTED' then TRUE
            when state = 'DECLINED' then FALSE
        end as is_accepted,
        cvv_provided as is_cvv_provided,
        amount as payment_amount_in_original_currency,
        currency as payment_currency,
        country as payment_country,
        rates as currency_rates,
    from source
)

select * from renamed
