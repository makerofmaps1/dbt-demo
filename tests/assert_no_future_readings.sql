-- No readings should have timestamps in the future
select *
from {{ ref('stg_sensor_readings') }}
where reading_timestamp > current_timestamp
