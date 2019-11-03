CREATE PROCEDURE spGetOrderByOrderDate
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select OrderID, CustomerID, Convert(varchar(11), cast(OrderDate as varchar(11))) AS OrderDate, ShipAmount, TaxAmount, Convert(varchar(11), cast(ShipDate as varchar(11))) AS ShipDate, ShipAddressID, CardType, CardNumber, CardExpires, BillingAddressID
FROM Orders
WHERE Cast([OrderDate] AS DATE) = Cast(@SearchValue As DATE)
ORDER BY OrderDate, CustomerID