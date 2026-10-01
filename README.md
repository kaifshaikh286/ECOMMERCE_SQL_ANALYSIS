# E-Commerce Sales Analysis (SQL)

A relational database project analyzing e-commerce sales data using MySQL — covering customer behavior, product performance, revenue trends, and order fulfillment across a 5-table schema.

## Project Overview

This project simulates a realistic e-commerce sales database and uses SQL to answer business questions a data analyst would face: which products drive revenue, which customers are most valuable, how orders move through their lifecycle, and where cancellations happen.

## Tech Stack
- MySQL (MySQL Workbench)
- SQL: joins, subqueries,window functions

## Schema

| Table | Description | Rows |
|---|---|---|
| `customers` | Customer profile: name, city, state, country, signup date | 200 |
| `products` | Product catalog: name, category, sub-category, price, cost | 100 |
| `orders` | Order header: customer, date, payment method, status, shipping city | 500 |
| `order_items` | Line items per order: product, quantity, price, discount | 1,011 |
| `payments` | Payment record per order: method, amount, status | 500 |

**Relationships**: `orders.customer_id → customers.customer_id`, `order_items.order_id → orders.order_id`, `order_items.product_id → products.product_id`, `payments.order_id → orders.order_id`

## Key Findings

- **Sports (24.5%) and Electronics (24.3%) are the top two revenue-generating categories**, together accounting for nearly half of total order value — Fashion trails at just 13.4%.
- **90.5% of customers who placed an order are repeat customers** (2+ orders), indicating strong retention within this dataset.
- **12.4% of all orders were cancelled**, with the remaining split across Delivered (47.6%), Shipped (20.6%), and Processing (19.4%).
- Payment status is fully consistent with order outcome across all 500 payment records — cancelled orders show failed payments, delivered/shipped orders show successful payments, and in-progress orders show pending payments.

## Files

- `01_schema.sql` — table definitions and foreign key relationships
- `02_data.sql` — full dataset (200 customers, 100 products, 500 orders, 1,011 order items, 500 payments)
- `03_queries.sql` — analysis queries, organized by skill level:
  - Basic SELECT / WHERE / ORDER BY
  - Aggregates with GROUP BY / HAVING
  - INNER JOIN and LEFT JOIN (including unmatched-record patterns)
  - Subqueries (correlated, IN, NOT IN, EXISTS)
  - Window functions (RANK, running totals with SUM() OVER)

## How to Run

1. Run `01_schema.sql` in MySQL Workbench to create the database and tables.
2. Run `02_data.sql` to load all data.
3. Run any query from `03_queries.sql` to reproduce the analysis.

## Related Projects

This dataset is also the basis for a companion Power BI dashboard *(coming soon)*, extending this analysis into visual reporting.
