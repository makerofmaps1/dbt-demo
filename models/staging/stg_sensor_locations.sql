with source as (
    select *
    from {{ source('raw', 'raw_sensor_locations') }}
),

cleaned as (
    select
        sensorid::int as sensor_id,
        sensorname::varchar as sensor_name,
        latitude::float as latitude,
        longitude::float as longitude
    from source
)

select * from cleaned
