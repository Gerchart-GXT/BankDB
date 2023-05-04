DROP TABLE IF EXISTS client CASCADE;

CREATE TABLE client(
    client_id INT UNIQUE NOT NULL,
    client_name VARCHAR(100) NOT NULL,
    client_idnum VARCHAR(20) UNIQUE NOT NULL,
    CHECK (length(client_idnum) = 18),
    client_phone_number VARCHAR(20) NOT NULL,
    CHECK (length(client_phone_number) = 11),
    client_email_address VARCHAR(100) NOT NULL,
    CHECK (client_email_address LIKE '%@%'),
    client_password VARCHAR(100) NOT NULL,
    CHECK (length(client_password) > 6),
    PRIMARY KEY(client_id)
);

DROP TABLE IF EXISTS card CASCADE;

CREATE TABLE card(
    client_id INT NOT NULL,
    card_id INT UNIQUE NOT NULL,
    card_valid_thru DATE NOT NULL,
    card_check_code VARCHAR(20) NOT NULL,
    CHECK (length(card_check_code) = 3),
    card_password VARCHAR(20) NOT NULL,
    CHECK (length(card_password) = 6),
    PRIMARY KEY(client_id, card_id),
    FOREIGN KEY(client_id) REFERENCES client(client_id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS debit_card CASCADE;

CREATE TABLE debit_card(
    card_id INT UNIQUE NOT NULL,
    card_balance DECIMAL(18, 2) DEFAULT 0,
    CHECK (card_balance >= 0),
    PRIMARY KEY(card_id),
    FOREIGN KEY(card_id) REFERENCES card(card_id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS credit_card CASCADE;

CREATE TABLE credit_card(
    card_id INT UNIQUE NOT NULL,
    card_balance DECIMAL(18, 2) DEFAULT 0,
    CHECK (card_balance >= 0),
    card_credit_limit DECIMAL(18, 2) DEFAULT 0,
    CHECK (card_credit_limit >= 0),
    PRIMARY KEY(card_id),
    FOREIGN KEY(card_id) REFERENCES card(card_id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS department CASCADE;

CREATE TABLE department(
    department_id INT UNIQUE NOT NULL,
    department_name VARCHAR(100) NOT NULL,
    PRIMARY KEY(department_id)
);

DROP TABLE IF EXISTS manager CASCADE;

CREATE TABLE manager(
    manager_id INT UNIQUE NOT NULL,
    manager_department_id INT NOT NULL,
    manager_name VARCHAR(100) NOT NULL,
    manager_phone_number VARCHAR(20) NOT NULL,
    CHECK (length(manager_phone_number) = 11),
    manager_email_address VARCHAR(100) NOT NULL,
    CHECK (manager_email_address LIKE '%@%'),
    manager_password VARCHAR(100) NOT NULL,
    CHECK (length(manager_password) > 6),
    PRIMARY KEY(manager_id),
    FOREIGN KEY(manager_department_id) REFERENCES department(department_id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS currency_project CASCADE;

CREATE TABLE currency_project(
    project_id INT UNIQUE NOT NULL,
    client_id INT NOT NULL,
    PRIMARY KEY(project_id),
    FOREIGN KEY(client_id) REFERENCES client(client_id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS manager_with_currency_project CASCADE;

CREATE TABLE manager_with_currency_project(
    relation_id INT UNIQUE NOT NULL,
    project_id INT NOT NULL,
    manager_id INT NOT NULL,
    PRIMARY KEY(relation_id),
    FOREIGN KEY(project_id) REFERENCES currency_project(project_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(manager_id) REFERENCES manager(manager_id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS insurance_project CASCADE;

CREATE TABLE insurance_project(
    project_id INT UNIQUE NOT NULL,
    insurance_project_id INT UNIQUE NOT NULL,
    insurance_project_name VARCHAR(100) NOT NULL,
    insurance_policyholder VARCHAR(20) NOT NULL,
    CHECK (length(insurance_policyholder) = 18),
    insurance_insured VARCHAR(20) NOT NULL,
    CHECK (length(insurance_insured) = 18),
    insurance_amount DECIMAL(18, 2) DEFAULT 0,
    CHECK (insurance_amount >= 0),
    insurance_period DATE NOT NULL,
    insurance_detail_etc text default NULL,
    PRIMARY KEY(insurance_project_id),
    FOREIGN KEY(project_id) REFERENCES currency_project(project_id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS fund_project CASCADE;

CREATE TABLE fund_project(
    project_id INT UNIQUE NOT NULL,
    fund_project_id INT UNIQUE NOT NULL,
    fund_name VARCHAR(100) NOT NULL,
    fund_type VARCHAR(100) NOT NULL,
    fund_amount DECIMAL(18, 2) DEFAULT 0,
    CHECK (fund_amount >= 0),
    fund_income DECIMAL(18, 2) DEFAULT 0,
    CHECK (fund_income >= 0),
    fund_period DATE default NULL,
    fund_detail_etc text default NULL,
    PRIMARY KEY(project_id, fund_project_id),
    FOREIGN KEY(project_id) REFERENCES currency_project(project_id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS financial_project CASCADE;

CREATE TABLE financial_project(
    project_id INT UNIQUE NOT NULL,
    financial_project_id INT UNIQUE NOT NULL,
    financial_project_name VARCHAR(100) NOT NULL,
    financial_project_amount DECIMAL(18, 2) DEFAULT 0,
    CHECK (financial_project_amount >= 0),
    financial_project_income DECIMAL(18, 2) DEFAULT 0,
    CHECK (financial_project_income >= 0),
    financial_project_period DATE NOT NULL,
    financial_project_detail_etc text default NULL,
    PRIMARY KEY(project_id),
    FOREIGN KEY(project_id) REFERENCES currency_project(project_id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS property CASCADE;

CREATE TABLE property(
    project_id INT UNIQUE NOT NULL,
    client_id INT NOT NULL,
    project_state VARCHAR(100) NOT NULL DEFAULT 'Active',
    CHECK (
        (project_state = 'Active')
        OR (project_state = 'Invalid')
        OR (project_state = 'Frozen')
    ),
    PRIMARY KEY(project_id),
    FOREIGN KEY(client_id) REFERENCES client(client_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(project_id) REFERENCES currency_project(project_id) ON UPDATE CASCADE ON DELETE CASCADE
);