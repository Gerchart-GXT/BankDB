DROP VIEW IF EXISTS view_card_credit CASCADE;

CREATE
OR REPLACE VIEW view_card_credit AS (
    SELECT
        card.client_id clt_id,
        card.card_id c_id,
        card.card_valid_thru c_vald,
        credit_card.card_balance c_bl,
        credit_card.card_credit_limit c_crd_lit
    FROM
        card,
        credit_card
    WHERE
        card.card_id = credit_card.card_id
);

DROP VIEW IF EXISTS view_card_debit CASCADE;

CREATE
OR REPLACE VIEW view_card_debit AS (
    SELECT
        card.client_id clt_id,
        card.card_id c_id,
        card.card_valid_thru c_vald,
        debit_card.card_balance c_bl
    FROM
        card,
        debit_card
    WHERE
        card.card_id = debit_card.card_id
);

DROP VIEW IF EXISTS view_all_card CASCADE;

CREATE
OR REPLACE VIEW view_all_card AS (
    select
        *
    from
        view_card_credit
    union
    select
        view_card_debit.clt_id,
        view_card_debit.c_id,
        view_card_debit.c_vald,
        view_card_debit.c_bl,
        view_card_credit.c_crd_lit
    from
        view_card_credit
        right join view_card_debit on view_card_credit.c_id = view_card_debit.c_id
);

DROP VIEW IF EXISTS view_client_card CASCADE;

CREATE
OR REPLACE VIEW view_client_card AS (
    SELECT
        client.client_name,
        client.client_phone_number,
        client.client_email_address,
        view_all_card.c_id card_id,
        view_all_card.c_vald card_valid_thru,
        view_all_card.c_bl card_balance,
        view_all_card.c_crd_lit card_credit_limit
    FROM
        client,
        view_all_card
    WHERE
        client.client_id = view_all_card.clt_id
);