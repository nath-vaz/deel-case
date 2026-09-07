# dbt_payments

dbt project modeling Globepay payment data (acceptance, chargeback) into staging, mart and dataset layers, plus a dbt Semantic Layer (metrics) on top.

## Setup

1. Install dependencies (a virtualenv with `dbt-duckdb` and `dbt-metricflow` is expected, e.g. `dbt-env/` at the repo root):
   ```bash
   pip install dbt-duckdb dbt-metricflow
   ```
2. Make sure a `dbt_payments` profile exists in `~/.dbt/profiles.yml`, targeting a local DuckDB file:
   ```yaml
   dbt_payments:
     target: dev
     outputs:
       dev:
         type: duckdb
         path: dev.duckdb
         threads: 1
   ```
3. Load the seed data and build all models:
   ```bash
   dbt seed
   dbt run
   ```

## Running tests

Run every test in the project (generic tests defined in `.yml` files + singular tests in `tests/`):
```bash
dbt test
```

Run tests for a single model (and its ancestors/descendants with `+`):
```bash
dbt test --select stg_globepay__acceptance_payments
dbt test --select +globepay_payments+
```

Run only one type of test:
```bash
dbt test --select test_type:generic    # not_null, unique, accepted_values, relationships...
dbt test --select test_type:singular   # tests/assert_acceptance_rate_between_range.sql, tests/assert_positive_payment_amount.sql
```

Build models and run their tests together, in DAG order (fails fast on a broken upstream model):
```bash
dbt build
```

### Semantic Layer (metrics) validation

Metrics and semantic models are defined in `models/marts/globepay_payments.yml`. Validate them against the warehouse with the MetricFlow CLI:
```bash
mf validate-configs
```

Query a metric to sanity-check the result, e.g. acceptance rate by month:
```bash
mf query --metrics acceptance_rate --group-by metric_time__month --order metric_time__month
```

## Docs

Generate and browse the documentation site (models, columns, lineage, tests):
```bash
dbt docs generate
dbt docs serve
```

## Resources
- [dbt docs](https://docs.getdbt.com/docs/introduction)
- [dbt-duckdb adapter](https://github.com/duckdb/dbt-duckdb)
- [MetricFlow / dbt Semantic Layer](https://docs.getdbt.com/docs/build/build-metrics-intro)
