CREATE PROCEDURE spGetTotalOrderCostByOrderDateRange
	@StartDate datetime,
	@EndDate datetime

AS

SET NOCOUNT ON

SELECT '$' + CONVERT(varchar(12),CAST(SUM(((ItemPrice - DiscountAmount) * Quantity) + ShipAmount + TaxAmount) as MONEY),1)  AS TotalOrderCost
FROM Orders o
		JOIN OrderItems i
			ON o.OrderID = i.OrderID 
WHERE [OrderDate] BETWEEN @StartDate AND @EndDate