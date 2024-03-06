----Cohort Table
WITH t1
AS
(SELECT *
FROM superstore WHERE order_date BETWEEN '01/01/2016' AND '12/31/2017')
----select * from t1
, t2 
AS
(SELECT order_id, order_date, customer_id, sales, EOMONTH(order_date) AS order_month
FROM t1)
----select * from t2
, t3
AS
( SELECT customer_id, EOMONTH(MIN(order_date)) AS cohort_month
FROM t1
GROUP BY customer_id)
---select * from t3
, t4
AS
(SELECT t2.*, t3.cohort_month, DATEDIFF(MONTH, CAST(t3.cohort_month as date), CAST(t2.order_month as date))+1 AS cohort_index
FROM t2
JOIN t3 ON t2.customer_id = t3.customer_id)
---select * from t4
, t5
AS
( SELECT cohort_month, order_month, cohort_index, COUNT( DISTINCT customer_id) Count_Customer_id
FROM t4
GROUP BY cohort_month, order_month, cohort_index)
---select * from t5 order by cohort_month,cohort_index asc
, t5_sales
AS
(SELECT cohort_month, order_month, cohort_index, ROUND(SUM(Sales),2) AS total_sales
FROM t4
GROUP BY cohort_month, order_month, cohort_index)
---select * from t5_sales order by cohort_month, cohort_index asc
, t6
AS
( SELECT * FROM 
(SELECT cohort_month, cohort_index, Count_Customer_id
FROM t5
) p
PIVOT(
		SUM(Count_Customer_id)
		FOR cohort_index IN ([1],[2], [3], [4],[5], [6], [7], [8], [9], [10], [11], [12], [13],[14], [15], [16], [17], [18], [19], [20], [21], [22], [23], [24]) 
		) piv)

SELECT * FROM t6 ORDER BY cohort_month ASC

SELECT cohort_month,
	ROUND(1.0 * [1]/[1], 2) AS [1],
	ROUND(1.0 * [2]/[1], 2) AS [2],
	ROUND(1.0 * [3]/[1], 2) AS [3],
	ROUND(1.0 * [4]/[1], 2) AS [4],
	ROUND(1.0 * [5]/[1], 2) AS [5],
	ROUND(1.0 * [6]/[1], 2) AS [6],
	ROUND(1.0 * [7]/[1], 2) AS [7],
	ROUND(1.0 * [8]/[1], 2) AS [8],
	ROUND(1.0 * [9]/[1], 2) AS [9],
	ROUND(1.0 * [10]/[1],2) AS [10],
	ROUND(1.0 * [11]/[1],2) AS [11],
	ROUND(1.0 * [12]/[1],2) AS [12]
	FROM t6 ORDER BY cohort_month ASC
