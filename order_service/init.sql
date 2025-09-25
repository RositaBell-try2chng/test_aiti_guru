CREATE TABLE Categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    parent_id INTEGER REFERENCES Categories(id)
);

CREATE TABLE Products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    quantity INTEGER NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    category_id INTEGER REFERENCES Categories(id)
);

CREATE TABLE Customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address TEXT
);

CREATE TABLE Orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES Customers(id),
    order_date DATE NOT NULL,
    total_price DECIMAL(10,2) DEFAULT 0,
    status VARCHAR(50)
);

CREATE TABLE OrderItems (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES Orders(id),
    product_id INTEGER NOT NULL REFERENCES Products(id),
    quantity INTEGER NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

INSERT INTO Categories (name, parent_id) VALUES
('Electronics', NULL),
('Clothing', NULL),
('Smartphones', 1),
('Laptops', 1);

INSERT INTO Products (name, quantity, price, category_id) VALUES
('iPhone 12', 10, 999.99, 3),
('MacBook Pro', 5, 1999.99, 4),
('T-Shirt', 20, 19.99, 2),
('Jeans', 15, 49.99, 2);

INSERT INTO Customers (name, address) VALUES
('John Doe', '123 Main St'),
('Jane Smith', '456 Elm St');

INSERT INTO Orders (customer_id, order_date, total_price, status) VALUES
(1, CURRENT_DATE, 0, 'pending'),
(2, CURRENT_DATE, 0, 'pending');
