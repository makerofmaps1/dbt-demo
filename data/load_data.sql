-- Run with psql. Update the file paths to your local absolute paths.

create schema if not exists sensor_data;

create table if not exists sensor_data.raw_sensor_locations (
  sensorid integer,
  sensorname varchar(64),
  latitude double precision,
  longitude double precision
);

create table if not exists sensor_data.raw_sensor_readings (
  timestamp varchar(19),
  sensorid integer,
  temp_c double precision,
  spcond double precision,
  ph double precision,
  depth double precision,
  turbidity double precision,
  do_pct double precision,
  do_mgl double precision,
  power double precision
);

truncate table sensor_data.raw_sensor_locations;
truncate table sensor_data.raw_sensor_readings;

-- Example (Windows):
-- \copy sensor_data.raw_sensor_locations from 'C:/Misc_code_projects/dbt-demo/data/raw_sensor_locations.csv' with (format csv, header true);
-- \copy sensor_data.raw_sensor_readings from 'C:/Misc_code_projects/dbt-demo/data/raw_sensor_readings.csv' with (format csv, header true);
