CREATE PROCEDURE spUpdateDeleteShippingAddress
	@CustomerID int,
	@ShippingAddressID int = NULL,
	@Delete bit = 0
AS
	IF(@Delete = 1)		SELECT @ShippingAddressID = NULL

	IF( (@ShippingAddressID IS NULL) OR
		(EXISTS(SELECT NULL FROM Addresses WHERE AddressID = @ShippingAddressID)))
			UPDATE Customers
			SET ShippingAddressID = @ShippingAddressID
			WHERE CustomerID = @CustomerID