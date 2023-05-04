DELETE FROM
    currency_project
WHERE
    project_id in(
        SELECT
            project_id
        FROM
            property
        WHERE
            project_state = 'Invalid'
    );

-- 由于project为所有子项目project的来源，收到外键约束，
-- 同时有ON UPDATE CASCADE ON DELETE CASCADE，
-- 因此只需要删除project中的tuple即可级了连删除所有关联表项中对应数据
DELETE FROM
    manager
WHERE
    manager_id in (
        SELECT
            m.manager_id
        FROM
            manager m,
            (
                SELECT
                    t1.manager_name
                FROM
                    (
                        SELECT
                            vmf.manager_name,
                            sum(vmf.financial_project_income) per_total_income
                        FROM
                            view_manager_financial_project vmf
                        GROUP BY
                            vmf.manager_name
                    ) t1,
                    (
                        SELECT
                            avg(at1.per_total_income) avg_total_income
                        FROM
                            (
                                SELECT
                                    vmf.manager_name,
                                    sum(vmf.financial_project_income) per_total_income
                                FROM
                                    view_manager_financial_project vmf
                                GROUP BY
                                    vmf.manager_name
                            ) at1
                    ) t2
                WHERE
                    t1.per_total_income < t2.avg_total_income * 0.5
            ) t
        WHERE
            m.manager_name = t.manager_name
    );