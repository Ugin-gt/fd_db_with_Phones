create DATABASE shipment;
/*  */
CREATE TABLE "customer"(
  "id" serial PRIMARY KEY,
  "name" varchar(128) NOT NULL,
  "adress" JSONB NOT NULL,
  "email" varchar(256) NOT NULL CHECK (email != ''),
  "phone" char(11) NOT NULL CHECK (phone != ''),
  UNIQUE ("adress", "email", "phone")
);
/*  */
CREATE TABLE "contracts"(
  "contract_id" serial PRIMARY KEY,
  "customerId" INT REFERENCES "customer"(id),
  "plan_quantity" INT NOT NULL CHECK (plan_quantity > 0),
  "contract_makeAt" timestamp NOT NULL DEFAULT current_timestamp
);
Insert INTO "contracts" ("contract_id", "customerId", "plan_quantity")
VALUES (1, 10, 100),
  (2, 11, 200);
/*  */
CREATE TABLE "products"(
  "code_id" serial PRIMARY KEY,
  "name_product" varchar(128) NOT NULL,
  "description" varchar(256) NOT NULL,
  "price" decimal(10, 2) NOT NULL CHECK (price > 0),
  "av_quantity" int NOT NULL CHECK (av_quantity > 0),
  UNIQUE ("name_product", "description")
);
/*  */
CREATE TABLE "cast_orders"(
  "order_id" serial PRIMARY KEY,
  "contractId" INT REFERENCES "contracts" ("contract_id"),
  "productId" INT REFERENCES "products"("code_id"),
  "order_createdAt" timestamp NOT NULL DEFAULT current_timestamp
);
Insert INTO "cast_orders" ("order_id", "productId")
VALUES (1, 10),
  (2, 10);
/*  */
CREATE TABLE "shipment"(
  "shipment_id" serial PRIMARY KEY,
  "shipment_createdAt" timestamp NOT NULL DEFAULT current_timestamp,
  "ship_quantity" int NOT NULL CHECK (ship_quantity > 0)
);
/*  */
CREATE TABLE "orders_to_shipment"(
  "o_to_ship_id" serial PRIMARY KEY,
  "orderId" int REFERENCES "cast_orders"(order_id),
  "shipmentId" int REFERENCES "shipment"(shipment_id)
);
/*  */
CREATE TABLE "products_to_shipment"(
  "pr_to_ship_id" serial PRIMARY KEY,
  "productId" int REFERENCES "products"(code_id),
  "shipmentId" int REFERENCES "shipment"(shipment_id)
);