#!/bin/bash

# Добавить товар в заказ
echo "Adding product 1 (quantity 2) to order 1:"
curl -X POST "http://localhost:8000/orders/1/add-item" \
     -H "Content-Type: application/json" \
     -d '{"product_id": 1, "quantity": 2}'
echo -e "\n"

# Смотрим, чтобы увеличилось количество, а не появилась новая строка
echo "Adding product 1 (quantity 1) again to order 1 (should increase to 3):"
curl -X POST "http://localhost:8000/orders/1/add-item" \
     -H "Content-Type: application/json" \
     -d '{"product_id": 1, "quantity": 1}'
echo -e "\n"

# Добавляем другой товар в заказ
echo "Adding product 2 (quantity 1) to order 1:"
curl -X POST "http://localhost:8000/orders/1/add-item" \
     -H "Content-Type: application/json" \
     -d '{"product_id": 2, "quantity": 1}'
echo -e "\n"

# Несуществующий order_id
echo "Testing non-existent order (order 999):"
curl -X POST "http://localhost:8000/orders/999/add-item" \
     -H "Content-Type: application/json" \
     -d '{"product_id": 1, "quantity": 1}'
echo -e "\n"

# Несуществующий product_id
echo "Testing non-existent product (product 999):"
curl -X POST "http://localhost:8000/orders/1/add-item" \
     -H "Content-Type: application/json" \
     -d '{"product_id": 999, "quantity": 1}'
echo -e "\n"

# Перебор по количеству
echo "Testing insufficient stock (product 1, quantity 100):"
curl -X POST "http://localhost:8000/orders/1/add-item" \
     -H "Content-Type: application/json" \
     -d '{"product_id": 1, "quantity": 100}'
echo -e "\n"
