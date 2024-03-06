----PARETO--------------------------------------------------------------------------------------------------------------
WITH pareto AS
( SELECT sub_category AS SubCategoryName,
		SUM(sales) AS TotalSales,
		100*SUM(sales)/(SELECT SUM(sales) FROM superstore) as '%TotalSales'
		FROM superstore
		GROUP BY sub_category)
SELECT * 
		, ROUND(SUM([%TotalSales]) OVER (
			ORDER BY TotalSales DESC),3) AS '%Cum_TotalSales'
			FROM pareto