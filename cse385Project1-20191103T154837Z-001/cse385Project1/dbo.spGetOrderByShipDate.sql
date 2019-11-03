CREATE PROCEDURE spGetOrderByShipDate
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select OrderID, CustomerID, Convert(varchar(11), cast(OrderDate as varchar(11))) AS OrderDate, ShipAmount, TaxAmount, Convert(varchar(11), cast(ShipDate as varchar(11))) AS ShipDate, ShipAddressID, CardType, CardNumber, CardExpires, BillingAddressID
FROM Orders
WHERE CAST([ShipDate] AS DATE) = CAST(@SearchValue AS DATE)
ORDER BY ShipDate, CustomerID