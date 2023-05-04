CREATE USER dbuser WITH PASSWORD "Gauss#3demo";

GRANT USAGE ON schema finance TO dbuser;

GRANT
SELECT
,
INSERT
    ON card,
    credit_card,
    debit_card TO dbuser;