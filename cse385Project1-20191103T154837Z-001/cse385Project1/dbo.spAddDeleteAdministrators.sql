CREATE PROCEDURE [spAddDeleteAdministrators]
	@AdminID int,
	@FirstName varchar(255),
	@LastName varchar(255),
	@Delete bit = 0

AS

SET NOCOUNT ON

	IF @AdminID = 0 BEGIN		--ADD

		INSERT INTO Administrators(FirstName, LastName)
		VALUES (@FirstName, @LastName)
		SELECT [success] = @@IDENTITY

	END	ELSE IF @Delete = 1 BEGIN		--DELETE
		IF NOT EXISTS( 
						SELECT	top(1) NULL 
						FROM	Administrators 
						WHERE	AdminID = @AdminID 
					) BEGIN
							DELETE FROM Administrators WHERE AdminID = @AdminID
							SELECT [success] = 1
		END ELSE BEGIN
			SELECT [success] = 0
		END
END