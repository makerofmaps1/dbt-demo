with source as (
    select *
    from {{ source('raw', 'raw_sensor_readings') }}
),

source_distinct as (
    select distinct *
    from source
),

cleaned as (
    select
        {{ dbt_utils.generate_surrogate_key([
            'sensorid',
            'timestamp',
            'temp_c',
            'spcond',
            'ph',
            'depth',
            'turbidity',
            'do_pct',
            'do_mgl',
            'power'
        ]) }} as reading_id,
        sensorid::int as sensor_id,
        to_timestamp(timestamp, 'YYYY-MM-DD HH24:MI:SS') as reading_timestamp,
        temp_c::float as temperature_celsius,
        spcond::float as specific_conductance_us_cm,
        ph::float as ph_level,
        depth::float as depth_meters,
        turbidity::float as turbidity_ntu,
        do_pct::float as dissolved_oxygen_percent,
        do_mgl::float as dissolved_oxygen_mg_per_liter,
        power::float as sensor_power_volts,
        case
            when temp_c < -5 or temp_c > 40 then true
            else false
        end as is_suspicious_temperature
    from source_distinct
    where timestamp is not null
)

select * from cleaned
