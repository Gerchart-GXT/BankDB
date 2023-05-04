SELECT
    department.department_name,
    count(*)
FROM
    department,
    manager
WHERE
    department.department_id = manager.manager_department_id
GROUP BY
    department_name;

SELECT
    avg(view_card_debit.c_bl) amount_avg
FROM
    view_card_debit;