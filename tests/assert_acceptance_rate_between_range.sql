select
    aggregation_date,
    aggregation_filter,
    acceptance_rate_pct
from {{ ref('payments__acceptance_rate_over_time') }}
where acceptance_rate_pct < 0
    or acceptance_rate_pct > 100