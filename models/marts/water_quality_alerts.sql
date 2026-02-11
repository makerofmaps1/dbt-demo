select
    e.reading_id,
    e.sensor_id,
    e.reading_timestamp,
    e.river_name,
    f.dissolved_oxygen_status,
    f.turbidity_status
from {{ ref('int_sensor_readings_enriched') }} e
join {{ ref('int_water_quality_flags') }} f
    on e.reading_id = f.reading_id
where f.dissolved_oxygen_status != 'Normal'
   or f.turbidity_status != 'Normal'
