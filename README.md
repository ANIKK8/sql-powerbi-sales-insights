# SQL + Power BI Sales Insights Dashboard

This project delivers an end-to-end analytics pipeline using MS SQL Server and Power BI, built on top of a large synthetic dataset (~10,000 customers, ~100,000 orders, ~200,000 order items).  
The goal is to demonstrate skills in database design, SQL analytics, data modeling, and interactive dashboard development.

---

## 📁 Project Structure
sql-powerbi-sales-insights/
│
├── database/
│ ├── create_tables.sql -- Schema + relationships
│ ├── insert_data.sql -- Bulk synthetic data generator
│ └── queries.sql -- Analytical SQL queries
│
├── powerbi/
│ └── sales_insights.pbix -- Final dashboard
│
└── exports/
├── dashboard_overview.png
├── product_insights.png
├── region_heatmap.png

---

## 🗂 Database Schema

### Dimension Tables
- `dim_customer` – customer profile & region segmentation  
- `dim_product` – product catalog, category & subcategory  

### Fact Tables
- `fact_order` – order-level details (date, customer)  
- `fact_order_item` – item-level details (quantity, price, revenue)

Dataset Size:
- ~10K customers  
- ~50 products  
- ~100K orders  
- ~200K order items  

---

## 🧠 Key SQL Insights

### • Revenue Analysis
- Total revenue  
- Revenue by month  
- Revenue by region  
- Revenue by customer segment  

### • Product Performance
- Top 10 products  
- Revenue by category/subcategory  

### • Customer Insights
- High-value customers  
- Segment breakdown  

### • Metrics
- Average Order Value (AOV)  
- Monthly growth trends  

All SQL scripts are included in `/database`.

---

## 📊 Power BI Dashboard

The dashboard includes:

### Page 1 — Executive Overview
- KPIs: Total Revenue, Total Orders, AOV  
- Monthly revenue trend  
- Region performance  
- Customer segment breakdown  

### Page 2 — Product Insights
- Top 10 products  
- Category and subcategory analysis  

### Page 3 — Regional Heatmap
- Region × Month matrix  
- Filters for region, category, segment  

Exported screenshots are available in `/exports`.

---

## 🚀 Tools Used
- MS SQL Server
- SQL Server Management Studio (SSMS)
- Power BI Desktop
- GitHub for version control

---

## 📬 Contact
For questions or improvements, feel free to reach out.