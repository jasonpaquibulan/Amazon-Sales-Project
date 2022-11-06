SELECT * FROM order_logs

-- DATA CLEANING
-- CHANGE COLUMN NAME
-- ALL SHOULD BE ON LOWERCASE
-- FILL IN NULL VALUES
-- REMOVE DUPLICATES

-- DATA CLEANING
-- CHANGE COLUMN NAME

ALTER TABLE order_logs
RENAME COLUMN "Product Name" to product_name

ALTER TABLE order_logs
RENAME COLUMN "Order number" to order_number

ALTER TABLE order_logs
RENAME COLUMN "Real Production End Date" to real_production_end_date

ALTER TABLE order_logs
RENAME COLUMN "Market Place" to market_place

ALTER TABLE order_logs
RENAME COLUMN "Quantity" to quantity

ALTER TABLE order_logs
RENAME COLUMN "Shipping Cost/Unit" to shipping_cost_per_unit

ALTER TABLE order_logs
RENAME COLUMN "Production Cost/Unit" to production_cost_per_unit


ALTER TABLE order_logs
RENAME COLUMN "Total Cost/Unit (COGS)" to total_cost_per_unit_cogs

ALTER TABLE order_logs
RENAME COLUMN "total_order_cost" to total_order_cost

SELECT * FROM order_logs

ALTER TABLE order_logs
RENAME COLUMN "Production Lead Time (Days)" to production_lead_time_days

ALTER TABLE order_logs
RENAME COLUMN "Production Should be Ready in" to production_should_be_ready_in

ALTER TABLE order_logs
RENAME COLUMN "Estimated Departure Date" to estimated_departure_date


ALTER TABLE order_logs
RENAME COLUMN "Expected Arrival Date" to expected_arrival_date


ALTER TABLE order_logs
RENAME COLUMN "Actual Lead Time" to actual_lead_time

ALTER TABLE order_logs
RENAME COLUMN "Shipping Route" to shipping_route


ALTER TABLE order_logs
RENAME COLUMN "Date of Arrival at Amazon Warehouse" to date_of_arrival_at_amazon_warehouse

SELECT * FROM order_logs

ALTER TABLE order_logs
RENAME COLUMN   "Estimated Date of Inventory received at Amazon (in stock) " to estimated_date_of_inventory_received_at_amazon_in_stock


-- ALL SHOULD BE ON LOWERCASE, SPELLING

UPDATE order_logs 
SET product_name = lower(product_name)

SELECT * FROM order_logs

SELECT order_number FROM order_logs
GROUP by order_number

SELECT market_place FROM order_logs
GROUP BY market_place

UPDATE order_logs 
SET market_place = lower(market_place)
-- FILL IN NULL VALUES


SELECT shipping_cost_per_unit FROM order_logs
WHERE shipping_cost_per_unit ISNULL

UPDATE order_logs
SET shipping_cost_per_unit = 0
WHERE shipping_cost_per_unit ISNULL

SELECT production_cost_per_unit FROM order_logs
WHERE production_cost_per_unit ISNULL

SELECT total_cost_per_unit_cogs FROM order_logs
WHERE total_cost_per_unit_cogs ISNULL

SELECT total_order_cost FROM order_logs
WHERE total_order_cost ISNULL

SELECT production_lead_time_days FROM order_logs
WHERE production_lead_time_days ISNULL


SELECT actual_lead_time FROM order_logs
WHERE actual_lead_time ISNULL

UPDATE order_logs 
SET actual_lead_time = 0 
WHERE actual_lead_time ISNULL


SELECT shipping_route FROM order_logs
WHERE shipping_route ISNULL

UPDATE order_logs SET shipping_route = 'unknown' WHERE shipping_route ISNULL


SELECT * FROM order_logs

-- CHANGE DATA TYPE

ALTER TABLE order_logs
ALTER COLUMN shipping_cost_per_unit TYPE double precision
USING(shipping_cost_per_unit :: double precision)

ALTER TABLE order_logs
ALTER COLUMN production_cost_per_unit TYPE double precision
USING(production_cost_per_unit :: double precision)

ALTER TABLE order_logs
ALTER COLUMN total_cost_per_unit_cogs TYPE double precision
USING(total_cost_per_unit_cogs :: double precision)

-- REMOVE DUPLICATES

SELECT DISTINCT * FROM order_logs

SELECT * FROM sales_velocity

SELECT product_name, Sum(quantity) as total_quantity, round(sum(total_order_cost)) as revenue FROM order_logs
GROUP BY product_name

ALTER TABLE order_logs
ADD COLUMN total_cost_of_product double precision

UPDATE order_logs
SET total_cost_of_product = shipping_cost_per_unit + production_cost_per_unit + total_cost_per_unit_cogs

ALTER TABLE order_logs
ADD COLUMN profit double precision

UPDATE order_logs
SET profit =total_order_cost - (shipping_cost_per_unit + production_cost_per_unit + total_cost_per_unit_cogs)

SELECT * FROM order_logs

SELECT product_name, Sum(quantity) as total_quantity,round(sum(total_cost_of_product)) as total_cost, round(sum(total_order_cost)) as total_revenue, 
round(SUM(profit)) as total_profit
FROM order_logs
GROUP BY product_name  

ALTER TABLE order_logs
ADD COLUMN production_speed double precision

UPDATE order_logs
SET production_speed = quantity/production_lead_time_days

SELECT product_name, Sum(quantity) as total_quantity,round(sum(total_cost_of_product)) as total_cost, round(sum(total_order_cost)) as total_revenue, 
round(SUM(profit)) as total_profit, ROUND(avg(production_speed)) as avg_production_speed
FROM order_logs
GROUP BY product_name  

SELECT * FROM order_logs

CREATE TABLE order_logs2 as SELECT product_name, Sum(quantity) as total_quantity,round(sum(total_cost_of_product)) as total_cost, round(sum(total_order_cost)) as total_revenue, 
round(SUM(profit)) as total_profit, ROUND(avg(production_speed)) as avg_production_speed
FROM order_logs
GROUP BY product_name  

-- CLEANING TABLE sales_velocity

ALTER TABLE sales_velocity
RENAME COLUMN "Product Name1" to product_name1

ALTER TABLE sales_velocity
RENAME COLUMN "Current Sales velocity per Day" to sales_velocity_per_day

ALTER TABLE sales_velocity
RENAME COLUMN "Current Inventory" to current_inventory

ALTER TABLE sales_velocity
RENAME COLUMN "Monthly Sales" to monthly_sales

UPDATE sales_velocity 
SET product_name1 = lower(product_name1) 

SELECT * FROM order_logs2 AS c1
LEFT JOIN sales_velocity as c2
ON c1.product_name = c2.product_name1

CREATE TABLE working_sheet AS SELECT * FROM order_logs2 AS c1
LEFT JOIN sales_velocity as c2
ON c1.product_name = c2.product_name1

ALTER TABLE working_sheet
DROP COLUMN product_name1

SELECT * FROM working_sheet
