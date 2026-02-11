with readings as (
    select *
    from {{ ref('stg_sensor_readings') }}
),

locations as (
    select *
    from {{ ref('stg_sensor_locations') }}
),

enriched as (
    select
        r.reading_id,
        r.sensor_id,
        r.reading_timestamp,
        r.temperature_celsius,
        r.specific_conductance_us_cm,
        r.ph_level,
        r.depth_meters,
        r.turbidity_ntu,
        r.dissolved_oxygen_percent,
        r.dissolved_oxygen_mg_per_liter,
        r.sensor_power_volts,
        r.is_suspicious_temperature,
        l.sensor_name as river_name,
        l.latitude,
        l.longitude
    from readings r
    left join locations l
        on r.sensor_id = l.sensor_id
)

select * from enriched
