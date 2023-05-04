SELECT
    m.manager_name,
    m.manager_phone_number,
    m.manager_email_address,
    count(*) project_count
FROM
    view_manager_with_project mp,
    manager m
WHERE
    m.manager_id = mp.manager_id
GROUP BY
    m.manager_name,
    m.manager_phone_number,
    m.manager_email_address
HAVING
    count(*) >= 3;