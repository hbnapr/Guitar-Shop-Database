CREATE PROCEDURE [spAddDeleteCustomers]
	@CustomerID int,
	@EmailAddress varchar(255),
	@Password varchar(60),
	@FirstName varchar(60),
	@LastName varchar(60),
	@Delete bit = 0

AS

SET NOCOUNT ON

IF @CustomerID = 0 BEGIN		--ADD

		INSERT INTO Customers(EmailAddress, [Password], FirstName, LastName)
		VALUES (@EmailAddress, @Password, @FirstName, @LastName)
		SELECT [success] = @@IDENTITY

	END	ELSE IF @Delete = 1 BEGIN		--DELETE
		IF NOT EXISTS( 
						SELECT	top(1) NULL 
						FROM	Customers AS c, Orders AS o, Addresses as a
						WHERE	c.CustomerID = @CustomerID OR
								o.CustomerID = @CustomerID OR
								a.CustomerID = @CustomerID
					) BEGIN
							DELETE FROM Customers WHERE CustomerID = @CustomerID
							SELECT [success] = 1
		END ELSE BEGIN
			SELECT [success] = 0
		END
END