{{ config(severity = 'warn') }}

select *
from {{ ref('stg_globepay__acceptance_payments') }}
where payment_amount_in_original_currency < 0