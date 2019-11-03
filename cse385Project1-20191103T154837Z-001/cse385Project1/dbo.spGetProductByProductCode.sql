CREATE PROCEDURE spGetProductByProductCode
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select ProductID, CategoryID, ProductCode, ProductName, Description, ListPrice, DiscountPercent, Convert(varchar(11), cast(DateAdded as varchar(11))) AS DateAdded
FROM Products
WHERE ProductCode LIKE ('%' + @SearchValue + '%')
ORDER BY ProductID, DateAdded