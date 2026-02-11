select
    sensor_id,
    sensor_name,
    latitude,
    longitude
from {{ ref('stg_sensor_locations') }}
