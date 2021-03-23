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