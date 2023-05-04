DROP INDEX IF EXISTS idx_debit_card_id_balance;

CREATE INDEX idx_debit_card_id_balance ON debit_card(card_balance);

DROP INDEX IF EXISTS idx_credit_card_id_balance;

CREATE UNIQUE INDEX idx_credit_card_id_balance ON credit_card(card_balance, card_credit_limit);