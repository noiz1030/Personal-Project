SELECT * FROM superstore
WITH RFM
AS
(SELECT a.customer_name, 
		DATEDIFF(Day,Max(order_date), 
		CONVERT(DATE, GETDATE())) AS Recency, 
		COUNT(DISTINCT order_id)  AS Frequency, 
		ROUND(SUM(sales),2) AS Monetary
	FROM superstore AS a
	GROUP BY customer_name
)
, RFM_Score AS
(
SELECT *, 
	NTILE(5) OVER ( ORDER BY Recency DESC) as R_Score,
	NTILE(5) OVER ( ORDER BY Frequency ASC) as F_Score,
	NTILE(5) OVER ( ORDER BY Monetary ASC) as M_Score
FROM RFM
)
, RFM_Final
AS
( SELECT *, concat(R_Score, F_Score, M_Score) AS RFM_Overall
FROM RFM_Score
)
--Select * from RFM_Final
SELECT f.*, s.segment
FROM RFM_Final AS f
JOIN [segment scores] AS s ON f.RFM_Overall = s.Scores



