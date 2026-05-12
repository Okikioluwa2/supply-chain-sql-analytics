WITH production_stats AS (
    SELECT
        product_line,
        COUNT(run_id) AS total_runs,
        SUM(planned_output) AS total_planned,
        SUM(actual_output) AS total_actual,
        AVG(efficiency_rate) AS avg_efficiency,
        MAX(efficiency_rate) AS best_run,
        MIN(efficiency_rate) AS worst_run
    FROM production_runs
    GROUP BY product_line
)
SELECT
    product_line,
    total_runs,
    total_planned,
    total_actual,
    (total_planned - total_actual) AS total_output_gap,
    ROUND(avg_efficiency, 2) AS avg_efficiency_percent,
    ROUND(best_run, 2) AS best_run_percent,
    ROUND(worst_run, 2) AS worst_run_percent,
    RANK() OVER (ORDER BY avg_efficiency DESC) AS efficiency_rank,
    CASE
        WHEN avg_efficiency >= 90 THEN 'Excellent'
        WHEN avg_efficiency >= 75 THEN 'Good'
        WHEN avg_efficiency >= 60 THEN 'Needs Improvement'
        ELSE 'Critical'
    END AS performance_rating
FROM production_stats
ORDER BY efficiency_rank;