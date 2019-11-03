CREATE PROCEDURE spGetAddressByCustomerID
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select *
FROM Addresses
WHERE (
		cast(CustomerID as varchar(5)))
		LIKE @SearchValue
ORDER BY CustomerID