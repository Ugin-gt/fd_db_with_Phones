/* 
 Типы ассоциации
 
 1 => : <= 1 
 1  : <= m   
 m : <= m_to_n => : n
 
 <= - REFERENCES
 */
CREATE TABLE "phones"(
  id serial PRIMARY KEY,
  brand varchar(64) NOT NULL,
  model varchar(64) NOT NULL,
  price decimal(10, 2) NOT NULL CHECK (price > 0),
  quantity int NOT NULL CHECK (quantity > 0),
  UNIQUE(brand, model)
);
/*  */
CREATE TABLE "orders"(
  id serial PRIMARY KEY,
  "createdAt" timestamp NOT NULL DEFAULT current_timestamp,
  "userId" REFERENCES "users"(id)
);
/*  */
CREATE TABLE "users_to_orders"(
  "orderId" int REFERENCES "orders"(id),
  "userId" int REFERENCES "users"(id),
  quantity int NOT NULL,
  PRIMARY KEY ("orderId", "userId")
)
/*  Посчитать кол-во телефонов, которые были проданы  */
SELECT sum(quantity)
FROM phones_to_orders;

/* количество телефонов на складе */
SELECT sum(quantity)
FROM "phones";

/* средняя цена телефонов на складе */
SELECT avg(price)
FROM "phones";

/* средняя цена каждого бренда на складе */
SELECT avg(price), "brand"  
FROM "phones"
GROUP BY "brand";

/* стоимость всех телефонов в диапазоне от 10К до 20К */

SELECT sum(price*quantity) AS "Sum", "brand"  
FROM "phones"
WHERE "price" BETWEEN 10000 AND 20000
GROUP BY "brand";

/* Количество моделей каждого бренда */

SELECT count(model),"brand"  
FROM "phones"
GROUP BY "brand";

/* Узнать каких model телефонов осталось меньше всего*/

 SELECT min(quantity), "model", "brand"  
 FROM "phones"
 GROUP BY "brand","model" ;

/* Узнать каких телефонов какого бренда осталось меньше всего*/

 SELECT sum(quantity) as "sum_Quantity", "brand" FROM "phones" 
 GROUP BY "brand"
 ORDER BY "sum_Quantity", "brand";

/* Сортировать пользователей по возрасту и по имени*/
 SELECT "firstName", EXTRACT('year' FROM age("birthday")) AS "age" FROM "users"
 ORDER BY "age", "firstName";

 /* Фильтрация телефонов по количеству свыше 70К и бренду*/
SELECT sum(quantity) as "sum_Quantity", "brand" FROM "phones" 
GROUP BY "brand"
HAVING sum(quantity) >80000
ORDER BY "sum_Quantity", "brand";

 /* Извлечь все телефоны конкретного заказа*/

SELECT pto."orderId", p."brand", p."model", pto."quantity"
FROM "phones_to_orders" AS pto
JOIN "phones" as p ON p.id = pto."phoneId"
ORDER BY pto."orderId", pto."quantity" DESC;

/* Количество заказов каждого пользователя и его мыло*/

SELECT u.id AS "USER_ID", u."firstName", count(o.id) as "orders_Quantity", u."email"
FROM "users" AS u
LEFT JOIN "orders" as o ON o."userId" = u.id
GROUP BY "USER_ID"
ORDER BY "USER_ID","orders_Quantity" DESC;

/* Количество позиций товара в определеном заказе*/

SELECT pto."orderId", count(pto."phoneId") as "Positions_Quantity"
FROM "phones_to_orders" AS pto
GROUP BY pto."orderId"
ORDER BY pto."orderId","Positions_Quantity" DESC;

/* Извлечь самый популярный телефон*/

SELECT p."brand", p."model", sum(pto.quantity) as "Most_popular"
FROM "phones_to_orders" AS pto
JOIN "phones" as p ON p.id = pto."phoneId"
GROUP BY p."brand", p."model"
ORDER BY "Most_popular" DESC
LIMIT 1;

/* Извлечь пользователей и кол-во моделей которые они покупали*/

SELECT  o."userId", o.id as "Order_ID", count(pto."phoneId") as "Amount models"
FROM "phones_to_orders" AS pto
JOIN "orders" as o ON o.id = pto."orderId"
GROUP BY o."userId","Order_ID"
ORDER BY o."userId","Amount models" DESC;

/* Извлечь все заказы стоимостью выше среднего чека*/

SELECT pto."orderId", sum(pto.quantity*p.price) as "Order_Total_Sum"
FROM "phones_to_orders" AS pto
JOIN "phones" as p ON p.id = pto."phoneId"
GROUP BY pto."orderId"
ORDER BY "Order_Total_Sum" DESC

-- HAVING sum(pto.quantity*p.price) >
SELECT avg("Order_Total_Sum")
FROM (SELECT pto."orderId", sum(pto.quantity*p.price) as "Order_Total_Sum"
FROM "phones_to_orders" AS pto
JOIN "phones" as p ON p.id = pto."phoneId"
GROUP BY pto."orderId") AS "AVG_Order_Sum"

/* Извлечь всех пользователей, у которых кол-во заказов выше среднего*/

SELECT u.id, u."firstName", count(o.id) as "User_Order_Count"
FROM "users" AS u
JOIN "orders" as o ON u.id = o."userId"
GROUP BY u.id
ORDER BY u.id
-- HAVING count(o.id) > 

SELECT avg("User_Order_Count")
FROM (SELECT u.id, count(o.id) as "User_Order_Count"
FROM "users" AS u
JOIN "orders" as o ON u.id = o."userId"
GROUP BY u.id) AS "AVG_Order_Count"



