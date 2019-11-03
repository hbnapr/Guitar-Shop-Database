CREATE PROCEDURE spGetCategoryByName
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select *
FROM Categories
WHERE (
		CategoryName)
		LIKE ('%' + @SearchValue + '%')
ORDER BY CategoryName