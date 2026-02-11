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
        e.river_name,
        e.temperature_celsius,
        e.dissolved_oxygen_mg_per_liter,
        e.ph_level,
        e.turbidity_ntu,
        f.dissolved_oxygen_status
    from enriched e
    left join flags f
        on e.reading_id = f.reading_id
),

daily_summary as (
    select
        date(reading_timestamp) as reading_date,
        sensor_id,
        river_name,
        count(*) as reading_count,
        avg(temperature_celsius) as avg_temperature,
        min(temperature_celsius) as min_temperature,
        max(temperature_celsius) as max_temperature,
        avg(dissolved_oxygen_mg_per_liter) as avg_dissolved_oxygen,
        avg(ph_level) as avg_ph,
        avg(turbidity_ntu) as avg_turbidity,
        sum(case when dissolved_oxygen_status != 'Normal' then 1 else 0 end) as do_alert_count
    from joined
    group by 1, 2, 3
)

select * from daily_summary
