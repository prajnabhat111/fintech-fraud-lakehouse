{% snapshot snap_account_balances %}
{{
    config(
      target_schema='snapshots',
      unique_key='origin_account',
      strategy='check',
      check_cols=['new_balance_orig']
    )
}}
SELECT origin_account, new_balance_orig, updated_at
FROM {{ source('silver', 'transactions_clean') }}
QUALIFY ROW_NUMBER() OVER (PARTITION BY origin_account ORDER BY step DESC, updated_at DESC) = 1
{% endsnapshot %}