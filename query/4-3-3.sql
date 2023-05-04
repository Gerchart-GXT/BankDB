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
    right join view_card_debit on view_card_credit.c_id = view_card_debit.c_id;

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
    AND d.department_id = mgr.manager_department_id;

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