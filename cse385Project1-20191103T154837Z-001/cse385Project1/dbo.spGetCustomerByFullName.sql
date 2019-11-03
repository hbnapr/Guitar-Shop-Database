CREATE PROCEDURE [spGetCustomerByFullName]
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select *
FROM Customers
WHERE (
		FirstName +
		' ' +
		LastName)
		LIKE ('%' + @SearchValue + '%')
ORDER BY LastName, FirstName