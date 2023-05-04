DROP VIEW IF EXISTS view_manager_with_project CASCADE;

CREATE
OR REPLACE VIEW view_manager_with_project AS(
    SELECT
        p.client_id,
        m.manager_id,
        p.project_id
    FROM
        manager m,
        currency_project p,
        manager_with_currency_project mp
    WHERE
        m.manager_id = mp.manager_id
        AND p.project_id = mp.project_id
);

DROP VIEW IF EXISTS view_manager_insurance_project CASCADE;

CREATE
OR REPLACE VIEW view_manager_insurance_project AS(
    SELECT
        DISTINCT mgr.manager_name,
        mgr.manager_phone_number,
        mgr.manager_email_address,
        d.department_name,
        ip.insurance_project_id,
        ip.insurance_project_name,
        ip.insurance_insured,
        ip.insurance_amount,
        ip.insurance_period
    FROM
        manager mgr,
        view_manager_with_project mwp,
        insurance_project ip,
        (
            SELECT
                *
            FROM
                department,
                manager
            WHERE
                manager.manager_department_id = department.department_id
        ) d
    WHERE
        mwp.project_id = ip.project_id
        AND mwp.manager_id = mgr.manager_id
        AND d.department_id = mgr.manager_department_id
    ORDER BY
        ip.insurance_project_id
);

DROP VIEW IF EXISTS view_manager_fund_project CASCADE;

CREATE
OR REPLACE VIEW view_manager_fund_project AS(
    SELECT
        DISTINCT mgr.manager_name,
        mgr.manager_phone_number,
        mgr.manager_email_address,
        d.department_name,
        fp.fund_project_id,
        fp.fund_name,
        fp.fund_type,
        fp.fund_amount,
        fp.fund_income,
        fp.fund_period
    FROM
        manager mgr,
        view_manager_with_project mwp,
        fund_project fp,
        (
            SELECT
                *
            FROM
                department,
                manager
            WHERE
                manager.manager_department_id = department.department_id
        ) d
    WHERE
        mwp.project_id = fp.project_id
        AND mwp.manager_id = mgr.manager_id
        AND d.department_id = mgr.manager_department_id
    ORDER BY
        fp.fund_project_id
);

DROP VIEW IF EXISTS view_manager_financial_project CASCADE;

CREATE
OR REPLACE VIEW view_manager_financial_project AS(
    SELECT
        DISTINCT mgr.manager_name,
        mgr.manager_phone_number,
        mgr.manager_email_address,
        d.department_name,
        fp.financial_project_id,
        fp.financial_project_name,
        fp.financial_project_amount,
        fp.financial_project_income,
        fp.financial_project_period
    FROM
        manager mgr,
        view_manager_with_project mwp,
        financial_project fp,
        (
            SELECT
                *
            FROM
                department,
                manager
            WHERE
                manager.manager_department_id = department.department_id
        ) d
    WHERE
        mwp.project_id = fp.project_id
        AND mwp.manager_id = mgr.manager_id
        AND d.department_id = mgr.manager_department_id
    ORDER BY
        fp.financial_project_id
);