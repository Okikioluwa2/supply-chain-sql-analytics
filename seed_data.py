import pyodbc
import random
from faker import Faker
from datetime import timedelta

fake = Faker()

conn = pyodbc.connect(
    'DRIVER={ODBC Driver 17 for SQL Server};'
    'SERVER=DESKTOP-UTKMDEJ\\OKIKISERVER;'
    'DATABASE=supply_chain_db;'
    'Trusted_Connection=yes;'
)
cursor = conn.cursor()

suppliers = []
supplier_categories = ['Raw Materials', 'Packaging', 'Chemicals', 'Equipment', 'Logistics']
countries = ['Nigeria', 'China', 'Germany', 'India', 'South Africa', 'USA', 'UAE']

for _ in range(20):
    name = fake.company()
    country = random.choice(countries)
    category = random.choice(supplier_categories)
    lead_time = random.randint(3, 30)
    reliability = round(random.uniform(0.60, 1.00), 2)
    cursor.execute(
        "INSERT INTO suppliers (supplier_name, country, category, lead_time_days, reliability_score) VALUES (?, ?, ?, ?, ?)",
        name, country, category, lead_time, reliability
    )
    suppliers.append(cursor.execute("SELECT @@IDENTITY").fetchval())

materials = []
material_names = ['Limestone', 'Clinker', 'Gypsum', 'Fly Ash', 'Iron Ore',
                  'Coal', 'Silica', 'Bauxite', 'Slag', 'Alumina',
                  'Calcium Carbonate', 'Sodium Hydroxide', 'Clay', 'Sand', 'Gravel',
                  'Cement Bags', 'Steel Rods', 'Water', 'Diesel', 'Lubricants']
units = ['Tonnes', 'Kg', 'Litres', 'Bags', 'Barrels']

for name in material_names:
    unit = random.choice(units)
    cost = round(random.uniform(50, 5000), 2)
    reorder = random.randint(100, 500)
    max_stock = random.randint(1000, 10000)
    cursor.execute(
        "INSERT INTO materials (material_name, unit_of_measure, unit_cost, reorder_point, max_stock_level) VALUES (?, ?, ?, ?, ?)",
        name, unit, cost, reorder, max_stock
    )
    materials.append(cursor.execute("SELECT @@IDENTITY").fetchval())

statuses = ['Delivered', 'Pending', 'Cancelled', 'Partial']
purchase_orders = []

for _ in range(500):
    supplier_id = random.choice(suppliers)
    order_date = fake.date_between(start_date='-2y', end_date='today')
    expected_date = order_date + timedelta(days=random.randint(3, 30))
    status = random.choice(statuses)
    if status == 'Delivered':
        delay = random.randint(-5, 15)
        actual_delivery = expected_date + timedelta(days=delay)
    else:
        actual_delivery = None
    cursor.execute(
        "INSERT INTO purchase_orders (supplier_id, order_date, expected_date, actual_delivery_date, status) VALUES (?, ?, ?, ?, ?)",
        supplier_id, order_date, expected_date, actual_delivery, status
    )
    purchase_orders.append(cursor.execute("SELECT @@IDENTITY").fetchval())

for po_id in purchase_orders:
    num_items = random.randint(1, 5)
    selected_materials = random.sample(materials, num_items)
    for material_id in selected_materials:
        qty_ordered = random.randint(50, 1000)
        qty_received = random.randint(0, qty_ordered) if random.random() > 0.3 else None
        unit_price = round(random.uniform(50, 5000), 2)
        cursor.execute(
            "INSERT INTO purchase_order_items (po_id, material_id, quantity_ordered, quantity_received, unit_price) VALUES (?, ?, ?, ?, ?)",
            po_id, material_id, qty_ordered, qty_received, unit_price
        )

for _ in range(1000):
    material_id = random.choice(materials)
    snapshot_date = fake.date_between(start_date='-1y', end_date='today')
    qty_on_hand = random.randint(100, 10000)
    qty_reserved = random.randint(0, qty_on_hand)
    location = random.choice(['Block A', 'Block B', 'Bay 1', 'Bay 2', 'Bay 3', 'Warehouse 1', 'Warehouse 2'])
    cursor.execute(
        "INSERT INTO inventory (material_id, snapshot_date, quantity_on_hand, quantity_reserved, warehouse_location) VALUES (?, ?, ?, ?, ?)",
        material_id, snapshot_date, qty_on_hand, qty_reserved, location
    )

product_lines = ['Portland Cement', 'Clinker', 'Bagged Cement', 'Ready Mix', 'Masonry Cement']
production_run_ids = []

for _ in range(200):
    run_date = fake.date_between(start_date='-1y', end_date='today')
    product_line = random.choice(product_lines)
    planned = random.randint(500, 5000)
    actual = random.randint(int(planned * 0.6), planned)
    efficiency = round((actual / planned) * 100, 2)
    cursor.execute(
        "INSERT INTO production_runs (run_date, product_line, planned_output, actual_output, efficiency_rate) VALUES (?, ?, ?, ?, ?)",
        run_date, product_line, planned, actual, efficiency
    )
    production_run_ids.append(cursor.execute("SELECT @@IDENTITY").fetchval())

for run_id in production_run_ids:
    product_name = random.choice(product_lines)
    qty_produced = random.randint(100, 5000)
    qty_dispatched = random.randint(0, qty_produced)
    dispatch_date = fake.date_between(start_date='-1y', end_date='today') if random.random() > 0.2 else None
    cursor.execute(
        "INSERT INTO finished_goods (run_id, product_name, quantity_produced, quantity_dispatched, dispatch_date) VALUES (?, ?, ?, ?, ?)",
        run_id, product_name, qty_produced, qty_dispatched, dispatch_date
    )

conn.commit()
cursor.close()
conn.close()
print("Data successfully inserted into supply_chain_db!")