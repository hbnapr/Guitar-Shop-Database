CREATE PROCEDURE [spUpdateCustomers]
	@CustomerID int,
	@EmailAddress varchar(255),
	@Password varchar(60),
	@FirstName varchar(60),
	@LastName varchar(60)

AS

SET NOCOUNT ON

BEGIN

	IF EXISTS(	SELECT NULL 
					FROM Customers
					WHERE CustomerID = @CustomerID 
				
					) BEGIN
		UPDATE dbo.Customers
		SET EmailAddress = @EmailAddress, [Password] = @Password, FirstName = @FirstName, LastName = @LastName
		WHERE CustomerID = @CustomerID
		SELECT [success] = @CustomerID
	
	END ELSE BEGIN
		SELECT [success] = 0
	END
END