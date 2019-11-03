CREATE PROCEDURE spGetAddressByState
	@SearchValue varchar(50)

AS

SET NOCOUNT ON


Select *
FROM Addresses
WHERE (
		State)
		LIKE ('%' + @SearchValue + '%')
ORDER BY City, CustomerID