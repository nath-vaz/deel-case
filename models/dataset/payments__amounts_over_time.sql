with payments as (
    select * from {{ ref('globepay_payments') }}
)

select
    payment_country,
    cast(date_trunc('month', created_at) as date) AS month_date,
    sum(payment_amount_in_dollars) AS payments_amount_in_dollars,
    sum(case when is_accepted is true then payment_amount_in_dollars end) AS accepted_payments_amount_in_dollars,
    sum(case when is_accepted is false then payment_amount_in_dollars end) AS declined_payments_amount_in_dollars
from payments
group by 1, 2
order by 1, 2
