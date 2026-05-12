SELECT
    m.material_name,
    m.unit_of_measure,
    m.reorder_point,
    m.max_stock_level,
    i.warehouse_location,
    i.quantity_on_hand,
    i.quantity_reserved,
    (i.quantity_on_hand - i.quantity_reserved) AS available_stock,
    CASE
        WHEN (i.quantity_on_hand - i.quantity_reserved) <= 0 THEN 'Out of Stock'
        WHEN (i.quantity_on_hand - i.quantity_reserved) <= m.reorder_point THEN 'Reorder Now'
        WHEN (i.quantity_on_hand - i.quantity_reserved) <= m.reorder_point * 1.5 THEN 'Running Low'
        ELSE 'Sufficient'
    END AS stock_status,
    m.unit_cost,
    ROUND((i.quantity_on_hand - i.quantity_reserved) * m.unit_cost, 2) AS stock_value
FROM materials m
JOIN inventory i ON m.material_id = i.material_id
WHERE i.snapshot_date = (
    SELECT MAX(snapshot_date) 
    FROM inventory 
    WHERE material_id = m.material_id
)
ORDER BY available_stock ASC;