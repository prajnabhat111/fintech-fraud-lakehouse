-- Fails if any invalid amounts, negative balances, or miscalculated deltas reach Silver
SELECT
    tx_id,
    amount,
    old_balance_orig,
    new_balance_orig,
    balance_delta_orig
FROM {{ source('silver', 'transactions_clean') }}
WHERE amount <= 0
   OR old_balance_orig < 0
   OR new_balance_orig < 0
   OR ABS((old_balance_orig - new_balance_orig) - balance_delta_orig) > 0.01