CREATE PROCEDURE spGetOrderItemByOrderID
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select *
FROM OrderItems
WHERE (
		cast(OrderID as varchar(5)))
		LIKE @SearchValue 
ORDER BY OrderID