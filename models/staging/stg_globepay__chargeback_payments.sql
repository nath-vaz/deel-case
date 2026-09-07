with source as (

    select * from {{ ref('globepay_chargeback_payments') }}

),

renamed as (

    select
        external_ref AS globepay_payment_id,
        status AS payment_status,
        source AS payment_source,
        chargeback AS is_chargeback
    from source

)

select * from renamed
