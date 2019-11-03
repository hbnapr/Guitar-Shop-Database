CREATE PROCEDURE spGetProductByProductName
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select ProductID, CategoryID, ProductCode, ProductName, Description, ListPrice, DiscountPercent, Convert(varchar(11), cast(DateAdded as varchar(11))) AS DateAdded
FROM Products
WHERE ProductName LIKE ('%' + @SearchValue + '%')
ORDER BY ProductID, ProductName, DateAdded