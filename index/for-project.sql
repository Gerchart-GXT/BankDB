DROP INDEX IF EXISTS idx_insurance_amount;

CREATE INDEX idx_insurance_amount ON insurance_project(insurance_amount);

DROP INDEX IF EXISTS idx_fund_amount;

CREATE INDEX idx_fund_amount ON fund_project(fund_amount);

DROP INDEX IF EXISTS idx_financial_amount;

CREATE INDEX idx_financial_amount ON financial_project(financial_project_amount);

DROP INDEX IF EXISTS idx_fund_income;

CREATE INDEX idx_fund_income ON fund_project(fund_income);

DROP INDEX IF EXISTS idx_financial_income;

CREATE INDEX idx_financial_income ON financial_project(financial_project_income);