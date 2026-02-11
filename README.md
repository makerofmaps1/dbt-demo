# River Health Analytics Pipeline

A dbt project that transforms raw IoT river sensor data into a dimensional model for water quality analysis.

## Evaluation (short)
- Strong layered design (staging → intermediate → marts) and clear use of dbt best practices.
- Data quality focus is appropriate for environmental monitoring.
- The only gap was source alignment: your available data is SQLite, not CSV. This repo includes a repeatable export script that creates public-friendly CSVs and a PostgreSQL load script.

## Project layout
```
river_health_dbt/
├── data/
│   ├── raw_sensor_readings.csv
│   ├── raw_sensor_locations.csv
│   └── load_data.sql
├── models/
│   ├── staging/
│   ├── intermediate/
│   └── marts/
├── macros/
├── tests/
└── docs/
```

## Quick start
**Prerequisites**
- PostgreSQL installed and running locally.
- A SQL client (DBeaver or psql).

1. Load CSVs into PostgreSQL raw schema:
   - See [data/load_data.sql](data/load_data.sql)
2. Configure dbt profile (example below) and run:
   - `dbt deps`
   - `dbt seed` (optional)
   - `dbt run`
   - `dbt test`

## Step-by-step local dbt walkthrough (beginner friendly)
1. **Use Python 3.12** (dbt doesn’t support later versions yet).
2. **Create and activate the venv**
   - PowerShell: `.\.venv\Scripts\Activate.ps1`
   - If scripts are blocked: `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass`
   - cmd.exe: `.venv\Scripts\activate.bat`
3. **Install dependencies**
   - `python -m pip install -r requirements.txt`
4. **Verify dbt**
   - `dbt --version`
5. **Create a local PostgreSQL database**
   - **DBeaver**: Connect to your local Postgres server → right‑click Databases → Create New Database → name it `river_health`.
   - **psql**: Run `CREATE DATABASE river_health;`
6. **Ensure a dbt profile exists**
   - If `dbt run` works, you already have a valid profile and can skip this.
   - Otherwise, copy [profiles.yml.example](profiles.yml.example) to:
       - Windows: %USERPROFILE%\.dbt\profiles.yml (this expands to your home folder, e.g., C:\Users\YourName\.dbt\profiles.yml)
     - macOS/Linux: `~/.dbt/profiles.yml`
   - Update host/user/password/dbname.
7. **Prepare the raw data**
   - Load CSVs into Postgres:
     - **DBeaver**: open [data/load_data.sql](data/load_data.sql) and execute it (replace file paths in the `\copy` lines with your local absolute paths).
     - **psql**: connect to `river_health` and run the script; `\copy` is a psql command and must be run in psql.
8. **Install dbt packages**
   - Run `dbt deps` to install dbt_utils from [packages.yml](packages.yml).
9. **Build models**
   - Run `dbt run` to build staging → intermediate → marts.
10. **Run tests**
    - Run `dbt test` for schema + custom tests.
11. **Generate docs**
   - Run `dbt docs generate` then `dbt docs serve` to browse lineage and model docs.
   - If the port is busy, run `dbt docs serve --port 8081`.

### If tests fail after a model change
Rebuild downstream models before testing again:
- `dbt run -s stg_sensor_readings+`
- `dbt test`

### Example dbt profile
Create ~/.dbt/profiles.yml:
```yaml
river_health_dbt:
  target: dev
  outputs:
    dev:
      type: postgres
      host: localhost
      user: postgres
      password: your_password
      port: 5432
      dbname: river_health
      schema: public
      threads: 4
```

## Data model (high level)
- **Staging**: clean and type raw readings and sensor metadata.
- **Intermediate**: enrich readings, compute quality flags, build daily aggregates.
- **Marts**: fact table, dimensions, daily summaries, and alerts.

## Key features
- Source definitions + documentation
- Schema tests and custom value-range test macro
- Dimensional modeling + daily rollups
- Extensible for dashboards (Streamlit/BI)

## Notes
- `sensorname` is used as a proxy for river/location name in marts.
- The repo contains a **sampled** subset of readings (first 10,000 rows by timestamp) to keep the public dataset small.
