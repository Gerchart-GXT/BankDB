SELECT
    fp.fund_name,
    fp.fund_amount,
    fp.fund_income
FROM
    currency_project cp,
    fund_project fp
WHERE
    cp.project_id = fund_project_id
ORDER BY
    fp.fund_income desc;