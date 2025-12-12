# SQL + Power BI Sales Insights Dashboard

A complete end-to-end analytics project built using **MS SQL Server** and **Power BI**, designed to showcase real-world data modeling, ETL, SQL analytics, and interactive dashboard development.  
The dataset includes large-scale synthetic data (~10k customers, ~100k orders, ~200k order items), enabling realistic business insights.

---

## 📁 Project Structure

```
sql-powerbi-sales-insights/
│
├── database/
│   ├── create_tables.sql         # Schema + relationships
│   ├── insert_data.sql           # Bulk synthetic data generator
│   └── queries.sql               # Analytical SQL queries
│
├── powerbi/
│   └── sales_insights.pbix       # Final Power BI dashboard
│
└── exports/
    ├── dashboard_overview.png
    ├── product_insights.png
    └── region_heatmap.png
```

---

## 🗂 Database Schema

### Dimension Tables
- **dim_customer** – customer profile, region, and segmentation  
- **dim_product** – product catalog with category and subcategory  

### Fact Tables
- **fact_order** – order-level details (date, customer, status)  
- **fact_order_item** – item-level details (quantity, unit price, discount, revenue)

**Dataset Size:**
- ~10,000 customers  
- ~50 products  
- ~100,000 orders  
- ~200,000 order items  

---

## 🧠 SQL Analytics Performed

### Revenue Analysis
- Total revenue  
- Monthly revenue trends  
- Regional performance  
- Revenue by customer segment  

### Product Insights
- Top 10 high-revenue products  
- Category & subcategory contribution  

### Customer Insights
- Customer segmentation  
- Identifying high-value segments  

### Key Metrics
- **AOV (Average Order Value)**  
- **Revenue growth patterns**

All SQL scripts are provided inside `/database`.

---

## 📊 Power BI Dashboard

### **Page 1 — Executive Overview**
- KPIs: Total Revenue, AOV  
- Revenue trend over time  
- Region-wise performance  
- Customer segment distribution  
- Filters: Month, Region, Category  

### **Page 2 — Product Insights**
- Top 10 products by revenue  
- Treemap: Category & subcategory revenue  

### **Page 3 — Regional Heatmap**
- Region × Month revenue matrix  
- Highlights seasonal + geographical trends  

Screenshots are available in `/exports`.

---

## 🚀 Tools Used
- **MS SQL Server**
- **SQL Server Management Studio (SSMS)**
- **Power BI Desktop**
- **Git & GitHub**

---

## 📬 Contact
For questions or collaboration inquiries, feel free to reach out.
