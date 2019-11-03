CREATE PROCEDURE [spGetCustomerByName]
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select	CustomerID, (LastName + ', ' + FirstName) AS Name, 
		EmailAddress, ShippingAddressID, BillingAddressID
FROM Customers
WHERE (
		FirstName +
		' ' +
		LastName)
		LIKE ('%' + @SearchValue + '%')
ORDER BY LastName, FirstName