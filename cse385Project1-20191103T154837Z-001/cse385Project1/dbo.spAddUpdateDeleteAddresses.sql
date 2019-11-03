CREATE PROCEDURE [spAddUpdateDeleteAddresses]
	@AddressID int,
	@CustomerID int,
	@Line1 varchar(60),
	@Line2 varchar(60),
	@City varchar(40),
	@State varchar(2),
	@ZipCode varchar(10),
	@Phone varchar(12),
	@Disabled int,
	@Delete bit = 0

AS

SET NOCOUNT ON

BEGIN
	IF @AddressID = 0 BEGIN

		INSERT INTO Addresses(CustomerID, Line1, Line2, City, [State], ZipCode, Phone, [Disabled])
		VALUES (@CustomerID, @Line1, @Line2, @City, @State, @ZipCode, @Phone, @Disabled)
		SELECT [success] = @@IDENTITY

	END	ELSE IF @Delete = 1 BEGIN
		IF NOT EXISTS( 
						SELECT	top(1) NULL 
						FROM	Customers, Orders 
						WHERE	ShippingAddressID = @AddressID OR
								ShipAddressID = @AddressID
					) BEGIN
							DELETE FROM Addresses WHERE AddressID = @AddressID
							SELECT [success] = 1
		END ELSE BEGIN
			SELECT @Disabled = 1
			SELECT [success] = 1
		END
	END ELSE IF EXISTS(	SELECT NULL 
					FROM Addresses
					WHERE AddressID = @AddressID 
				
					) BEGIN
		UPDATE dbo.Addresses
		SET CustomerID = @CustomerID, Line1 = @Line1, Line2 = @Line2, City = @City, [State] = @State, ZipCode = @ZipCode, Phone = @Phone, [Disabled] = @Disabled
		WHERE AddressID = @AddressID
		SELECT [success] = @AddressID
	
	END ELSE BEGIN
		SELECT [success] = 0
	END
END