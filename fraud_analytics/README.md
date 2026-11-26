# Fintech Fraud Lakehouse

This dbt project builds fraud alert models from the `silver.transactions_clean`
Databricks source and snapshots account balances.

Run dbt commands from the repository root with:

```shell
uv run dbt debug --project-dir fraud_analytics
uv run dbt build --project-dir fraud_analytics
```

The profile name remains `dbt_fintech` to match the existing local
`~/.dbt/profiles.yml` connection configuration.
