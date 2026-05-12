WITH supplier_spend AS (
    SELECT
        s.supplier_id,
        s.supplier_name,
        s.country,
        s.category,
        s.reliability_score,
        COUNT(DISTINCT po.po_id) AS total_orders,
        SUM(poi.quantity_ordered * poi.unit_price) AS total_spend,
        AVG(poi.unit_price) AS avg_unit_price,
        SUM(poi.quantity_ordered) AS total_quantity_ordered,
        SUM(poi.quantity_received) AS total_quantity_received
    FROM suppliers s
    JOIN purchase_orders po ON s.supplier_id = po.supplier_id
    JOIN purchase_order_items poi ON po.po_id = poi.po_id
    GROUP BY s.supplier_id, s.supplier_name, s.country, s.category, s.reliability_score
)
SELECT
    supplier_name,
    country,
    category,
    total_orders,
    total_quantity_ordered,
    total_quantity_received,
    ROUND(reliability_score * 100, 2) AS reliability_percent,
    ROUND(avg_unit_price, 2) AS avg_unit_price,
    ROUND(total_spend, 2) AS total_spend,
    RANK() OVER (ORDER BY total_spend DESC) AS spend_rank,
    ROUND(total_spend * 100.0 / SUM(total_spend) OVER(), 2) AS spend_share_percent,
    ROUND(SUM(total_spend) OVER(ORDER BY total_spend DESC), 2) AS running_total_spend
FROM supplier_spend
ORDER BY spend_rank;