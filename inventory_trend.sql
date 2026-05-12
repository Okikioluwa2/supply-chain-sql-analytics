WITH monthly_inventory AS (
    SELECT
        m.material_name,
        m.unit_of_measure,
        FORMAT(i.snapshot_date, 'yyyy-MM') AS snapshot_month,
        AVG(i.quantity_on_hand) AS avg_quantity_on_hand
    FROM inventory i
    JOIN materials m ON i.material_id = m.material_id
    GROUP BY m.material_name, m.unit_of_measure, FORMAT(i.snapshot_date, 'yyyy-MM')
)
SELECT
    material_name,
    unit_of_measure,
    snapshot_month,
    avg_quantity_on_hand,
    LAG(avg_quantity_on_hand) OVER (
        PARTITION BY material_name 
        ORDER BY snapshot_month
    ) AS previous_month_quantity,
    ROUND(
        avg_quantity_on_hand - LAG(avg_quantity_on_hand) OVER (
            PARTITION BY material_name 
            ORDER BY snapshot_month
        ), 2
    ) AS month_over_month_change,
    ROUND(
        (avg_quantity_on_hand - LAG(avg_quantity_on_hand) OVER (
            PARTITION BY material_name 
            ORDER BY snapshot_month
        )) * 100.0 / NULLIF(LAG(avg_quantity_on_hand) OVER (
            PARTITION BY material_name 
            ORDER BY snapshot_month
        ), 0), 2
    ) AS change_percent
FROM monthly_inventory
ORDER BY material_name, snapshot_month;