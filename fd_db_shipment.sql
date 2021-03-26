
CREATE TABLE "customer"(
  id serial PRIMARY KEY,
  name varchar(128) NOT NULL,
  adress JSONB NOT NULL,
  email varchar(256) NOT NULL CHECK (email != ''),
  phone char(11) NOT NULL CHECK (phone != '')
  );

CREATE TABLE "contracts"(
  contract_id serial PRIMARY KEY,
  "contract_makeAt" timestamp NOT NULL DEFAULT current_timestamp,
  "customerId" REFERENCES "customer"(id)
);

CREATE TABLE "products"(
  code_id serial PRIMARY KEY,
  name_product varchar(128) NOT NULL,
  description varchar(256) NOT NULL,
  price decimal(10, 2) NOT NULL CHECK (price > 0),
  quantity int NOT NULL CHECK (quantity > 0),
  UNIQUE(name_product, description)
);

CREATE TABLE "orders"(
  order_id serial PRIMARY KEY,
  "customerId" REFERENCES "customer"(id),
  "customerAdress" REFERENCES "customer"(adress),
  "customerPhone" REFERENCES "customer"(phone),
  "order_createdAt" timestamp NOT NULL DEFAULT current_timestamp
);

CREATE TABLE "shipment"(
  shipment_id serial PRIMARY KEY,
  "orderId_to" REFERENCES "orders"(order_id),
  "shipment_createdAt" timestamp NOT NULL DEFAULT current_timestamp,
  ship_quantity int NOT NULL CHECK (ship_quantity > 0)
);

/*  */
CREATE TABLE "products_to_orders"(
  "productId" int REFERENCES "products"(code_id),
  "orderId" int REFERENCES orders"(order_id),
  PRIMARY KEY ("productId","orderId")
)
