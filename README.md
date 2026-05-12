 Supply Chain Analytics — SQL & Power BI

 Project Overview
An end-to-end supply chain analytics database built with Microsoft SQL Server, 
Python, and Power BI. Inspired by real-world exposure to manufacturing operations 
during an industrial training placement at a large cement company in Nigeria.

 Tools Used
- Microsoft SQL Server (MSSQL)
- Python (Faker, pyodbc, pandas)
- Power BI Desktop
- SQL Server Management Studio (SSMS)

 Database Schema
7 fully normalized tables covering:
- Suppliers
- Materials
- Purchase Orders
- Purchase Order Items
- Inventory
- Production Runs
- Finished Goods

 Analytical Queries
1. Supplier on-time delivery rate
2. Low stock and reorder alerts
3. Month-over-month inventory trend
4. Production efficiency by product line
5. Supplier spend analysis

 Power BI Dashboard
3 report pages:
- Supplier Scorecard
- Inventory Overview
- Production Efficiency

 How to Run
1. Install SQL Server Express and SSMS
2. Create a database called supply_chain_db
3. Run the CREATE TABLE scripts in /sql/
4. Run seed_data.py to populate the database
5. Open supply_chain_dashboard.pbix in Power BI Desktop
