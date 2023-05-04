SELECT
    *
FROM
    (
        SELECT
            *
        FROM
            view_client_card
        EXCEPT
        SELECT
            *
        FROM
            view_client_card
        WHERE
            card_credit_limit > 0
    ) t
WHERE
    t.card_balance >= 100000
    AND t.card_balance <= 500000;

select
    client_name,
    client_phone_number,
    client_email_address,
    card_id,
    card_valid_thru,
    card_credit_limit - card_balance card_used_balance
from
    view_client_card
where
    card_credit_limit > 0;