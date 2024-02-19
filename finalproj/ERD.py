# I have some problems with accessing the MySQL workbench model, so i will show you how to do this via Python manually:
# Use `pip install graphviz` if you haven't installed it yet.

from graphviz import Digraph

# Create a new directed graph for our ERD
dot = Digraph(comment='The ERD of Little Lemon Booking System')

# Adding entities (as nodes)
dot.node('C', 'Customers')
dot.node('O', 'Orders')
dot.node('P', 'Products')
dot.node('OD', 'OrderDetails')

# Adding relationships (as edges)
dot.edge('C', 'O', label='1..N')
dot.edge('O', 'OD', label='1..N')
dot.edge('P', 'OD', label='1..N')

# Print the source code for the diagram
print(dot.source)

# Save and render the graph to a file (the rendering part may not work in this notebook directly)
# dot.render('test-output/erd_diagram.gv', view=True)
'''
Entities and Attributes

Customers
Customer ID (Primary Key)
Name
City
Country
Postal Code
Country Code
Orders
Order ID (Primary Key)
Order Date
Delivery Date
Customer ID (Foreign Key, references Customers)
Sales
Quantity
Discount
Delivery Cost
Products (For simplicity, combining all product-related aspects into one entity, but this can be normalized further)
Product ID (Primary Key)
Name (Could represent Course Name, Cuisine Name, etc.)
Price (Assuming a simplified attribute for representing the cost of each product or service)
Category (e.g., Starter, Main Course, Dessert, Drink, Side)
Relationships

Customers to Orders: One-to-Many (A single customer can place multiple orders over time)
Orders to Products: Many-to-Many (An order can include multiple products, and a product can appear in multiple orders. 
This necessitates a junction table, perhaps named OrderDetails, to capture the relationship between Orders and Products, 
including attributes like Quantity per product within an order, and possibly a specific discount applied to that product in the context of the order.)

'''
