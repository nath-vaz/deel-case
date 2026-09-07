with payments AS (
    select * from {{ ref('globepay_payments') }}
) 

select
    cast(date_trunc('day', created_at) as date) as aggregation_date,
    'daily' as aggregation_filter,
    -- add dimensions based on analysts' needs
    payment_country,
    cast(count(case when is_accepted is true then 1 end) / count(*) as numeric(18, 2)) * 100 as acceptance_rate_pct
from payments
group by 1, 2, 3

union

select
    cast(date_trunc('week', created_at) as date) as aggregation_date,
    'weekly' as aggregation_filter,
    payment_country,
    cast(count(case when is_accepted is true then 1 end) / count(*) as numeric(18, 2)) * 100 as acceptance_rate_pct
from payments
group by 1, 2, 3

union

select
    cast(date_trunc('month', created_at) as date) as aggregation_date,
    'monthly' as aggregation_filter,
    payment_country,
    cast(count(case when is_accepted is true then 1 end) / count(*) as numeric(18, 2)) * 100 as acceptance_rate_pct
from payments
group by 1, 2, 3
