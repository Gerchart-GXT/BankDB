**1**  **引言**

**1.1**  **编写目的**

  本文档是银行金融数据库管理系统的设计文档，编写该数据库设计文档的目的是明确数据库的表名、字段名等数据信息，方便设计人员进行交流讨论，也指导了后期的数据库脚本的开发。文档的编写遵循数据库课程设计小组作业的要求文档，在数据库中通过 SQL语言编写脚本，实现银行金融数据库管理系统的运营，实现模拟银行经营各类金融产品过程中对客户信息、理财产品的管理。编写此文档更有利于加深开发人员掌握数据库的基础知识、基本理论、实现原理和技术。

**1.2**  **参考资料**

| **资料名称**                         | **资料来源** |
| ------------------------------------ | ------------ |
| 《GaussDB（for openGauss）开发手册》 | 课程资料     |
| openGauss v2.0.0文档                 | 课程资料     |
| 《MES系统操作手册完整版》            | 网页资料     |

**2**  **需求规约**

**2.1** **业务描述**

（1） 数据库系统创建的背景

通过2周的数据库实践课程的学习，本小组掌握并运用openGauss数据库相关知识，为银行设计了一个数据库管理系统，通过将银行管理员分成保险、基金、理财产品三类对以上三种不同的项目进行管理，从而实现银行管理员对客户、银行卡、银行产品、订单等的管理和运作。

（2） 数据库业务流程及工作内容

银行金融数据库管理系统实现模拟银行经营各类金融产品的过程，银行设有三种金融产品：理财产品、保险和基金，客户可以在银行办理银行卡，同时客户可以购买不同的银行产品，如理财产品，基金和保险。银行将客户购买的银行产品统称为客户的资产。银行内不同产品的管理员可对其对应的产品以及购买产品的客户进行管理，产品信息包括产品名称、编号、数额、持续时间及日期，用户信息包括用户的个人身份信息以及用户的资产信息。该数据库依据管理员对银行金融产品以及客户资产的把控，可以实现数据库各表进行增、删、查、改工作。

 

 

 

 

 

**3**  **数据库设计**

**3.1** **概念设计**

**![ER](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image005.gif)**

**3.2** **逻辑设计**

**3.2.1** **属性描述**

①客户（客户编号、客户姓名、客户身份证号、客户联系方式、客户邮箱、客户登陆密码）；

②银行卡（卡片账号、卡片有效期、卡片校验码、卡片密码、客户编号）；

③信用卡（卡片账号、账户余额、信用额度）

④借记卡（卡片账号、账户余额）

⑤理财产品（项目编号、理财项目编号、理财项目名称、理财项目金额、理财项目有效期、理财项目收益、额外信息）；

⑥保险（项目编号、保险项目编号、保险项目名称、投保人身份证号、被保人身份证号、保额、保险有效期、额外信息）；

⑦基金（项目编号、基金项目编号、基金项目名称、基金类型、基金金额、基金收入、基金持有有效期、额外信息）；

⑧资产（客户编号、项目编号、请项目状态）；

⑨经理（经理工号、经理所属部门标号、经理姓名、经理联系方式、经理邮箱、经理密码）

⑩部门（部门标号、部门名称、经理工号）

**3.2.2** **关系描述**

①一个客户可以办理多张银行卡（包括多张信用卡和多张储蓄卡）；

②一个客户可以购买多个理财产品；一个产品经理可以管理多个客户的理财产品，也可以是同一客户的多个理财产品；

③一个客户可以购买多个保险；一个保险经理可以管理多个客户的保险，也可以是同一客户的多个保险；

④一个客户可以购买多个基金；一个基金经理可以管理多个客户的基金，也可以是同一客户的多个基金；

⑤一个客户可以拥有多个资产；一个资产隶属于对应一个类别的金融产品（包括理财产品、保险、基金）；一个资产由对应的一个经理进行管理；

⑥多个管理同一类型金融产品的经理隶属于一个部门；

**3.3**  **物理设计**

| **字段名称**         | **字段类型** | **约束**                                          | **说明**     |
| -------------------- | ------------ | ------------------------------------------------- | ------------ |
| client_id            | INT          | UNIQUE NOT NULL PRIMARY KEY                       | 客户编号     |
| client_name          | VARCHAR(100) | NOT NULL                                          | 客户姓名     |
| client_idnum         | CHAR(18)     | UNIQUE NOT NULL                                   | 客户身份证号 |
| client_phone_number  | CHAR(11)     | NOT NULL                                          | 客户联系方式 |
| client_email_address | VARCHAR(100) | NOT NULL CHECK (client_email_address  LIKE '%@%') | 客户邮箱     |
| client_password      | VARCHAR(100) | NOT NULL CHECK  (length(client_password) > 6)     | 客户登陆密码 |

**表3.1 Client表**

| **字段名称**    | **字段类型** | **约束**                                     | **说明**   |
| --------------- | ------------ | -------------------------------------------- | ---------- |
| client_id       | INT          | NOT NULL PRIMARY KEY   FOREIGN KEY           | 客户编号   |
| card_id         | INT          | UNIQUE NOT NULL PRIMARY KEY                  | 卡片账号   |
| card_valid_thru | DATE         | NOT NULL                                     | 卡片有效期 |
| card_check_code | VARCHAR(20)  | NOT NULL CHECK (length(card_check_code) = 3) | 卡片校验码 |
| card_password   | VARCHAR(20)  | NOT NULL CHECK (length(card_password) = 6)   | 卡片密码   |

**表3.2 Card表**

| **字段名称** | **字段类型**   | **约束**                                  | **说明** |
| ------------ | -------------- | ----------------------------------------- | -------- |
| card_id      | INT            | UNIQUE NOT NULL PRIMARY KEY   FOREIGN KEY | 卡片账号 |
| card_balance | DECIMAL(18, 2) | CHECK (card_balance >= 0)                 | 账户余额 |

**表3.3 Debit_card表**

| **字段名称**      | **字段类型**   | **约束**                                  | **说明** |
| ----------------- | -------------- | ----------------------------------------- | -------- |
| card_id           | INT            | UNIQUE NOT NULL PRIMARY KEY   FOREIGN KEY | 卡片账号 |
| card_balance      | DECIMAL(18, 2) | CHECK (card_balance >= 0)                 | 账户余额 |
| card_credit_limit | DECIMAL(18, 2) | CHECK (card_credit_limit  >= 0)           | 信用额度 |

**表3.4 Credit_card表**

| **字段名称**           | **字段类型** | **约束**                                           | **说明**         |
| ---------------------- | ------------ | -------------------------------------------------- | ---------------- |
| manager_id             | INT          | UNIQUE NOT NULL PRIMARY KEY                        | 经理工号         |
| manager_department_id  | INT          | NOT NULL FOREIGN KEY                               | 经理所属部门标号 |
| manager_name           | VARCHAR(100) | NOT NULL                                           | 经理姓名         |
| manager_phone_number   | VARCHAR(20)  | NOT NULL CHECK (length(manager_phone_number) = 11) | 经理联系方式     |
| manager_email_addressr | VARCHAR(100) | NOT NULL CHECK (manager_email_address LIKE '%@%')  | 经理邮箱         |
| manager_password       | VARCHAR(100) | NOT NULL CHECK (length(manager_password) > 6)      | 经理密码         |

**表3.5 Manager表**

| **字段名称**    | **字段类型** | **约束**                    | **说明** |
| --------------- | ------------ | --------------------------- | -------- |
| manager_id      | INT          | NOT NULL  FOREIGN KEY       | 经理工号 |
| department_id   | INT          | UNIQUE NOT NULL PRIMARY KEY | 部门标号 |
| department_name | VARCHAR(100) | NOT NULL                    | 部门名称 |

**表3.6 Department表**

| **字段名称** | **字段类型** | **约束**                    | **说明** |
| ------------ | ------------ | --------------------------- | -------- |
| project_id   | INT          | UNIQUE NOT NULL PRIMARY KEY | 项目编号 |
| client_id    | INT          | NOT NULL FOREIGN KEY        | 客户编号 |

**表3.7 Currency_project表**

| **字段名称** | **字段类型** | **约束**                    | **说明**     |
| ------------ | ------------ | --------------------------- | ------------ |
| relation_id  | INT          | UNIQUE NOT NULL PRIMARY KEY | 关系编号     |
| project_id   | INT          | NOT NULL FOREIGN KEY        | 项目编号     |
| manager_id   | INT          | NOT NULL FOREIGN KEY        | 项目经理编号 |

**表3.8 manager_with_currency_project表**

| **字段名称**           | **字段类型**   | **约束**                                             | **说明**       |
| ---------------------- | -------------- | ---------------------------------------------------- | -------------- |
| project_id             | INT            | UNIQUE NOT NULL FOREIGN KEY                          | 项目编号       |
| insurance_project_id   | INT            | UNIQUE NOT NULL PRIMARY KEY                          | 保险项目编号   |
| insurance_project_name | VARCHAR(100)   | NOT NULL                                             | 保险项目名称   |
| insurance_policyholder | VARCHAR(20)    | NOT NULL CHECK (length(insurance_policyholder) = 18) | 投保人身份证号 |
| insurance_insured      | VARCHAR(20)    | NOT NULL CHECK (length(insurance_insured) = 18)      | 被保人身份证号 |
| insurance_amount       | DECIMAL(18, 2) | CHECK (insurance_amount >=  0)                       | 保额           |
| insurance_period       | DATE           | NOT NULL                                             | 保险有效期     |
| insurance_detail_etc   | text           | default NULL                                         | 额外信息       |

**表****3.9 insurance_project****表**

| **字段名称**    | **字段类型**   | **约束**                                  | **说明**       |
| --------------- | -------------- | ----------------------------------------- | -------------- |
| project_id      | INT            | UNIQUE NOT NULL PRIMARY KEY   FOREIGN KEY | 项目编号       |
| fund_project_id | INT            | UNIQUE NOT NULL PRIMARY KEY               | 基金项目编号   |
| fund_name       | VARCHAR(100)   | NOT NULL                                  | 基金项目名称   |
| fund_type       | VARCHAR(100)   | NOT NULL                                  | 基金类型       |
| fund_amount     | DECIMAL(18, 2) | CHECK (fund_amount >= 0)                  | 基金金额       |
| fund_income     | DECIMAL(18, 2) | CHECK (fund_income >= 0)                  | 基金收入       |
| fund_period     | DATE           | default NULL                              | 基金持有有效期 |
| fund_detail_etc | text           | default NULL                              | 额外信息       |

**表3.10 Fund_project表**

| **字段名称**                 | **字段类型**   | **约束**                                  | **说明**       |
| ---------------------------- | -------------- | ----------------------------------------- | -------------- |
| project_id                   | INT            | UNIQUE NOT NULL PRIMARY KEY   FOREIGN KEY | 项目编号       |
| financial_project_id         | INT            | UNIQUE NOT NULL                           | 理财项目编号   |
| financial_project_name       | VARCHAR(100)   | NOT NULL                                  | 理财项目名称   |
| financial_project_amount     | DECIMAL(18, 2) | CHECK  (financial_project_amount >= 0)    | 理财项目金额   |
| financial_project_period     | DATE           | NOT NULL                                  | 理财项目有效期 |
| financial_project_income     | DECIMAL(18, 2) | CHECK  (financial_project_income >= 0)    | 理财项目收益   |
| financial_project_detail_etc | text           | default NULL                              | 额外信息       |

**表3.11 Financial_project表**

| **字段名称**  | **字段类型** | **约束**                                                     | **说明** |
| ------------- | ------------ | ------------------------------------------------------------ | -------- |
| client_id     | INT          | NOT NULL FOREIGN KEY                                         | 客户编号 |
| project_id    | INT          | UNIQUE NOT NULL   PRIMARY KEY FOREIGN KEY                    | 项目编号 |
| project_state | VARCHAR(100) | NOT NULL CHECK (      (project_state = 'Active')      OR (project_state = 'Invalid')      OR (project_state = 'Frozen')    ) | 项目状态 |

**表3.12 Property表**

**4**  **数据库实现**

**4.1** 创建数据库表

4.1.1   创建finance数据库作为项目数据库，数据库编码为UTF-8。

postgres=# CREATE DATABASE finance ENCODING 'UTF8';

CREATE DATABASE  

4.1.2   连接finance数据库，创建名为finance的schema，并设置finance为当前的schema。

postgres=# \c finance

You are now connected to database "finance" as user "omm".

finance=# CREATE SCHEMA finance;

CREATE SCHEMA

finance=# SET search_path TO finance

4.1.3   在finance模式下完成金融管理系统中所有数据库对象（数据表）的创建，并完成数据的填充。其中客户数据不少于20条，银行卡数据不少于10条，其他数据不少于5条。

4.1.3.1 建立client表

4.1.3.1.1   结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image007.gif)

4.1.3.1.2   SQL语句

DROP TABLE IF EXISTS client CASCADE;

 

CREATE TABLE client(

  client_id INT UNIQUE NOT NULL,

  client_name VARCHAR(100) NOT NULL,

  client_idnum VARCHAR(20) UNIQUE NOT NULL,

  CHECK (length(client_idnum) = 18), -- 身份证长度 = 18

  client_phone_number VARCHAR(20) NOT NULL,

  CHECK (length(client_phone_number) = 11), -- 手机号长度 = 11

  client_email_address VARCHAR(100) NOT NULL,

CHECK (client_email_address LIKE '%@%'), -- 邮箱地址含有‘@’

  client_password VARCHAR(100) NOT NULL,

  CHECK (length(client_password) > 6), -- 密码长度大于6

  PRIMARY KEY(client_id)

);

4.1.3.2 建立card表

4.1.3.2.1   结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image009.gif)

4.1.3.2.2   SQL语句

DROP TABLE IF EXISTS card CASCADE;

 

CREATE TABLE card(

  client_id INT NOT NULL,

  card_id INT UNIQUE NOT NULL,

  card_valid_thru DATE NOT NULL,

  card_check_code VARCHAR(20) NOT NULL, -- 卡号校验码长度为3

  CHECK (length(card_check_code) = 3),

  card_password VARCHAR(20) NOT NULL,

  CHECK (length(card_password) = 6), -- 密码长度为6

  PRIMARY KEY(client_id, card_id),

  FOREIGN KEY(client_id) REFERENCES client(client_id) ON UPDATE CASCADE ON DELETE CASCADE

);

4.1.3.3 建立debit_card表

4.1.3.3.1   结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image011.gif)

4.1.3.3.2   SQL语句

DROP TABLE IF EXISTS debit_card CASCADE;

 

CREATE TABLE debit_card(

  card_id INT UNIQUE NOT NULL,

  card_balance DECIMAL(18, 2) DEFAULT 0, 

  CHECK (card_balance >= 0), -- 余额非负

  PRIMARY KEY(card_id),

  FOREIGN KEY(card_id) REFERENCES card(card_id) ON UPDATE CASCADE ON DELETE CASCADE

);

4.1.3.4 建立credit_card表

4.1.3.4.1   结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image013.gif)

4.1.3.4.2   SQL语句

DROP TABLE IF EXISTS credit_card CASCADE;

 

CREATE TABLE credit_card(

  card_id INT UNIQUE NOT NULL,

  card_balance DECIMAL(18, 2) DEFAULT 0,

  CHECK (card_balance >= 0), -- 余额非负

  card_credit_limit DECIMAL(18, 2) DEFAULT 0,

  CHECK (card_credit_limit >= 0), -- 信用额度非负

  PRIMARY KEY(card_id),

  FOREIGN KEY(card_id) REFERENCES card(card_id) ON UPDATE CASCADE ON DELETE CASCADE

);

4.1.3.5 建立department 表

4.1.3.5.1   结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image015.gif)

4.1.3.5.2   SQL语句

DROP TABLE IF EXISTS department CASCADE;

​                      

CREATE TABLE department(

  department_id INT UNIQUE NOT NULL,

  department_name VARCHAR(100) NOT NULL,

  PRIMARY KEY(department_id)

);

4.1.3.6 建立manager 表

4.1.3.6.1   结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image017.gif)

4.1.3.6.2   SQL语句

DROP TABLE IF EXISTS manager CASCADE;

 

CREATE TABLE manager(

  manager_id INT UNIQUE NOT NULL,

  manager_department_id INT NOT NULL,

  manager_name VARCHAR(100) NOT NULL,

  manager_phone_number VARCHAR(20) NOT NULL,

  CHECK (length(manager_phone_number) = 11), --手机号长度为11

  manager_email_address VARCHAR(100) NOT NULL,

  CHECK (manager_email_address LIKE '%@%'), --邮箱含有‘@’

  manager_password VARCHAR(100) NOT NULL,

  CHECK (length(manager_password) > 6), --密码长度大于6

  PRIMARY KEY(manager_id),

  FOREIGN KEY(manager_department_id) REFERENCES department(department_id) ON UPDATE CASCADE ON DELETE CASCADE

);

4.1.3.7 建立currency_project表

4.1.3.7.1   结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image019.gif)

4.1.3.7.2   SQL语句

DROP TABLE IF EXISTS currency_project CASCADE;

 

CREATE TABLE currency_project(

  project_id INT UNIQUE NOT NULL,

  client_id INT NOT NULL,

  PRIMARY KEY(project_id),

  FOREIGN KEY(client_id) REFERENCES client(client_id) ON UPDATE CASCADE ON DELETE CASCADE

);

4.1.3.8 建立manager_with_currency_project表

4.1.3.8.1   结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image021.gif)

4.1.3.8.2   SQL语句

DROP TABLE IF EXISTS manager_with_currency_project CASCADE;

 

CREATE TABLE manager_with_currency_project(

  relation_id INT UNIQUE NOT NULL,

  project_id INT NOT NULL,

  manager_id INT NOT NULL,

  PRIMARY KEY(relation_id),

  FOREIGN KEY(project_id) REFERENCES currency_project(project_id) ON UPDATE CASCADE ON DELETE CASCADE,

  FOREIGN KEY(manager_id) REFERENCES manager(manager_id) ON UPDATE CASCADE ON DELETE CASCADE

);

4.1.3.9 建立insurance_project表

4.1.3.9.1   结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image023.gif)

4.1.3.9.2   SQL语句

DROP TABLE IF EXISTS insurance_project CASCADE;

 

CREATE TABLE insurance_project(

  project_id INT UNIQUE NOT NULL,

  insurance_project_id INT UNIQUE NOT NULL,

  insurance_project_name VARCHAR(100) NOT NULL,

  insurance_policyholder VARCHAR(20) NOT NULL,

  CHECK (length(insurance_policyholder) = 18), -- 投保人身份证号为18位

  insurance_insured VARCHAR(20) NOT NULL,

  CHECK (length(insurance_insured) = 18), -- 被保人身份证号为18位

  insurance_amount DECIMAL(18, 2) DEFAULT 0,

  CHECK (insurance_amount >= 0), -- 保额非负

  insurance_period DATE NOT NULL,

  insurance_detail_etc text default NULL,

  PRIMARY KEY(insurance_project_id),

  FOREIGN KEY(project_id) REFERENCES currency_project(project_id) ON UPDATE CASCADE ON DELETE CASCADE

);

4.1.3.10         建立fund_project表

4.1.3.10.1  结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image025.gif)

4.1.3.10.2  SQL语句

DROP TABLE IF EXISTS fund_project CASCADE;

 

CREATE TABLE fund_project(

  project_id INT UNIQUE NOT NULL,

  fund_project_id INT UNIQUE NOT NULL,

  fund_name VARCHAR(100) NOT NULL,

  fund_type VARCHAR(100) NOT NULL,

  fund_amount DECIMAL(18, 2) DEFAULT 0,

  CHECK (fund_amount >= 0), -- 基金额度非负

  fund_income DECIMAL(18, 2) DEFAULT 0,

  CHECK (fund_income >= 0), -- 基金收益非负

  fund_period DATE default NULL,

  fund_detail_etc text default NULL,

  PRIMARY KEY(project_id, fund_project_id),

  FOREIGN KEY(project_id) REFERENCES currency_project(project_id) ON UPDATE CASCADE ON DELETE CASCADE

);

4.1.3.11         建立financial_project表

4.1.3.11.1  结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image027.gif)

4.1.3.11.2  SQL语句

DROP TABLE IF EXISTS financial_project CASCADE;

 

CREATE TABLE financial_project(

  project_id INT UNIQUE NOT NULL,

  financial_project_id INT UNIQUE NOT NULL,

  financial_project_name VARCHAR(100) NOT NULL,

  financial_project_amount DECIMAL(18, 2) DEFAULT 0,

  CHECK (financial_project_amount >= 0), -- 理财项目额度非负

  financial_project_income DECIMAL(18, 2) DEFAULT 0,

  CHECK (financial_project_income >= 0), -- 理财项目收益非负

  financial_project_period DATE NOT NULL,

  financial_project_detail_etc text default NULL,

  PRIMARY KEY(project_id),

  FOREIGN KEY(project_id) REFERENCES currency_project(project_id) ON UPDATE CASCADE ON DELETE CASCADE

);

4.1.3.12         建立property表

4.1.3.12.1  结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image029.gif)

4.1.3.12.2  SQL语句

DROP TABLE IF EXISTS property CASCADE;

 

CREATE TABLE property(

  project_id INT UNIQUE NOT NULL,

  client_id INT NOT NULL,

  project_state VARCHAR(100) NOT NULL DEFAULT 'Active',

  CHECK (

​    (project_state = 'Active')

​    OR (project_state = 'Invalid')

​    OR (project_state = 'Frozen')

  ),

  PRIMARY KEY(project_id),

  FOREIGN KEY(client_id) REFERENCES client(client_id) ON UPDATE CASCADE ON DELETE CASCADE,

  FOREIGN KEY(project_id) REFERENCES currency_project(project_id) ON UPDATE CASCADE ON DELETE CASCADE

);

4.1.3.13         生成数据插入语句并插入数据

编写python脚本生成随机数据插入sql，源文件见“data_made.py”

小数据（各30条）见附件“data_insert_30.sql”

大数据（各100000条）见附件“data_insert_100000.sql”

4.1.3.14         各表内数据展示（小数据）

4.1.3.14.1  插入结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image031.gif)

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image033.gif)

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image035.gif)

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image037.gif)

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image039.gif)

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image041.gif)

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image043.gif)

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image045.gif)

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image047.gif)

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image049.gif)

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image051.gif)

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image053.gif)

**4.2** 创建视图

4.2.1   所有credit_card信息的视图

此视图中展示了所有信用卡的相关信息，包括信用卡的编号，拥有者的编号，信用卡的状态，账户余额，信用额度。

4.2.1.1  结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image055.gif)

4.2.1.2 SQL语句

DROP VIEW IF EXISTS view_card_credit CASCADE;

 

CREATE

OR REPLACE VIEW view_card_credit AS (

  SELECT

​    card.client_id clt_id,

​    card.card_id c_id,

​    card.card_valid_thru c_vald,

​    credit_card.card_balance c_bl,

​    credit_card.card_credit_limit c_crd_lit

  FROM

​    card,

​    credit_card

  WHERE

​    card.card_id = credit_card.card_id

);

4.2.2   所有debit_card信息的视图

此视图中展示了所有储蓄卡的相关信息，包括储蓄卡的编号，拥有者的编号，储蓄卡的状态，账户余额。

4.2.2.1  结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image057.gif)

4.2.2.2 SQL语句

DROP VIEW IF EXISTS view_card_debit CASCADE;

 

CREATE

OR REPLACE VIEW view_card_debit AS (

  SELECT

​    card.client_id clt_id,

​    card.card_id c_id,

​    card.card_valid_thru c_vald,

​    debit_card.card_balance c_bl

  FROM

​    card,

​    debit_card

  WHERE

​    card.card_id = debit_card.card_id

);

4.2.3   所有card信息的视图

此视图中展示了所有银行卡的相关信息，包括信用卡的编号，拥有者的编号，信用卡的状态，账户余额，信用额度，储蓄卡的编号，拥有者的编号，储蓄卡的状态，账户余额。

4.2.3.1  结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image059.gif)

4.2.3.2 SQL语句

DROP VIEW IF EXISTS view_all_card CASCADE;

 

CREATE

OR REPLACE VIEW view_all_card AS (

  select

​    *

  from

​    view_card_credit

  union

  select

​    view_card_debit.clt_id,

​    view_card_debit.c_id,

​    view_card_debit.c_vald,

​    view_card_debit.c_bl,

​    view_card_credit.c_crd_lit

  from

​    view_card_credit

​    right join view_card_debit on view_card_credit.c_id = view_card_debit.c_id

);

4.2.4   所有client拥有的card信息的视图

此视图中展示了所有客户办理银行卡业务的相关信息，包括客户姓名，客户电话，客户电子邮箱，银行卡账号，银行卡有效期，银行卡余额，银行卡（信用卡）信用额度。

4.2.4.1  结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image061.gif)

4.2.4.2 SQL语句

DROP VIEW IF EXISTS view_client_card CASCADE;

 

CREATE

OR REPLACE VIEW view_client_card AS (

  SELECT

​    client.client_name,

​    client.client_phone_number,

​    client.client_email_address,

​    view_all_card.c_id card_id,

​    view_all_card.c_vald card_valid_thru,

​    view_all_card.c_bl card_balance,

​    view_all_card.c_crd_lit card_credit_limit

  FROM

​    client,

​    view_all_card

  WHERE

​    client.client_id = view_all_card.clt_id

);

4.2.5   manager与负责project之间关系的视图

此视图中展示了所有客户资产的相关信息，包括每位客户的资产编号，帮其管理资产的经理的编号以及客户自己的编号。

4.2.5.1  结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image063.gif)

4.2.5.2 SQL语句

DROP VIEW IF EXISTS view_manager_with_project CASCADE;

 

CREATE

OR REPLACE VIEW view_manager_with_project AS(

  SELECT

​    p.client_id,

​    m.manage_id,

​    p.project_id

  FROM

​    manager m,

​    currency_project p,

​    manager_with_currency_project mp

  WHERE

​    m.manage_id = mp.manage_id

​    AND p.project_id = mp.project_id

);

4.2.6   所insurance_manager管理insurance项目视图

此视图中展示了所有保险项目的相关信息，包括保险项目编号，保险项目名称，被保人身份证号，保额，保险有效期及管理对应保险的经理的姓名，电话号码，电子邮箱，所属部门名称。

4.2.6.1  结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image065.gif)

4.2.6.2 SQL语句

DROP VIEW IF EXISTS view_manager_insurance_project CASCADE;

 

CREATE

OR REPLACE VIEW view_manager_insurance_project AS(

  SELECT

​    DISTINCT mgr.manager_name,

​    mgr.manager_phone_number,

​    mgr.manager_email_address,

​    d.department_name,

​    ip.insurance_project_id,

​    ip.insurance_project_name,

​    ip.insurance_insured,

​    ip.insurance_amount,

​    ip.insurance_period,

​    ip.insurance_detail_etc

  FROM

​    manager mgr,

​    view_manager_with_project mwp,

​    insurance_project ip,

​    (

​      SELECT

​        *

​      FROM

​        department,

​        manager

​      WHERE

​        manager.manager_department_id = department.department_id

​    ) d

  WHERE

​    mwp.project_id = ip.project_id

​    AND mwp.manager_id = mgr.manager_id

​    AND d.department_id = mgr.manager_department_id

  ORDER BY

​    ip.insurance_project_id

);

4.2.7   所有fund_manager管理fund项目视图

此视图中展示了所有基金项目的相关信息，包括基金项目编号，基金项目名称，基金项目类型，基金金额，基金收入，基金持有有效期以及管理对应基金项目的经理的姓名，电话号码，电子邮箱，所属部门名称。

4.2.7.1  结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image067.gif)

4.2.7.2 SQL语句

DROP VIEW IF EXISTS view_manager_fund_project CASCADE;

 

CREATE

OR REPLACE VIEW view_manager_fund_project AS(

  SELECT

​    DISTINCT mgr.manager_name,

​    mgr.manager_phone_number,

​    mgr.manager_email_address,

​    d.department_name,

​    fp.fund_project_id,

​    fp.fund_name,

​    fp.fund_type,

​    fp.fund_amount,

​    fp.fund_income,

​    fp.fund_period

  FROM

​    manager mgr,

​    view_manager_with_project mwp,

​    fund_project fp,

​    (

​      SELECT

​        *

​      FROM

​        department,

​        manager

​      WHERE

​        manager.manager_department_id = department.department_id

​    ) d

  WHERE

​    mwp.project_id = fp.project_id

​    AND mwp.manager_id = mgr.manager_id

​    AND d.department_id = mgr.manager_department_id

  ORDER BY

​    fp.fund_project_id

);

4.2.8   所有financial_manager管理financial项目视图

此视图中展示了所有理财产品项目的相关信息，包括理财项目编号，理财项目名称，理财项目金额，理财项目收益，理财项目有效期以及管理对应理财项目的经理的姓名，电话号码，电子邮箱，所属部门名称。

4.2.8.1  结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image069.gif)

4.2.8.2 SQL语句

DROP VIEW IF EXISTS view_manager_financial_project CASCADE;

 

CREATE

OR REPLACE VIEW view_manager_financial_project AS(

  SELECT

​    DISTINCT mgr.manager_name,

​    mgr.manager_phone_number,

​    mgr.manager_email_address,

​    d.department_name,

​    fp.financial_project_id,

​    fp.financial_project_name,

​    fp.financial_project_amount,

​    fp.financial_project_income,

​    fp.financial_project_period

  FROM

​    manager mgr,

​    view_manager_with_project mwp,

​    financial_project fp,

​    (

​      SELECT

​        *

​      FROM

​        department,

​        manager

​      WHERE

​        manager.manager_department_id = department.department_id

​    ) d

  WHERE

​    mwp.project_id = fp.project_id

​    AND mwp.manager_id = mgr.manager_id

​    AND d.department_id = mgr.manager_department_id

  ORDER BY

​    fp.financial_project_id

);

4.2.9   client拥有的insurance项目信息的视图

此视图中展示了所有客户办理保险业务的相关信息，包括保险项目编号，保险项目名称，投保人身份证号，保额，保险项目有效期以及对应的客户的姓名，电话号码，电子邮箱。

4.2.9.1  结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image071.gif)

4.2.9.2 SQL语句

DROP VIEW IF EXISTS view_client_insurance_project CASCADE;

 

CREATE

OR REPLACE VIEW view_client_insurance_project AS(

  SELECT

​    DISTINCT clt.client_name,

​    clt.client_phone_number,

​    clt.client_email_address,

​    ip.insurance_project_id,

​    ip.insurance_project_name,

​    ip.insurance_insured,

​    ip.insurance_amount,

​    ip.insurance_period

  FROM

​    client clt,

​    view_manager_with_project mwp,

​    insurance_project ip

  WHERE

​    mwp.project_id = ip.project_id

​    AND mwp.client_id = clt.client_id

);

4.2.10  client拥有的fund项目信息的视图

此视图中展示了所有客户办理基金项目的相关信息，包括基金项目编号，基金项目名称，基金类型，基金金额，基金有效期以及每个基金项目对应客户的姓名，电话号码，电子邮箱。

4.2.10.1         结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image073.gif)

4.2.10.2         SQL语句

DROP VIEW IF EXISTS view_client_fund_project CASCADE;

 

CREATE

OR REPLACE VIEW view_client_fund_project AS(

  SELECT

​    DISTINCT clt.client_name,

​    clt.client_phone_number,

​    clt.client_email_address,

​    fp.fund_project_id,

​    fp.fund_name,

​    fp.fund_type,

​    fp.fund_amount,

​    fp.fund_period

  FROM

​    client clt,

​    view_manager_with_project mwp,

​    fund_project fp

  WHERE

​    mwp.project_id = fp.project_id

​    AND mwp.client_id = clt.client_id

);

4.2.11  client拥有的financial项目信息的视图

此视图中展示了所有客户办理理财产品项目的相关信息，包括理财项目编号，名称，金额，收益，有效期以及每个理财项目对应的客户姓名，电话号码，电子邮箱。

4.2.11.1         结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image075.gif)

4.2.11.2         SQL语句

DROP VIEW IF EXISTS view_client_financial_project CASCADE;

 

CREATE

OR REPLACE VIEW view_client_financial_project AS(

  SELECT

​    DISTINCT clt.client_name,

​    clt.client_phone_number,

​    clt.client_email_address,

​    fp.financial_project_id,

​    fp.financial_project_name,

​    fp.financial_project_amount,

​    fp.financial_project_income,

​    fp.financial_project_period

  FROM

​    client clt,

​    view_manager_with_project mwp,

​    financial_project fp

  WHERE

​    mwp.project_id = fp.project_id

​    AND mwp.client_id = clt.client_id

);

4.2.12  client拥有所有财产状态的视图

此视图中展示了客户拥有的资产的相关信息，包括资产编号和状态以及资产拥有者的姓名，电话号码，电子邮箱。

4.2.12.1         结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image077.gif)

4.2.12.2         SQL语句

DROP VIEW IF EXISTS view_client_property CASCADE;

 

CREATE

OR REPLACE VIEW view_client_property AS(

  SELECT

​    clt.client_name,

​    clt.client_phone_number,

​    clt.client_email_address,

​    currency_project.project_id,

​    property.project_state

  FROM

​    client clt,

​    property,

​    currency_project

  WHERE

​    currency_project.project_id = property.project_id

​    AND clt.client_id = property.client_id

);

**4.3** 模拟场景，对表中的数据进行查询操作

4.3.1   单表查询

4.3.1.1 查询余额在100000～500000区间内的用户

4.3.1.1.1    结果截图 

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image079.gif)

4.3.1.1.2   SQL语句

SELECT

  *

FROM

  (

​    SELECT

​      *

​    FROM

​      view_client_card

​    EXCEPT

​    SELECT

​      *

​    FROM

​      view_client_card

​    WHERE

​      card_credit_limit > 0

  ) t

WHERE

  t.card_balance >= 100000

  AND t.card_balance <= 500000;

4.3.1.2 查询所有用户拥有信用卡的剩余额度

4.3.1.2.1    结果截图 

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image081.gif)

4.3.1.2.2   SQL语句

select

  client_name,

  client_phone_number,

  client_email_address,

  card_id,

  card_valid_thru,

  card_credit_limit - card_balance card_used_balance

from

  view_client_card

where

  card_credit_limit > 0;

4.3.2   聚合查询

4.3.2.1.1   统计每个department部门中的manager人数

4.3.2.1.2    结果截图 

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image083.gif)

4.3.2.1.3   SQL语句

SELECT

  department.department_name,

  count(*)

FROM

  department,

  manager

WHERE

  department.department_id = manager.manager_department_id

GROUP BY

  department_name

4.3.2.2 查询银行总存款数

4.3.2.2.1    结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image085.gif)

4.3.2.2.2   SQL语句

SELECT 

  sum(view_card_debit.c_bl) amount_sum

FROM 

  view_card_debit;

4.3.2.3 查询所有储户的平均存款

4.3.2.3.1    结果截图 

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image087.gif)

4.3.2.3.2   SQL语句

SELECT 

  avg(view_card_debit.c_bl) amount_avg

FROM 

  view_card_debit;

4.3.3   连接查询

4.3.3.1.1   查询银行所有银行卡信息（credit，debit）

4.3.3.1.2    结果截图 

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image089.gif)

4.3.3.1.3   SQL语句

  select

​    *

  from

​    view_card_credit

  union

  select

​    view_card_debit.clt_id,

​    view_card_debit.c_id,

​    view_card_debit.c_vald,

​    view_card_debit.c_bl,

​    view_card_credit.c_crd_lit

  from

​    view_card_credit

​    right join 

view_card_debit on view_card_credit.c_id = view_card_debit.c_id;

4.3.3.2 查询所有insurance项目所属经理信息

4.3.3.2.1    结果截图 

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image091.gif)

4.3.3.2.2   SQL语句

  SELECT

​    DISTINCT mgr.manager_name,

​    mgr.manager_phone_number,

​    mgr.manager_email_address,

​    d.department_name,

​    ip.insurance_project_id,

​    ip.insurance_project_name,

​    ip.insurance_insured,

​    ip.insurance_amount,

​    ip.insurance_period

  FROM

​    manager mgr,

​    view_manager_with_project mwp,

​    insurance_project ip,

​    (

​      SELECT

​        *

​      FROM

​        department,

​        manager

​      WHERE

​        manager.manager_department_id = department.department_id

​    ) d

  WHERE

​    mwp.project_id = ip.project_id

​    AND mwp.manager_id = mgr.manager_id

​    AND d.department_id = mgr.manager_department_id

4.3.3.3 查询所有insurance项目所属经理信息

4.3.3.3.1    结果截图 

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image093.gif)

4.3.3.3.2   SQL语句

  SELECT

​    DISTINCT mgr.manager_name,

​    mgr.manager_phone_number,

​    mgr.manager_email_address,

​    d.department_name,

​    fp.fund_project_id,

​    fp.fund_name,

​    fp.fund_type,

​    fp.fund_amount,

​    fp.fund_income,

​    fp.fund_period

  FROM

​    manager mgr,

​    view_manager_with_project mwp,

​    fund_project fp,

​    (

​      SELECT

​        *

​      FROM

​        department,

​        manager

​      WHERE

​        manager.manager_department_id = department.department_id

​    ) d

  WHERE

​    mwp.project_id = fp.project_id

​    AND mwp.manager_id = mgr.manager_id

​    AND d.department_id = mgr.manager_department_id

4.3.4   Order by查询

4.3.4.1 按照收益递减顺序查询所有基金项目

4.3.4.1.1    结果截图 

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image095.gif)

4.3.4.1.2   SQL语句

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

4.3.5   Group by 查询

4.3.5.1 查询负责的项目个数三个及三个以上的manager信息

4.3.5.1.1    结果截图 

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image097.gif)

4.3.5.1.2   SQL语句

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

HAVING count(*) >= 3;

**4.4** 创建索引

4.4.1   为debit_card中的card_balance建立索引

4.4.1.1.1   结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image099.gif)

4.4.1.1.2   SQL语句

DROP INDEX IF EXISTS idx_debit_card_id_balance;

CREATE INDEX idx_debit_card_id_balance ON debit_card(card_balance);

4.4.2   为credit_card中的card_balance 和card_credit_limit建立联合索引

4.4.2.1.1   结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image101.gif)

4.4.2.1.2   SQL语句

DROP INDEX IF EXISTS idx_credit_card_id_balance;

CREATE UNIQUE INDEX idx_credit_card_id_balance ON credit_card(card_balance, card_credit_limit);

4.4.3   为insurance_project中的insurance_amount建立索引

4.4.3.1.1   结果截图

4.4.3.1.2   SQL语句

DROP INDEX IF EXISTS idx_insurance_amount;

CREATE INDEX idx_insurance_amount ON insurance_project(insurance_amount);

4.4.4   为fund_project中的fund_amount建立索引

4.4.4.1.1   结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image103.gif)

4.4.4.1.2   SQL语句

DROP INDEX IF EXISTS idx_fund_amount;

CREATE INDEX idx_fund_amount ON fund_project(fund_amount);

4.4.5   为financial_project中的financial_project_amount建立索引

4.4.5.1.1   结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image105.gif)

4.4.5.1.2   SQL语句

DROP INDEX IF EXISTS idx_financial_amount;

CREATE INDEX idx_financial_amount ON financial_project(financial_project_amount);

4.4.6   为fund_project中的fund_income建立索引

4.4.6.1.1   结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image107.gif)

4.4.6.1.2   SQL语句

DROP INDEX IF EXISTS idx_fund_income;

CREATE INDEX idx_fund_income ON fund_project(fund_income);

4.4.7   为financial_project中的financial_project_income建立索引

4.4.7.1.1   结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image109.gif)

4.4.7.1.2   SQL语句

DROP INDEX IF EXISTS idx_financial_income;

CREATE INDEX idx_financial_income ON financial_project(financial_project_income);

**4.5** 数据修改和删除

4.5.1   数据修改

4.5.1.1 将所有fund项目中，项目编号为奇数的项目收益 * 1.05

4.5.1.1.1   结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image111.gif)

4.5.1.1.2   SQL语句

UPDATE

  fund_project

SET

  fund_income = fund_income * 1.05

WHERE

  fund_project_id % 2 = 1;

4.5.1.2 将所有在行debit_card手机最后一位为2， 5， 8， 0的账户赠送其存款额百分之0.1的新年福利

4.5.1.2.1   结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image113.gif)

4.5.1.2.2   SQL语句

UPDATE

  credit_card

SET

  card_balance = card_balance * 1.001

WHERE

  card_id in (

​    SELECT

​      cd.card_id

​    FROM

​      client clt,

​      card cd,

​      credit_card cdt

​    WHERE

​      cd.card_id = cdt.card_id

​      AND cd.client_id = clt.client_id

​      AND (

​        (clt.client_phone_number LIKE '%2')

​        OR (clt.client_phone_number LIKE '%5')

​        OR (clt.client_phone_number LIKE '%8')

​        OR (clt.client_phone_number LIKE '%0')

​      )

  );

4.5.2   数据删除

4.5.2.1 将所有为’Invalid’状态的资产删除

4.5.2.1.1   结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image115.gif)

4.5.2.1.2   SQL语句

DELETE FROM

  currency_project

WHERE

  project_id in(

​    SELECT

​      project_id

​    FROM

​      property

​    WHERE 

​      project_state = 'Invalid'

);

-- 由于project为所有子项目project的来源，收到外键约束，同时有ON UPDATE CASCADE ON DELETE CASCADE，因此只需要删除project中的tuple即可级了连删除所有关联表项中对应数据

4.5.2.2 统计financal部门每位manager负责的所有项目的收益，开除负责项目收益不足financal平均收益*0.5的manager

4.5.2.2.1   结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image117.gif)

4.5.2.2.2   SQL语句

DELETE FROM

  manager

WHERE

  manager_id in (

​    SELECT

​      m.manager_id

​    FROM

​      manager m,

​      (

​        SELECT

​          t1.manager_name

​        FROM

​          (

​            SELECT

​              vmf.manager_name,

​              sum(vmf.financial_project_income) per_total_income

​            FROM

​              view_manager_financial_project vmf

​            GROUP BY

​              vmf.manager_name

​          ) t1,

​          (

​            SELECT

​              avg(at1.per_total_income) avg_total_income

​            FROM

​              (

​                SELECT

​                  vmf.manager_name,

​                  sum(vmf.financial_project_income) per_total_income

​                FROM

​                  view_manager_financial_project vmf

​                GROUP BY

​                  vmf.manager_name

​              ) at1

​          ) t2

​        WHERE

​          t1.per_total_income < t2.avg_total_income * 0.5

​      ) t

​    WHERE

​      m.manager_name = t.manager_name

);

**4.6** 创建新用户

4.6.1   新用户的创建和授权：创建用户dbuser，密码为Gauss#3demo；给用户dbuser授予finance数据库下银行卡信息表的查询和插入权限，并将finance模式的权限也授予dbuser用户

4.6.1.1 结果截图![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image119.gif)

4.6.1.2  SQL语句

CREATE USER dbuser WITH PASSWORD "Gauss#3demo";

GRANT USAGE ON schema finance TO dbuser;

GRANT SELECT, INSERT ON card, credit_card, debit_card TO dbuser;

4.6.2   新用户的创建和授权：创建用户dbuser，密码为Gauss#3demo；给用户dbuser授予finance数据库下银行卡信息表的查询和插入权限，并将finance模式的权限也授予dbuser用户

4.6.2.1 新用户连接数据库：使用新用户连接finance数据库；访问finance数据库的银行卡信息表。

4.6.2.1.1   结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image121.gif)

4.6.2.1.2   执行语句

[omm@db-lab root]$ gsql -d postgres -p 26000 -U dbuser -W Gauss#3demo -r

gsql ((openGauss 2.0.0 build 78689da9) compiled at 2021-03-31 21:03:52 commit 0 last mr )

Non-SSL connection (SSL connection is recommended when requiring high-security)

Type "help" for help.

postgres=> \c finance

Password for user dbuser: 

Non-SSL connection (SSL connection is recommended when requiring high-security)

You are now connected to database "finance" as user "dbuser".

finance=> select * from card;

4.6.3   删除finance模式

4.6.3.1 结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image123.gif)

4.6.3.2 SQL语句

DROP SCHEMA finance

**4.7** 使用JDBC连接openGauss数据库

4.7.1   创建测试数据库demo；创建名为demo的schema，并设置demo为当前的schema；创建测试表websites（id,name,url），数据为（'1', 'openGauss', 'https://opengauss.org/zh/')，('2', '华为云', 'https://www.huaweicloud.com/'), ('3', 'openEuler', 'https://openeuler.org/zh/'), ('4', '华为support中心', 'https://support.huaweicloud.com/')。

4.7.1.1 结果截图

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image125.gif)

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image127.gif)

![img](file:///C:/Users/Gerchart/AppData/Local/Temp/msohtmlclip1/01/clip_image129.gif)

4.7.1.2 SQL语句

CREATE DATABASE demo ENCODING 'UTF8';

CREATE SCHEMA demo;

SET search_path TO demo;

\c demo

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

  ('4','华为support中心','https://support.huaweicloud.com/');

4.7.2   连接openGauss并执行java代码，查询测试表websites的所有数据，并显示在Java控制台

4.7.3   运行结果

 Connecting...

 Initializing Statement Object...

ID: 1, Name: openGauss      , URL: https://opengauss.org/zh/

ID: 2, Name: 华为云      , URL: https://www.huaweicloud.com/

ID: 3, Name: openEuler      , URL: https://openeuler.org/zh/

ID: 4, Name 华为support中心 , URL: https://support.huaweicloud.com/

Goodbye!

**4.7.4** **JAVA Code**

import java.sql.*;

public class demo {

 

  static final String JDBC_DRIVER = "org.postgresql.Driver";

  static final String DB_URL = "jdbc:postgresql://139.9.143.13:26000/demo?ApplicationName=app1";

  static final String USER = "dbuser";

  static final String PASS = "Gauss#3demo";

 

  public static void main(String[] args) {

​    Connection conn = null;

​    Statement stmt = null;

​    try {

​      Class.forName(JDBC_DRIVER);

​      System.out.println("连接数据库...");

​      conn = DriverManager.getConnection(DB_URL, USER, PASS);

​      System.out.println(" 实例化Statement对象...");

​      stmt = conn.createStatement();

​      String sql;

​      sql = "SELECT * FROM demo";

​      ResultSet rs = stmt.executeQuery(sql);

 

​      while (rs.next()) {

​        int id = rs.getInt("id");

​        String name = rs.getString("name");

​        String url = rs.getString("url");

 

​        System.out.print("ID: " + id);

​        System.out.print(", Name: " + name);

​        System.out.print(", URL: " + url);

​        System.out.print("\n");

​      }

​      rs.close();

​      stmt.close();

​      conn.close();

​    } catch (SQLException se) {

​      se.printStackTrace();

​    } catch (Exception e) {

​      e.printStackTrace();

​    } finally {

​      try {

​        if (stmt != null)

​          stmt.close();

​      } catch (SQLException se2) {

​      }

​      try {

​        if (conn != null)

​          conn.close();

​      } catch (SQLException se) {

​        se.printStackTrace();

​      }

​    }

​    System.out.println("Goodbye!");

  }

}
