
--2.1. Получение информации о сумме товаров заказанных под каждого клиента (Наименование клиента, сумма)
SELECT 
    Customers.name, 
    COALESCE(SUM(Orders.total_price), 0) AS total
FROM Customers
LEFT JOIN Orders ON Customers.id = Orders.customer_id
GROUP BY Customers.name;


--2.2. Найти количество дочерних элементов первого уровня вложенности для категорий номенклатуры.
SELECT
    parents.id,
    parents.name,
    COALESCE(COUNT(child.id), 0) AS cnt
FROM Categories AS parents
LEFT JOIN Categories AS child ON parents.id = child.parent_id
WHERE parents.parent_id IS NULL
GROUP BY parents.id, parents.name;

--2.3.1. Написать текст запроса для отчета (view) 
--«Топ-5 самых покупаемых товаров за последний месяц» 
--(по количеству штук в заказах). 
--В отчете должны быть: Наименование товара, Категория 1-го уровня, 
--Общее количество проданных штук.

WITH RECURSIVE cnts AS ( 
    SELECT
        OrderItems.product_id,
        SUM(OrderItems.quantity) AS cnt
    FROM Orders
    INNER JOIN OrderItems ON Orders.id = OrderItems.order_id
    WHERE Orders.order_date >= CURRENT_DATE - INTERVAL '1 month'
    GROUP BY OrderItems.product_id
    ORDER BY cnt DESC
    FETCH FIRST 5 ROWS ONLY),
category_path AS (
    SELECT 
        Categories.id,
        Categories.name,
        Categories.parent_id,
        Categories.id AS orig_id,
        Categories.name AS orig_name,
        cnts.cnt AS orig_cnt,
        Products.name AS orig_product_name
    FROM Categories
    JOIN Products ON Categories.id = Products.category_id
    JOIN cnts ON Products.id = cnts.product_id

    UNION ALL

    SELECT 
        Categories.id,
        Categories.name,
        Categories.parent_id,
        category_path.orig_id,
        category_path.orig_name,
        category_path.orig_cnt,
        category_path.orig_product_name
    FROM Categories
    JOIN category_path ON category_path.parent_id = Categories.id
)
SELECT
    orig_product_name AS product_name,
    name AS category_first_lvl,
    orig_cnt AS cnt
FROM category_path
WHERE parent_id is NULL

