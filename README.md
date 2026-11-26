# Fintech Fraud Lakehouse

A dbt project for fraud detection analytics on Databricks. It builds incremental
fraud alerts from the `silver.transactions_clean` source and snapshots account
balances.

## Project layout

- `fraud_analytics/` - dbt models, snapshots, and data tests.
- `data/` - local input datasets; intentionally excluded from version control.
- `main.py` - minimal Python entry point.

## Getting started

Install the Python dependencies with uv:

```shell
uv sync
```

Configure the `fraud_analytics` profile in `~/.dbt/profiles.yml` for your
Databricks connection, then validate the dbt setup and build the project:

```shell
uv run dbt debug --project-dir fraud_analytics
uv run dbt build --project-dir fraud_analytics
```