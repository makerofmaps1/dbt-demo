with enriched as (
    select *
    from {{ ref('int_sensor_readings_enriched') }}
),

flags as (
    select *
    from {{ ref('int_water_quality_flags') }}
),

joined as (
    select
        e.reading_id,
        e.sensor_id,
        e.reading_timestamp,
        e.temperature_celsius,
        e.specific_conductance_us_cm,
        e.ph_level,
        e.depth_meters,
        e.turbidity_ntu,
        e.dissolved_oxygen_percent,
        e.dissolved_oxygen_mg_per_liter,
        e.sensor_power_volts,
        e.is_suspicious_temperature,
        e.river_name,
        e.latitude,
        e.longitude,
        f.dissolved_oxygen_status,
        f.turbidity_status
    from enriched e
    left join flags f
        on e.reading_id = f.reading_id
)

select * from joined
