CREATE PROCEDURE spGetProductByCategoryID
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select ProductID, CategoryID, ProductCode, ProductName, Description, ListPrice, DiscountPercent, Convert(varchar(11), cast(DateAdded as varchar(11))) AS DateAdded
FROM Products
WHERE (
		cast(CategoryID as varchar(20)))
		LIKE @SearchValue
ORDER BY CategoryID