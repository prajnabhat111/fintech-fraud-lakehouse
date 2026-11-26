{{ config(materialized='incremental', unique_key='tx_id') }}

WITH tx AS (
    SELECT * FROM {{ source('silver', 'transactions_clean') }}
    {% if is_incremental() %}
    WHERE updated_at > (SELECT COALESCE(MAX(updated_at), '1900-01-01') FROM {{ this }})
    {% endif %}
),
scored AS (
    SELECT
        *,
        COUNT(*) OVER (
            PARTITION BY origin_account
            ORDER BY step
            RANGE BETWEEN 3 PRECEDING AND CURRENT ROW
        ) AS tx_count_3h,
        CASE
            WHEN tx_type IN ('TRANSFER', 'CASH_OUT') AND amount >= 200000 THEN 'HIGH_VALUE_DRAIN'
            WHEN old_balance_orig > 0 AND new_balance_orig = 0 AND amount > 50000 THEN 'ACCOUNT_EMPTIED'
            ELSE 'NORMAL'
        END AS alert_reason
    FROM tx
)
SELECT
    tx_id, step, tx_type, amount, origin_account, dest_account,
    balance_delta_orig, tx_count_3h, alert_reason, is_fraud, updated_at
FROM scored
WHERE alert_reason != 'NORMAL' OR tx_count_3h >= 3 OR is_fraud = 1