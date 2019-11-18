-- Return to Window Functions!
-- BASIC SYNTAX
-- SELECT <aggregator> OVER(PARTITION BY <col1> ORDER BY <col2>)
-- PARTITION BY (like GROUP BY) a column to do the aggregation within particular category in <col1>
-- Choose what order to apply the aggregator over (if it's a type of RANK)
-- Example SELECT SUM(sales) OVER(PARTITION BY department)
-- Feel free to google RANK examples too.



-- Return a list of all customers, RANKED in order from highest to lowest total spendings
-- WITHIN the country they live in.
-- HINT: find a way to join the order_details, products, and customers tables


SELECT customer_id,
        country,
        SUM(unit_price * quantity) OVER(PARTITION by product_id ORDER BY customer_id) 
                                   AS total_spending
FROM order_details 
JOIN orders USING(order_id)
JOIN customers USING(customer_id)
WHERE country LIKE ship_country
ORDER BY total_spending DESC;

-- Return the same list as before, but with only the top 3 customers in each country.

WITH customer_total_spendimg AS(
        SELECT customer_id,
        country,
        SUM(unit_price * quantity) OVER(PARTITION by product_id ORDER BY customer_id) 
                                   AS total_spending
FROM order_details 
JOIN orders USING(order_id)
JOIN customers USING(customer_id)
WHERE country LIKE ship_country
)
SELECT 
    customer_id,
    country, 
    RANK() OVER(PARTITION BY country ORDER BY total_spending)
FROM customer_total_spendimg;
