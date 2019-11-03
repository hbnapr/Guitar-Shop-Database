CREATE PROCEDURE [spAddUpdateDeleteCustomers]
	@CustomerID int,
	@EmailAddress varchar(255),
	@Password varchar(60),
	@FirstName varchar(60),
	@LastName varchar(60),
	@ShippingAddressID int,
	@BillingAddressID int,
	@Delete bit = 0

AS

SET NOCOUNT ON

BEGIN
	IF @CustomerID = 0 BEGIN		--ADD

		INSERT INTO Customers(EmailAddress, [Password], FirstName, LastName, ShippingAddressID, BillingAddressID)
		VALUES (@EmailAddress, @Password, @FirstName, @LastName, @ShippingAddressID, @BillingAddressID)
		SELECT [success] = @@IDENTITY

	END	ELSE IF @Delete = 1 BEGIN		--DELETE
		IF NOT EXISTS( 
						SELECT	top(1) NULL 
						FROM	Orders AS o, Addresses as a
						WHERE	
								o.CustomerID = @CustomerID OR
								a.CustomerID = @CustomerID
					) BEGIN
							DELETE FROM Customers WHERE CustomerID = @CustomerID
							SELECT [success] = 1
		END ELSE BEGIN
			SELECT [success] = 0
		END
	END ELSE IF EXISTS(	SELECT NULL 
					FROM Customers
					WHERE CustomerID = @CustomerID 
				
					) BEGIN		--UPDATE
		UPDATE dbo.Customers
		SET EmailAddress = @EmailAddress, [Password] = @Password, FirstName = @FirstName, LastName = @LastName, ShippingAddressID = @ShippingAddressID, BillingAddressID = @BillingAddressID
		WHERE CustomerID = @CustomerID
		SELECT [success] = @CustomerID
	
	END ELSE BEGIN
		SELECT [success] = 0
	END
END