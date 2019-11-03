CREATE PROCEDURE [spAddUpdateDeleteAdministrators]
	@AdminID int,
	@EmailAddress varchar(255),
	@Password varchar(255),
	@FirstName varchar(255),
	@LastName varchar(255),
	@Delete bit = 0

AS

SET NOCOUNT ON

BEGIN
	IF @AdminID = 0 BEGIN		--ADD

		INSERT INTO Administrators(EmailAddress, [Password], FirstName, LastName)
		VALUES (@EmailAddress, @Password, @FirstName, @LastName)
		SELECT [success] = @@IDENTITY

	END	ELSE IF @Delete = 1 BEGIN		--DELETE
		
			DELETE FROM Administrators WHERE AdminID = @AdminID
			SELECT [success] = 1
		END ELSE BEGIN
			SELECT [success] = 0
		END
	END IF EXISTS(	SELECT NULL 
					FROM Administrators
					WHERE AdminID = @AdminID 
				
					) BEGIN		--UPDATE
		UPDATE dbo.Administrators
		SET EmailAddress = @EmailAddress, [Password] = @Password, FirstName = @FirstName, LastName = @LastName
		WHERE AdminID = @AdminID
		SELECT [success] = @AdminID
	
	END ELSE BEGIN
		SELECT [success] = 0
	END