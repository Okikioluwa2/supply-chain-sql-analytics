SELECT 
    s.supplier_name,
    s.country,
    s.category,
    COUNT(po.po_id) AS total_orders,
    SUM(CASE WHEN po.actual_delivery_date <= po.expected_date THEN 1 ELSE 0 END) AS on_time_deliveries,
    SUM(CASE WHEN po.actual_delivery_date > po.expected_date THEN 1 ELSE 0 END) AS late_deliveries,
    ROUND(
        SUM(CASE WHEN po.actual_delivery_date <= po.expected_date THEN 1 ELSE 0 END) * 100.0 
        / COUNT(po.po_id), 2
    ) AS on_time_rate_percent,
    AVG(DATEDIFF(DAY, po.expected_date, po.actual_delivery_date)) AS avg_delay_days
FROM suppliers s
JOIN purchase_orders po ON s.supplier_id = po.supplier_id
WHERE po.actual_delivery_date IS NOT NULL
GROUP BY s.supplier_name, s.country, s.category
ORDER BY on_time_rate_percent DESC;