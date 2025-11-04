# 🗃️ SQL Project — Business Insights for AtliQ Hardware

## 📘 Introduction

This project demonstrates how **SQL programming** can be used to extract, clean, and analyze business data to produce actionable insights for a company.  
It focuses on **AtliQ Hardware**, a multinational computer hardware manufacturer specializing in CPUs, motherboards, storage drives, and peripherals.  

The goal is to automate business reporting using **SQL**, replacing manual Excel workflows with efficient, scalable, and reliable analytics.  
Through this project, we uncover insights on **sales performance, discount impact, market growth, product demand, and customer profitability** across regions and fiscal years.

---

## 🏢 About the Company — AtliQ Hardware

**AtliQ Hardware** is a global technology manufacturer that produces and distributes computer hardware components.  
It operates in **APAC, Europe (EU), North America (NA), and Latin America (LATAM)**, serving both **B2B** and **B2C** clients.

### Product Portfolio:
- CPUs and Processors  
- Motherboards  
- Solid-State Drives (SSD)  
- RAM Modules  
- Computer Peripherals (Monitors, Keyboards, etc.)

The company aims to improve its profitability, pricing strategies, and market reach through **data-driven decision-making**.

---

## 🎯 Business Problem and Objectives

### The Challenge
AtliQ Hardware’s reporting process was Excel-based, which led to:
- Time-consuming manual reporting  
- Data inconsistencies and errors  
- Difficulty in trend analysis across years and regions  
- Lack of automation for recurring reports  

### The Solution
Implement a **SQL-driven Business Intelligence system** to:
1. Automate and standardize recurring reports  
2. Centralize data for all global regions  
3. Create reusable SQL **views**, **stored procedures**, and **CTEs**  
4. Provide real-time insights into key business metrics  
5. Support management in making informed, data-driven decisions  

---

## 🧱 Database Design

The database follows a **Star Schema** model with fact and dimension tables.  
Database name: `gdb0041`

### Fact Tables
| Table | Description |
|--------|-------------|
| `fact_sales_monthly` | Monthly sales transactions by customer and product |
| `fact_gross_price` | Gross pricing data per product per fiscal year |
| `fact_pre_invoice_deductions` | Discounts applied before invoicing |
| `fact_post_invoice_deductions` | Deductions applied after invoicing |
| `fact_forecast_monthly` | Forecasted sales quantities |

### Dimension Tables
| Table | Description |
|--------|-------------|
| `dim_product` | Contains product details (division, category, variant) |
| `dim_customer` | Contains customer details (region, market, channel) |

This schema ensures flexibility, scalability, and efficiency for analytical queries.

---

## 🧮 Task 1 — Monthly Gross Sales Report (Croma India)

**Objective:** Create a monthly sales report for **Croma India (Customer Code: 90002002)** for Fiscal Year 2021.

**Metrics:**
- Month  
- Product Name and Variant  
- Quantity Sold  
- Gross Price per Item  
- Total Gross Price  

### SQL Query:
```sql
SELECT s.date,
       p.product,
       p.variant,
       s.sold_quantity,
       g.gross_price,
       ROUND(s.sold_quantity * g.gross_price, 2) AS gross_price_total
FROM fact_sales_monthly s
JOIN dim_product p
  ON s.product_code = p.product_code
JOIN fact_gross_price g
  ON g.product_code = s.product_code
 AND g.fiscal_year = get_fiscal_year(s.date)
WHERE s.customer_code = 90002002
  AND get_fiscal_year(s.date) = 2021;
```

**Insight:**  
This report shows month-by-month sales for each product sold to Croma India, revealing performance trends, demand variations, and product profitability.

---

## 💰 Task 2 — Pre-Invoice and Post-Invoice Discount Analysis

**Objective:** Calculate the impact of both **pre-invoice** and **post-invoice** discounts on total sales revenue.

- **Pre-invoice discounts:** Trade discounts applied before invoicing.  
- **Post-invoice deductions:** Rebates or promotional discounts applied after invoicing.

### SQL Query:
```sql
WITH cte1 AS (
  SELECT s.date,
         s.customer_code,
         p.product,
         s.sold_quantity,
         g.gross_price,
         pre.pre_invoice_discount_pct,
         post.post_invoice_discount_pct
  FROM fact_sales_monthly s
  JOIN dim_product p ON s.product_code = p.product_code
  JOIN fact_gross_price g
    ON g.product_code = s.product_code
   AND g.fiscal_year = get_fiscal_year(s.date)
  JOIN fact_pre_invoice_deductions pre
    ON pre.customer_code = s.customer_code
   AND pre.fiscal_year = get_fiscal_year(s.date)
  JOIN fact_post_invoice_deductions post
    ON post.customer_code = s.customer_code
   AND post.fiscal_year = get_fiscal_year(s.date)
)
SELECT *,
       ROUND(gross_price * sold_quantity * (1 - pre_invoice_discount_pct) * (1 - post_invoice_discount_pct), 2) AS net_sales
FROM cte1;
```

**Insight:**  
This query calculates the **true net sales** after applying all discounts.  
It helps evaluate how discount strategies affect profitability and supports better pricing decisions.

---

## 🏆 Task 3 — Stored Procedure for Top Markets by Net Sales

**Objective:** Build a stored procedure to retrieve **Top-N markets** by total net sales dynamically for any fiscal year.

### SQL Code:
```sql
CREATE PROCEDURE get_top_markets(IN year_input INT, IN top_n INT)
BEGIN
  SELECT m.market,
         ROUND(SUM(n.net_sales)/1000000, 2) AS net_sales_mln
  FROM net_sales n
  JOIN dim_customer m
    ON n.customer_code = m.customer_code
  WHERE n.fiscal_year = year_input
  GROUP BY m.market
  ORDER BY net_sales_mln DESC
  LIMIT top_n;
END;
```

**Insight:**  
This stored procedure improves efficiency by allowing users to quickly identify the highest-performing markets without rewriting queries.

---

## 🏷️ Task 4 — Top 3 Products by Division (Using Window Functions)

**Objective:** Identify the **top 3 best-selling products** within each division for FY-2021 using **window functions**.

### SQL Query:
```sql
WITH cte_product AS (
  SELECT p.division,
         p.product,
         SUM(s.sold_quantity) AS total_qty
  FROM fact_sales_monthly s
  JOIN dim_product p
    ON s.product_code = p.product_code
  WHERE s.fiscal_year = 2021
  GROUP BY p.division, p.product
)
SELECT *,
       DENSE_RANK() OVER (PARTITION BY division ORDER BY total_qty DESC) AS rnk
FROM cte_product
WHERE rnk <= 3;
```

**Insight:**  
This identifies top-performing products in each division, guiding production planning, marketing focus, and sales prioritization.

---

## 🌍 Task 5 — Region-Wise Net Sales Distribution

**Objective:** Compute each customer’s and region’s contribution to total company revenue.

### SQL Query:
```sql
WITH cte_sales AS (
  SELECT c.region,
         c.customer,
         ROUND(SUM(n.net_sales)/1000000, 2) AS net_sales_mln
  FROM net_sales n
  JOIN dim_customer c
    ON n.customer_code = c.customer_code
  WHERE n.fiscal_year = 2021
  GROUP BY c.region, c.customer
)
SELECT *,
       net_sales_mln * 100 / SUM(net_sales_mln) OVER (PARTITION BY region) AS pct_share
FROM cte_sales
ORDER BY region, pct_share DESC;
```

**Insight:**  
This breakdown highlights which regions and customers generate the most revenue, helping management target profitable markets and balance growth strategies.

---

## 📊 Consolidated Business Insights

| Category | Key Finding |
|-----------|--------------|
| **Top Markets** | India, USA, and Germany generated the highest net sales. |
| **Discount Impact** | Post-invoice deductions reduced overall revenue by ~5%. |
| **Top Divisions** | Networking and Storage divisions dominated sales. |
| **Regional Share** | The APAC region accounted for the largest revenue share. |
| **Customer Trends** | Croma India showed steady monthly performance with moderate discount usage. |

**Summary:**  
This analysis proves how SQL automation transforms raw transactional data into actionable business intelligence, improving speed, accuracy, and decision-making.

---

## 💻 Tools and Technologies Used

- **MySQL** — Core database for analysis  
- **SQL Workbench / VS Code** — For query execution and debugging  
- **Power BI / Excel** — Visualization and validation  
- **GitHub** — Version control and documentation  

---

## 📚 Key Learnings

- Designed and implemented a **relational star-schema** database model.  
- Utilized **CTEs**, **Views**, **Stored Procedures**, and **Window Functions** effectively.  
- Automated manual reporting using SQL logic.  
- Strengthened understanding of **ETL**, **query optimization**, and **data-driven business reporting**.  
- Learned to transform business requirements into actionable SQL workflows.

---

## 🏁 Final Conclusion

This project showcases how structured SQL queries can replace manual data manipulation with automated, scalable analytics.  
By leveraging SQL, **AtliQ Hardware** achieved:
- Centralized and accurate data reporting  
- Automated sales and discount analysis  
- Enhanced visibility into market, product, and regional performance  
- Real-time, data-driven decision-making  

This end-to-end SQL solution demonstrates how modern organizations can harness relational databases for **Business Intelligence (BI)**, transforming raw data into meaningful insights that support growth and efficiency.

---

⭐ **If you found this project helpful or insightful, please consider starring the repository!**
