from flask import Flask, request, jsonify
from flask_cors import CORS
import pyodbc

app = Flask(__name__)
CORS(app)

# Database connection function
def get_connection():
    server = 'DEEQ\\SQLEXPRESS'  # Your server name with escaped backslash
    database = 'LoginDB'         # Your database name

    # Use Windows Authentication (Trusted_Connection)
    conn_str = (
        f'DRIVER={{ODBC Driver 17 for SQL Server}};'
        f'SERVER={server};'
        f'DATABASE={database};'
        f'Trusted_Connection=yes;'
    )

    conn = pyodbc.connect(conn_str)
    return conn

@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')

    try:
        conn = get_connection()
        cursor = conn.cursor()

        cursor.execute(
            "SELECT * FROM Users WHERE username=? AND password=?",
            (username, password)
        )
        user = cursor.fetchone()
        conn.close()

        if user:
            return jsonify({'success': True, 'message': 'Login successful'})
        else:
            return jsonify({'success': False, 'message': 'Invalid credentials'}), 401

    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 500

@app.route('/register', methods=['POST'])
def register_user():
    data = request.get_json()

    full_name = data.get('full_name')
    phone = data.get('phone')
    email = data.get('email')
    address = data.get('address')
    age = data.get('age')

    try:
        conn = get_connection()
        cursor = conn.cursor()

        query = '''
        INSERT INTO register (FullName, Phone, Email, Address, Age)
        VALUES (?, ?, ?, ?, ?)
        '''
        cursor.execute(query, (full_name, phone, email, address, age))
        conn.commit()
        conn.close()

        return jsonify({'success': True, 'message': 'User registered successfully!'}), 200

    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 500
    

@app.route('/transfer', methods=['POST'])
def transfer_money():
    data = request.get_json()

    from_service = data.get('fromService')
    to_service = data.get('toService')
    amount = float(data.get('amount', 0.0))

    if not from_service or not to_service or amount <= 0:
        return jsonify({'error': 'Invalid input'}), 400

    service_charge = round(amount * 0.02, 2)
    net_amount = round(amount - service_charge, 2)

    with get_connection() as conn:
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO Transfers (from_service, to_service, amount, service_charge, net_amount)
            VALUES (?, ?, ?, ?, ?)
        """, (from_service, to_service, amount, service_charge, net_amount))
        conn.commit()

    return jsonify({
        'fromService': from_service,
        'toService': to_service,
        'amount': amount,
        'serviceCharge': service_charge,
        'netAmount': net_amount,
        'status': 'success'
    })


if __name__ == '__main__':
    app.run(debug=True)
