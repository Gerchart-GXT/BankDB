CREATE TABLE websites(
    id INT UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    url VARCHAR(1000) NOT NULL,
    PRIMARY KEY(id)
);

INSERT INTO
    websites
VALUES
    ('1', 'openGauss', 'https://opengauss.org/zh/'),
    ('2', '华为云', 'https://www.huaweicloud.com/'),
    ('3', 'openEuler', 'https://openeuler.org/zh/'),
    (
        '4',
        '华为support中心',
        'https://support.huaweicloud.com/'
    );