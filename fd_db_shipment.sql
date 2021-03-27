CREATE TABLE "customer"(
  "id" serial PRIMARY KEY,
  "name" varchar(128) NOT NULL,
  "adress" JSONB NOT NULL,
  "email" varchar(256) NOT NULL CHECK (email != ''),
  "phone" char(11) NOT NULL CHECK (phone != ''),
  UNIQUE ("name", "adress", "email", "phone")
);
/*  */
CREATE TABLE "contracts"(
  "contract_id" serial PRIMARY KEY,
  "contract_makeAt" timestamp NOT NULL DEFAULT current_timestamp,
  "customerId" INT REFERENCES "customer"(id),
  UNIQUE ("contract_makeAt")
);
/*  */
CREATE TABLE "products"(
  "code_id" serial PRIMARY KEY,
  "name_product" varchar(128) NOT NULL,
  "description" varchar(256) NOT NULL,
  "price" decimal(10, 2) NOT NULL CHECK (price > 0),
  "av_quantity" int NOT NULL CHECK (av_quantity > 0),
  UNIQUE (name_product, description)
);
/*  */
CREATE TABLE "cast_orders"(
  "order_id" serial PRIMARY KEY,
  "contractId" INT REFERENCES "contracts" ("contract_id"),
  "productId" INT REFERENCES "products"("code_id"),
  "plan_quantity" int NOT NULL CHECK (plan_quantity > 0),
  "order_createdAt" timestamp NOT NULL DEFAULT current_timestamp
);
/*  */
CREATE TABLE "shipment"(
  "shipment_id" serial PRIMARY KEY,
  "orderId_to" INT REFERENCES "cast_orders"(order_id),
  "shipment_createdAt" timestamp NOT NULL DEFAULT current_timestamp,
  "ship_quantity" int NOT NULL CHECK (ship_quantity > 0)
);
/*  */
CREATE TABLE "products_to_orders"(
  "productId" int REFERENCES "products"(code_id),
  "orderId" int REFERENCES "cast_orders"(order_id),
  PRIMARY KEY ("productId", "orderId")
);