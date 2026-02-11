# Architecture

```mermaid
graph TD
  A[SQLite source] --> B[CSV exports]
  B --> C[PostgreSQL sensor_data schema]
  C --> D[dbt staging]
  D --> E[dbt intermediate]
  E --> F[dbt marts]
  F --> G[BI / Dashboards]
```

## Layers
- **Raw**: CSV-loaded tables in PostgreSQL (`sensor_data.raw_sensor_readings`, `sensor_data.raw_sensor_locations`).
- **Staging**: Type casting, renaming, and basic validation.
- **Intermediate**: Enrichment and quality flag logic.
- **Marts**: Dimensional model and daily summaries.
