with acceptance_payments as (

    select * from {{ ref('stg_globepay__acceptance_payments') }}

),

chargeback_payments as (

    select * from {{ ref('stg_globepay__chargeback_payments') }}

)

select
    acceptance_payments.globepay_payment_id,
    acceptance_payments.deel_payment_id,
    acceptance_payments.created_at,
    acceptance_payments.is_accepted,
    acceptance_payments.is_cvv_provided,
    acceptance_payments.payment_amount_in_original_currency,
    cast(payment_amount_in_original_currency / {{ get_currency_rate('currency_rates', 'payment_currency') }} as numeric(18, 2)) as payment_amount_in_dollars,
    acceptance_payments.payment_currency,
    acceptance_payments.payment_country,
    acceptance_payments.currency_rates,
    chargeback_payments.is_chargeback
from acceptance_payments
left join chargeback_payments
    on acceptance_payments.globepay_payment_id = chargeback_payments.globepay_payment_id
