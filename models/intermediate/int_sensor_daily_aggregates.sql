with readings as (
    select *
    from {{ ref('stg_sensor_readings') }}
),

daily as (
    select
        date(reading_timestamp) as reading_date,
        sensor_id,
        count(*) as reading_count,
        avg(temperature_celsius) as avg_temperature,
        min(temperature_celsius) as min_temperature,
        max(temperature_celsius) as max_temperature,
        avg(dissolved_oxygen_mg_per_liter) as avg_dissolved_oxygen,
        avg(ph_level) as avg_ph,
        avg(turbidity_ntu) as avg_turbidity
    from readings
    group by 1, 2
)

select * from daily
