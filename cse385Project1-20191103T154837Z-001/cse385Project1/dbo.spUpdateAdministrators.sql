CREATE PROCEDURE [spUpdateAdministrators]
	@AdminID int,
	@EmailAddress varchar(255),
	@Password varchar(255),
	@FirstName varchar(255),
	@LastName varchar(255)

AS

SET NOCOUNT ON

BEGIN
	IF EXISTS(	SELECT NULL 
					FROM Administrators
					WHERE AdminID = @AdminID 
				
					) BEGIN			--UPDATE
		UPDATE dbo.Administrators
		SET EmailAddress = @EmailAddress, [Password] = @Password, FirstName = @FirstName, LastName = @LastName
		WHERE AdminID = @AdminID
		SELECT [success] = @AdminID
	
	END ELSE BEGIN
		SELECT [success] = 0
	END
END