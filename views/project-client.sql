DROP VIEW IF EXISTS view_client_insurance_project CASCADE;

CREATE
OR REPLACE VIEW view_client_insurance_project AS(
    SELECT
        DISTINCT clt.client_name,
        clt.client_phone_number,
        clt.client_email_address,
        ip.insurance_project_id,
        ip.insurance_project_name,
        ip.insurance_insured,
        ip.insurance_amount,
        ip.insurance_period
    FROM
        client clt,
        view_manager_with_project mwp,
        insurance_project ip
    WHERE
        mwp.project_id = ip.project_id
        AND mwp.client_id = clt.client_id
);

DROP VIEW IF EXISTS view_client_fund_project CASCADE;

CREATE
OR REPLACE VIEW view_client_fund_project AS(
    SELECT
        DISTINCT clt.client_name,
        clt.client_phone_number,
        clt.client_email_address,
        fp.fund_project_id,
        fp.fund_name,
        fp.fund_type,
        fp.fund_amount,
        fp.fund_period
    FROM
        client clt,
        view_manager_with_project mwp,
        fund_project fp
    WHERE
        mwp.project_id = fp.project_id
        AND mwp.client_id = clt.client_id
);

DROP VIEW IF EXISTS view_client_financial_project CASCADE;

CREATE
OR REPLACE VIEW view_client_financial_project AS(
    SELECT
        DISTINCT clt.client_name,
        clt.client_phone_number,
        clt.client_email_address,
        fp.financial_project_id,
        fp.financial_project_name,
        fp.financial_project_amount,
        fp.financial_project_income,
        fp.financial_project_period
    FROM
        client clt,
        view_manager_with_project mwp,
        financial_project fp
    WHERE
        mwp.project_id = fp.project_id
        AND mwp.client_id = clt.client_id
);

DROP VIEW IF EXISTS view_client_property CASCADE;

CREATE
OR REPLACE VIEW view_client_property AS(
    SELECT
        clt.client_name,
        clt.client_phone_number,
        clt.client_email_address,
        currency_project.project_id,
        property.project_state
    FROM
        client clt,
        property,
        currency_project
    WHERE
        currency_project.project_id = property.project_id
        AND clt.client_id = property.client_id
);