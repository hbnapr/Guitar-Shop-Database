CREATE PROCEDURE spGetOrderItemByProductID
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select *
FROM OrderItems
WHERE (
		cast(ProductID as varchar(5)))
		LIKE @SearchValue
ORDER BY ProductID