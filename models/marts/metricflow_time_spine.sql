{{
    config(
        materialized = 'table',
    )
}}

with days as (

    select generate_series as date_day
    from generate_series(
        cast('2018-12-01' as date),
        cast('2019-08-31' as date),
        interval 1 day
    )

)

select cast(date_day as date) as date_day
from days
