CREATE PROCEDURE spGetTotalOrderCostByCustomer
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

SELECT	o.OrderID, (LastName + ', ' + FirstName) AS Name,
		'$' + CONVERT(varchar(12),CAST(SUM(((ItemPrice - DiscountAmount) * Quantity) + ShipAmount + TaxAmount) as MONEY),1) AS TotalOrderCost,
		Convert(varchar(11), cast(OrderDate as varchar(11))) AS OrderDate, 
		ShipAddressID, CardType, CardNumber, CardExpires, o.BillingAddressID
FROM Customers c
		JOIN Orders o 
			ON c.CustomerID = o.CustomerID
		JOIN OrderItems i
			ON o.OrderID = i.OrderID 
WHERE (
		FirstName +
		' ' +
		LastName)
		LIKE ('%' + @SearchValue + '%')
GROUP BY o.OrderID, LastName, FirstName, OrderDate, ShipAddressID, CardType, CardNumber, CardExpires, o.BillingAddressID
ORDER BY OrderDate, TotalOrderCost