with readings as (
    select *
    from {{ ref('stg_sensor_readings') }}
),

flagged as (
    select
        reading_id,
        sensor_id,
        reading_timestamp,
        dissolved_oxygen_mg_per_liter,
        turbidity_ntu,
        case
            when dissolved_oxygen_mg_per_liter < 3.0 then 'Critical Low DO'
            when dissolved_oxygen_mg_per_liter < 5.0 then 'Low DO Warning'
            else 'Normal'
        end as dissolved_oxygen_status,
        case
            when turbidity_ntu > 100 then 'Critical Turbidity'
            when turbidity_ntu > 50 then 'High Turbidity Warning'
            else 'Normal'
        end as turbidity_status
    from readings
)

select * from flagged
