with bounds as (
    select
        min(date(reading_timestamp)) as min_date,
        max(date(reading_timestamp)) as max_date
    from {{ ref('stg_sensor_readings') }}
),

spine as (
    select generate_series(min_date, max_date, interval '1 day')::date as date_day
    from bounds
)

select
    date_day as date_day,
    extract(year from date_day) as year,
    extract(month from date_day) as month,
    extract(day from date_day) as day,
    extract(dow from date_day) as day_of_week
from spine
