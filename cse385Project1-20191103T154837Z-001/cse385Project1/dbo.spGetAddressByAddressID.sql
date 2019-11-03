CREATE PROCEDURE spGetAddressByAddressID
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select *
FROM Addresses
WHERE (
		cast(AddressID as varchar(5)))
		LIKE @SearchValue
ORDER BY AddressID, CustomerID