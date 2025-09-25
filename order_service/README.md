REST API сервис для управления заказами и добавления товаров в заказы, построенный на FastAPI и PostgreSQL.

Функции:
- Добавление товаров в заказы через REST API
- Проверка наличия товара перед добавлением
- Настройка Docker Compose с базой данных PostgreSQL

Модель Данных:

Сервис использует следующие таблицы:
-Номенклатура (Products)
--id (PK)
--name (наименование товара)
--quantity (количество на складе)
--price (цена)
--category_id (FK → Categories.id)


-Каталог (Categories) Adjacency List
--id (PK)
--name (наименование категории)
--parent_id (FK → Categories.id, NULL если корневая категория)


-Клиенты (Customers)
--id (PK)
--name (имя / название клиента)
--address (адрес)


-Заказы (Orders)
--id (PK)
--customer_id (FK → Customers.id)
--order_date (дата заказа)
--total_price (общая сумма заказа)
--status


-Состав заказа (OrderItems)
--id (PK)
--order_id (FK → Orders.id)
--product_id (FK → Products.id)
--quantity (количество в заказе)
--price (фиксируем цену на момент заказа)

Endpoint:
POST /orders/{order_id}/add-item

Добавить товар в заказ.
Тело запроса:
{
  "product_id": 1,
  "quantity": 2
}

Ответ (Успех):
{
  "message": "Item added to order",
  "order_item": {
    "id": 1,
    "quantity": 2
  }
}

Ошибки:
- 404: Заказ/Товар не найден
- 400: Недостаточное количество товара на складе

Запуск
  docker-compose up --build

API будет по адресу http://localhost:8000

База данных по адресу localhost:5432 (пользователь: postgres, пароль: postgres, база: postgres)
