import psycopg2

def get_connection():
    return pyscopg2.connect(
        hostname='localhost',
        user='root',
        password='Gayu_1999',
        database='devops_db'
    )


def create_table():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS employees (
            id SERIAL PRIMARY KEY,
            name VARCHAR(100),
            age INT,
            department VARCHAR(50)
        )
    ''')
    conn.commit()
    cursor.close()
    conn.close()

def insert_employee(name,age,department):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('''
        INSERT INTO employees (name, age, department)
        VALUES (%s, %s, %s)
    ''', (name, age, department))
    conn.commit()
    cursor.close()
    conn.close()

def get_employees():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM employees')
    rows = cursor.fetchall()
    cursor.close()
    conn.close()
    return rows

def update_employee(emp_id, name=None, age=None, department=None):
    conn = get_connection()
    cursor = conn.cursor()
    fields = []
    values = []
    if name:
        fields.append('name=%s')
        values.append(name)
    if age:
        fields.append('age=%s')
        values.append(age)
    if department:
        fields.append('department=%s')
        values.append(department)
    values.append(emp_id)
    query = f'UPDATE employees SET {", ".join(fields)} WHERE id=%s'
    cursor.execute(query, tuple(values))
    conn.commit()
    cursor.close()
    conn.close()

def delete_employee(emp_id):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('DELETE FROM employees WHERE id=%s', (emp_id,))
    conn.commit()
    cursor.close()
    conn.close()

if __name__ == '__main__':
    create_table()
    insert_employee('Alice', 30, 'HR')
    insert_employee('Bob', 25, 'Engineering')
    print(get_employees())
    update_employee(1, age=31)
    print(get_employees())
    delete_employee(2)
    print(get_employees())
    