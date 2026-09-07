with payments AS (
    select * from {{ ref('globepay_payments') }}
) 

select
    cast(date_trunc('day', created_at) as date) as aggregation_date,
    'daily' as aggregation_filter,
    cast(count(case when is_accepted is true then 1 end) / count(*) as numeric(18, 2)) * 100 as acceptance_rate_pct,
    cast(sum(case when is_accepted is true then payment_amount_in_dollars end) / sum(payment_amount_in_dollars) as numeric(18, 2)) * 100 as acceptance_rate_by_value_pct
from payments
group by 1, 2

union

select
    cast(date_trunc('week', created_at) as date) as aggregation_date,
    'weekly' as aggregation_filter,
    cast(count(case when is_accepted is true then 1 end) / count(*) as numeric(18, 2)) * 100 as acceptance_rate_pct,
    cast(sum(case when is_accepted is true then payment_amount_in_dollars end) / sum(payment_amount_in_dollars) as numeric(18, 2)) * 100 as acceptance_rate_by_value_pct
from payments
group by 1, 2

union

select
    cast(date_trunc('month', created_at) as date) as aggregation_date,
    'monthly' as aggregation_filter,
    cast(count(case when is_accepted is true then 1 end) / count(*) as numeric(18, 2)) * 100 as acceptance_rate_pct,
    cast(sum(case when is_accepted is true then payment_amount_in_dollars end) / sum(payment_amount_in_dollars) as numeric(18, 2)) * 100 as acceptance_rate_by_value_pct
from payments
group by 1, 2
