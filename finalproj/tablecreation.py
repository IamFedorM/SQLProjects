CREATE TABLE Customers (
    CustomerID VARCHAR(255) PRIMARY KEY,
    Name VARCHAR(255),
    City VARCHAR(255),
    Country VARCHAR(255),
    PostalCode VARCHAR(255),
    CountryCode VARCHAR(255)
);

CREATE TABLE Orders (
    OrderID VARCHAR(255) PRIMARY KEY,
    OrderDate DATE,
    DeliveryDate DATE,
    CustomerID VARCHAR(255),
    Sales DECIMAL(10, 2),
    Quantity INT,
    Discount DECIMAL(10, 2),
    DeliveryCost DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Products (
    ProductID VARCHAR(255) PRIMARY KEY,
    Name VARCHAR(255),
    Price DECIMAL(10, 2),
    Category VARCHAR(255)
);

CREATE TABLE OrderDetails (
    OrderID VARCHAR(255),
    ProductID VARCHAR(255),
    Quantity INT,
    Discount DECIMAL(10, 2),
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
