CREATE PROCEDURE spGetOrderByCustomerID
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select *
FROM Orders
WHERE (
		cast(CustomerID as varchar(5)))
		LIKE @SearchValue
ORDER BY OrderDate