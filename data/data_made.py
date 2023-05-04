import random
import radar
import datetime

# global vars
client = []
manager = []
project = []
card = []
relation = []
property = []
department = [[1, "insurance"], [2, "fund"], [3, "finanicial"]]
manager_department = [[0] for _ in range(4)]
property_state = ["Active", "Invalid", "Frozen"]


def get_a_random_str(len, need_1st_bigletter=1):
    s = ''
    for j in range(len):
        letter = random.randint(ord('a'), ord('z'))
        if j == 0 and need_1st_bigletter == True:
            letter += ord('A') - ord('a')
        s = s + chr(letter)
    return s


def get_a_random_num(len):
    s = ''
    for j in range(len):
        letter = random.randint(0, 9)
        s = s + chr(letter + ord('0'))
    return s


def print_insert_sql(source, table_name):
    print("INSERT INTO %s " % table_name)
    print("VALUES ", end='')
    for i in source:
        print("(", end='')
        cnt = 1
        for j in i:
            if not isinstance(j, int):
                print('\'', end='')
                print(j, end='')
                print('\'', end='')
            else:
                print(j, end='')
            if cnt != len(i):
                print(', ', end='')
            cnt += 1
        print(")", end='')
        if i != source[len(source) - 1]:
            print(',')
    print(';')


def client_made(cnt):
    global client
    idnum = set([])
    for i in range(1, cnt + 1):
        client_per = []
        # client_id
        client_per.append(i)
        # client_name
        client_per.append(get_a_random_str(random.randint(3, 8)))
        # client_idnum
        numid = get_a_random_num(18)
        while numid in idnum:
            numid = get_a_random_num(18)
        idnum.add(numid)
        client_per.append(numid)
        # client_phone_number
        client_per.append(get_a_random_num(11))
        # client_email_address
        client_per.append(get_a_random_str(random.randint(5, 10)) +
                          '@' + get_a_random_str(random.randint(5, 10)) + '.' + get_a_random_str(random.randint(3, 5)))
        # client_password
        client_per.append(get_a_random_str(random.randint(2, 5), 0) +
                          get_a_random_num(random.randint(5, 10)))
        client.append(client_per)
    print_insert_sql(client, "client")


def card_made(cnt):
    global client
    global card
    for i in range(1, cnt + 1):
        card_per = []
        # client_id
        client_id = client[random.randint(0, len(client) - 1)][0]
        card_per.append(client_id)
        # card_id
        card_per.append(i)
        # card_valid_thru
        card_per.append(radar.random_date(datetime.date.today(), "2029-12-31"))
        # card_check_code
        card_per.append(get_a_random_num(3))
        # card_password
        card_per.append(get_a_random_num(6))
        card.append(card_per)
        tmp_card = [card_per]
        print_insert_sql(tmp_card, "card")
        if (random.randint(1, 2) == 1):
            debit_card_made(card_per)
        else:
            credit_card_made(card_per)


def credit_card_made(card):
    card_per = []
    # card_id
    card_per.append(card[1])
    # card_balance
    card_balance = round(
        float(random.randint(0, 1000000)) + random.random(), 2)
    card_per.append(card_balance)
    # card_credit_limit
    card_per.append(
        float(int(random.randint(int(card_balance), 1000000) / 1000)*1000))
    tmp_card = [card_per]
    print_insert_sql(tmp_card, "credit_card")


def debit_card_made(card):
    card_per = []
    # card_id
    card_per.append(card[1])
    # card_balance
    card_balance = round(
        float(random.randint(0, 1000000)) + random.random(), 2)
    card_per.append(card_balance)
    tmp_card = [card_per]
    print_insert_sql(tmp_card, "debit_card")


def manager_made(cnt):
    global manager, manager_department
    idnum = set([])
    for i in range(1, cnt + 1):
        manager_per = []
        # manager_id
        manager_per.append(i)
        # manager_department
        dep_id = random.randint(1, 3)
        manager_department[dep_id].append(i)
        manager_per.append(dep_id)
        # manager_name
        manager_per.append(get_a_random_str(random.randint(3, 8)))
        # manager_phone_number
        manager_per.append(get_a_random_num(11))
        # manager_email_address
        manager_per.append(get_a_random_str(random.randint(5, 10)) +
                           '@' + get_a_random_str(random.randint(5, 10)) + '.' + get_a_random_str(random.randint(3, 5)))
        # manager_password
        manager_per.append(get_a_random_str(random.randint(2, 5), 0) +
                           get_a_random_num(random.randint(5, 10)))
        manager.append(manager_per)
    print_insert_sql(manager, "manager")


def currency_project_made(cnt):
    global project, client, manager, relation
    project_client_id = [0] * (cnt + 1)
    project_type = [0] * (cnt + 1)
    # relation_id
    relation_id = 1
    for i in range(1, cnt + 1):
        # ith project has $cnt_manager managers
        client_id = random.randint(1, len(client) - 1)
        project_client_id[i] = client_id
        project_id = i
        project_per = []
        # project_id
        project_per.append(project_id)
        # client_id
        project_per.append(client_id)
        project.append(project_per)
        # property
        property.append(
            [project_id, client_id, property_state[random.randint(0, 2)]])
        # manager_with_currency_project
        manager_id = set([])
        per_type = random.randint(1, 3)
        while len(manager_department[per_type]) < 1:
            per_type = random.randint(1, 3)
        project_type[i] = per_type
        cnt_manager = random.randrange(
            1, min(3, len(manager_department[per_type]) - 1))
        for _ in range(cnt_manager):
            # manager_id
            mid = manager_department[per_type][random.randint(
                1, len(manager_department[per_type]) - 1)]
            while mid in manager_id:
                mid = manager_department[per_type][random.randint(
                    1, len(manager_department[per_type]) - 1)]
            manager_id.add(mid)
            relation.append([relation_id, project_id, mid])
            relation_id += 1
    print_insert_sql(project, "currency_project")
    insurance_idx = 1
    fund_idx = 1
    financial_idx = 1
    for i in range(1, cnt + 1):
        project_kind = project_type[i]
        if project_kind == 1:
            # insurance_project
            project_per = []
            # project_id
            project_per.append(i)
            # insurance_project_id
            project_per.append(insurance_idx)
            # insurance_project_name
            project_per.append(get_a_random_str(
                random.randint(5, 10)))
            # insurance_policyholder (uid)
            project_per.append((client[project_client_id[i] - 1])[2])
            # insurance_insured
            project_per.append((client[random.randint(0, len(client) - 1)])[2])
            # insurance_amount
            project_per.append(
                float(int(random.randint(int(1000), 1000000) / 1000)*1000))
            # insurance_period
            project_per.append(
                radar.random_date(datetime.date.today(), "2029-12-31"))
            # insurance_detail_etc
            project_per.append(get_a_random_str(random.randint(100, 500)))
            tmp = [project_per]
            print_insert_sql(tmp, "insurance_project")
            insurance_idx += 1
        elif project_kind == 2:
            # fund_project
            project_per = []
            # project_id
            project_per.append(i)
            # fund_project_id
            project_per.append(fund_idx)
            # fund_name
            project_per.append(get_a_random_str(
                random.randint(5, 10)))
            # fund_type
            project_per.append(get_a_random_str(5))
            # fund_amount
            project_per.append(
                float(int(random.randint(int(1000), 1000000) / 1000)*1000))
            # fund_income
            project_per.append(round(
                float(random.randint(0, 1000000)) + random.random(), 2))
            # fund_period
            project_per.append(
                radar.random_date(datetime.date.today(), "2029-12-31"))
            # fund_detail_etc
            project_per.append(get_a_random_str(random.randint(100, 500)))
            tmp = [project_per]
            print_insert_sql(tmp, "fund_project")
            fund_idx += 1
        else:
            # financial_project
            project_per = []
            # project_id
            project_per.append(i)
            # financial_project_id
            project_per.append(financial_idx)
            # financial_project_name
            project_per.append(get_a_random_str(5, 20))
            # financial_project_amount
            project_per.append(
                float(int(random.randint(int(1000), 1000000) / 1000)*1000))
            # financial_income
            project_per.append(round(
                float(random.randint(0, 1000000)) + random.random(), 2))
            # financial_project_period
            project_per.append(
                radar.random_date(datetime.date.today(), "2029-12-31"))
            # financial_project_detail_etc
            project_per.append(get_a_random_str(random.randint(100, 500)))
            tmp = [project_per]
            print_insert_sql(tmp, "financial_project")
            financial_idx += 1
    print_insert_sql(relation, "manager_with_currency_project")


def main():
    client_cnt = 100000
    card_cnt = 100000
    manager_cnt = 100000
    currency_project_cnt = 100000
    # client
    client_made(client_cnt)
    # card
    card_made(card_cnt)
    # department
    global department
    print_insert_sql(department, "department")
    # manager
    manager_made(manager_cnt)
    # currency_project
    currency_project_made(currency_project_cnt)
    print_insert_sql(property, "property")


main()
