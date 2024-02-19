pip install mysql-connector-python

import mysql.connector

db_connection = mysql.connector.connect(
  host="your_host",
  user="your_username",
  password="your_password",
  database="little_lemon"
)
db_cursor = db_connection.cursor()

def add_booking(customer_id, order_date, delivery_date, sales, quantity, discount, delivery_cost):
    add_order_query = """
    INSERT INTO Orders (OrderDate, DeliveryDate, CustomerID, Sales, Quantity, Discount, DeliveryCost)
    VALUES (%s, %s, %s, %s, %s, %s, %s)
    """
    order_values = (order_date, delivery_date, customer_id, sales, quantity, discount, delivery_cost)
    
    db_cursor.execute(add_order_query, order_values)
    db_connection.commit()
    
    print(f"Booking added for customer {customer_id}.")

def update_booking(order_id, new_delivery_date=None, new_sales=None):
    update_query = "UPDATE Orders SET "
    update_params = []
    
    if new_delivery_date:
        update_query += "DeliveryDate = %s, "
        update_params.append(new_delivery_date)
    
    if new_sales:
        update_query += "Sales = %s, "
        update_params.append(new_sales)
    
    # Remove trailing comma and space
    update_query = update_query.rstrip(', ')
    
    update_query += " WHERE OrderID = %s"
    update_params.append(order_id)
    
    db_cursor.execute(update_query, tuple(update_params))
    db_connection.commit()
    
    print(f"Booking {order_id} updated.")

add_booking('123456', '2023-01-01', '2023-01-03', 200.00, 2, 10.00, 20.00)
update_booking('order123', new_delivery_date='2023-02-01', new_sales=250.00)
