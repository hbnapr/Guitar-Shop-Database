CREATE PROCEDURE spUpdateDeleteBillingAddress
	@CustomerID int,
	@BillingAddressID int = NULL,
	@Delete bit = 0
AS
	IF(@Delete = 1)		SELECT @BillingAddressID = NULL

	IF( (@BillingAddressID IS NULL) OR
		(EXISTS(SELECT NULL FROM Addresses WHERE AddressID = @BillingAddressID)))
			UPDATE Customers
			SET BillingAddressID = @BillingAddressID
			WHERE CustomerID = @CustomerID
