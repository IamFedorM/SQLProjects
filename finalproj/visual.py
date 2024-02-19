# Import necessary libraries
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Assuming you've already installed matplotlib, if not you can install it using pip:
# pip install matplotlib

# Generate dummy data
np.random.seed(0)  # For reproducible outputs

# Booking trends over time dummy data
dates = pd.date_range(start="2021-01-01", end="2021-12-31", freq="M")
bookings = np.random.randint(50, 200, size=len(dates))

# Top products by sales dummy data
products = ['Product A', 'Product B', 'Product C', 'Product D', 'Product E']
sales = np.random.randint(500, 1000, size=len(products))

# Customer demographics dummy data
countries = ['Country A', 'Country B', 'Country C', 'Country D']
bookings_by_country = np.random.randint(100, 400, size=len(countries))

plt.figure(figsize=(10, 6))
plt.plot(dates, bookings, marker='o', linestyle='-', color='b')
plt.title('Booking Trends Over Time')
plt.xlabel('Month')
plt.ylabel('Number of Bookings')
plt.grid(True)
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()

plt.figure(figsize=(10, 6))
plt.bar(products, sales, color='green')
plt.title('Top Products by Sales')
plt.xlabel('Product')
plt.ylabel('Sales')
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()

plt.figure(figsize=(8, 8))
plt.pie(bookings_by_country, labels=countries, autopct='%1.1f%%', startangle=140)
plt.title('Booking Distribution by Country')
plt.show()

