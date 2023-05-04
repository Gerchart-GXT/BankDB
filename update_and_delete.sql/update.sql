UPDATE
    fund_project
SET
    fund_income = fund_income * 1.05
WHERE
    fund_project_id % 2 = 1;

UPDATE
    credit_card
SET
    card_balance = card_balance * 1.001
WHERE
    card_id in (
        SELECT
            cd.card_id
        FROM
            client clt,
            card cd,
            credit_card cdt
        WHERE
            cd.card_id = cdt.card_id
            AND cd.client_id = clt.client_id
            AND (
                (clt.client_phone_number LIKE '%2')
                OR (clt.client_phone_number LIKE '%5')
                OR (clt.client_phone_number LIKE '%8')
                OR (clt.client_phone_number LIKE '%0')
            )
    );