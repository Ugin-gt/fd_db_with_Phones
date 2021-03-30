CREATE TABLE "users" (
  id serial PRIMARY KEY,
  "first_name" varchar(64) NOT NULL,
  "last_name" varchar(128) NOT NULL,
  "login" VARCHAR (64) NOT NULL CHECK (login != ''),
  "email" varchar(64) NOT NULL CHECK (email != '') -- "password" VARCHAR (64) NOT NULL
);
/*     */
CREATE TABLE "employees" (
  "id_emp" serial PRIMARY KEY,
  "position" varchar(64) NOT NULL,
  "salary" NUMERIC(10, 2) CHECK (salary > 0),
  "department" varchar(128) NOT NULL CHECK (department != ''),
  "hire_date" TIMESTAMP NOT NULL DEFAULT current_timestamp
);
ALTER TABLE users DROP COLUMN password;
/*  */
ALTER TABLE users
ADD password_hash text NOT NULL CHECK (password_hash != '');
/*  */
ALTER TABLE employees
ADD user_id INT REFERENCES users(id);
/*  */
INSERT INTO employees (position, salary, department, user_id)
VALUES (
    'senior developer',
    10000,
    'development',
    1
  ),
  (
    'junior developer',
    5000,
    'development',
    2
  ),
  ('HR top', 10000, 'HR Dep', 3),
  ('HR manager', 7000, 'HR Dep', 4);
TRUNCATE TABLE employees;
/*     */
INSERT INTO users (
    first_name,
    last_name,
    login,
    email
  )
VALUES (
    'Jacke',
    'Drop',
    'jacke_drop',
    'jacke99@mail.com'
  ),
  (
    'Jonh',
    'Doe',
    'john_doe',
    'doe275@mail.com'
  ),
  (
    'Anna',
    'Smith',
    'ann_sm',
    'ann25@mail.com'
  ),
  (
    'Alex',
    'Beam',
    'alex_beam',
    'alex89@mail.com'
  ),
  (
    'Samanta',
    'Doe',
    'sam_doe',
    'sam_doe95@mail.com'
  );
/* */
SELECT u.*,
  COALESCE(e.salary, 0) as "user_salary"
FROM users as u
  LEFT JOIN employees as e on u.id = e.user_id;
/* */
SELECT u.*,
  COALESCE(e.position, null) as "user_whithout_job"
FROM users as u
  LEFT JOIN employees as e on u.id = e.user_id;
/* */
SELECT u.*
FROM users as u
WHERE u.id NOT IN (
    SELECT e.user_id
    from employees as e
  );

  /* 
 WINDOW FUNCTIONS 
 */
CREATE SCHEMA wf;
/*  */
CREATE TABLE wf.employees(
  id serial PRIMARY KEY,
  "name" varchar(256) NOT NULL CHECK("name" != ''),
  salary numeric(10, 2) NOT NULL CHECK (salary >= 0),
  hire_date timestamp NOT NULL DEFAULT current_timestamp
);
/*  */
CREATE TABLE wf.departments(
  id serial PRIMARY KEY,
  "name" varchar(64) NOT NULL
);
/*  */
ALTER TABLE wf.employees
ADD COLUMN department_id int REFERENCES wf.departments;
/*  */
INSERT INTO wf.departments("name")
VALUES ('SALES'),
  ('HR'),
  ('DEVELOPMENT'),
  ('QA'),
  ('TOP MANAGEMENT');
INSERT INTO wf.employees ("name", salary, hire_date, department_id)
VALUES ('TEST TESTov', 10000, '1990-1-1', 1),
  ('John Doe', 6000, '2010-1-1', 2),
  ('Matew Doe', 3456, '2020-1-1', 2),
  ('Matew Doe1', 53462, '2020-1-1', 3),
  ('Matew Doe2', 124543, '2012-1-1', 4),
  ('Matew Doe3', 12365, '2004-1-1', 5),
  ('Matew Doe4', 1200, '2000-8-1', 5),
  ('Matew Doe5', 2535, '2010-1-1', 2),
  ('Matew Doe6', 1000, '2014-1-1', 3),
  ('Matew Doe6', 63456, '2017-6-1', 1),
  ('Matew Doe7', 1000, '2020-1-1', 3),
  ('Matew Doe8', 346434, '2015-4-1', 2),
  ('Matew Doe9', 3421, '2018-1-1', 3),
  ('Matew Doe0', 34563, '2013-2-1', 5),
  ('Matew Doe10', 2466, '2011-1-1', 1),
  ('Matew Doe11', 9999, '1999-1-1', 5),
  ('TESTing 1', 1000, '2019-1-1', 2);
/*  */
SELECT d.name,
  count(e.id)
FROM wf.departments d
  JOIN wf.employees e ON e.department_id = d.id
GROUP BY d.id;
/*  */
SELECT e.*,
  d.name
FROM wf.departments d
  JOIN wf.employees e ON e.department_id = d.id
  /*  */
SELECT avg(e.salary),
  d.id
FROM wf.departments d
  JOIN wf.employees e ON e.department_id = d.id
GROUP BY d.id;
/* JOIN
 user|dep|avg dep salary
 
 */
SELECT e.*,
  d.name,
  "d_a_s"."avg_salary"
FROM wf.departments d
  JOIN wf.employees e ON e.department_id = d.id
  JOIN (
    SELECT avg(e.salary) AS "avg_salary",
      d.id
    FROM wf.departments d
      JOIN wf.employees e ON e.department_id = d.id
    GROUP BY d.id
  ) AS "d_a_s" ON d.id = d_a_s.id;
  
  /* WINDOW FUNC 
   user|dep|avg dep salary
   */
SELECT e.*,
  d.name,
  round(avg(e.salary) OVER (PARTITION BY d.id)) as "avg_dep_salary",
  avg(e.salary) OVER ()
FROM wf.departments d
  JOIN wf.employees e ON e.department_id = d.id;
  
/* сумма зарплаты на кажый отдел и для всей компании в сводном запросе */
  SELECT e.*,
  d.name,
  round(sum(e.salary) OVER (PARTITION BY d.id)) as "sum_dep_salary",
  sum(e.salary) OVER ()
FROM wf.departments d
  JOIN wf.employees e ON e.department_id = d.id;