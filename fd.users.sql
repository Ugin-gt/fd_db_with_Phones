DROP TABLE "users";
CREATE TABLE "users" (
  id serial PRIMARY KEY,
  first_name varchar(64) NOT NULL,
  last_name varchar(64) NOT NULL,
  email varchar(256) NOT NULL CHECK (email != ''),
  is_male boolean NOT NULL,
  birthday date NOT NULL CHECK (
    birthday < current_date
    AND birthday > '1900/1/1'
  ),
  height numeric(3, 2) NOT NULL CHECK (
    height > 0.20
    AND height < 2.5
  ),
  CONSTRAINT "CK_FULL_NAME" CHECK (
    first_name != ''
    AND last_name != ''
  )
);
ALTER TABLE "users"
ADD COLUMN "weight" int CHECK (
    "weight" BETWEEN 0 AND 300
  );
/* 
 
 Агрегатные функции
 
 min - вернет минимальное
 max - максимальное
 sum - аккумулятор
 count - считает кол-во кортежей
 avg - среднее значение
 
 */
SELECT avg("height"),
  "is_male"
FROM "users"
WHERE extract(
    'month'
    from age("birthday")
  ) = 1
GROUP BY "is_male";
/* 
 средний рост пользователей
 средний рост мужчин и женщин
 минимальный рост мужчин и женщин
 минимальный, максимальный и средний рост мужчины и женщины
 Кол-во людей родившихся 1 января 1970 года
 Кол-во людей с определённым именем -> John | *
 Кол-во людей в возрасте от 20 до 30 лет
 */
SELECT min(height),
  max(height),
  avg(height),
  "is_male"
FROM "users"
GROUP BY "is_male";
/*  */
SELECT count(*)
FROM "users"
WHERE "birthday" = '1955/08/26';
/*  */
SELECT count(*)
FROM "users"
WHERE extract(
    'year'
    from age("birthday")
  ) BETWEEN 20 AND 30;
/*  */
SELECT *
FROM "users"
WHERE "id" IN (123, 534, 210, 1000, 510, 348);
/*  */
/* phones: brand, model, price, quantity */
/* users can buy phones */
SELECT "id",
  char_length(concat("firstName", '', "lastName")) as "L"
FROM "users"
ORDER by "L" DESC
LIMIT 1;
* / Посчитать кол - во юзеров c количеством символов в полном имени менее 18 * /
SELECT char_length(concat("firstName", '', "lastName")) as "name_length",
  count (*) as "Amount"
FROM "users"
WHERE char_length(concat("firstName", '', "lastName")) < 18
GROUP by "name_length"
ORDER by "Amount" DESC;
* / Посчитать кол - во email юзеров,
начинающиеся на "m" c количеством символов менее 25 * /
SELECT char_length("email") as "email_length",
  count (*) as "Amount"
FROM "users"
WHERE "email" LIKE 'm%'
  AND char_length("email") >= 25
GROUP by "email_length"
ORDER by "Amount" DESC;
* / запрос на вывод таблицы отображения пола пользователя * /
SELECT id,
  "email",
  (
    CASE
      WHEN "isMale" THEN 'Male'
      WHEN NOT "isMale" THEN 'Female'
      ELSE 'not specified'
    END
  ) AS "Gender",
  "isMale"
FROM "users";
* / запрос на вывод совершеннолетия пользователя * /
SELECT *,
  (
    CASE
      WHEN EXTRACT(
        year
        FROM age("birthday")
      ) >= 25 THEN 'Adult'
      ELSE 'Not adult'
    END
  ) AS "Is_Adult"
FROM "users";