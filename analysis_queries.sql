-- Nykaa Product Catalog Analysis — SQL Business Questions
-- Table: products (uniq_id, brand_name, category, product_title, mrp, price, rating, rating_count, source_snapshot)

-- Q1: Which brands have the widest product range in the catalog? (min 50 products)
SELECT brand_name, COUNT(*) AS product_count
FROM products
GROUP BY brand_name
HAVING COUNT(*) > 50
ORDER BY COUNT(*) DESC;

-- Q2: What is the average price and rating for each category?
SELECT category, AVG(rating) AS avg_rating, AVG(price) AS avg_price, COUNT(*) AS product_count
FROM products
GROUP BY category
ORDER BY COUNT(*) DESC;

-- Q3: Which brands have the highest average rating? (min 20 products, to avoid small-sample bias)
SELECT brand_name, AVG(rating) AS avg_rating, COUNT(*) AS product_count
FROM products
GROUP BY brand_name
HAVING COUNT(*) >= 20
ORDER BY avg_rating DESC;

-- Q4: What is the single most-reviewed (most popular) product within each category?
SELECT * FROM (
    SELECT product_title, category, rating_count,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY rating_count DESC) AS rank_in_category
    FROM products
) AS ranked
WHERE rank_in_category = 1;

-- Q5: Which brands offer the biggest average discount %? (2022 dataset only — has MRP data)
SELECT brand_name, AVG((mrp - price) / mrp * 100) AS avg_discount_pct, COUNT(*) AS product_count
FROM products
WHERE source_snapshot = '2022_popular_brands'
GROUP BY brand_name
HAVING COUNT(*) >= 20
ORDER BY avg_discount_pct DESC;