CREATE PROCEDURE [spAddUpdateDeleteCategories]
	@CategoryID int,
	@CategoryName varchar(255),
	@Delete bit = 0

AS

SET NOCOUNT ON

BEGIN
	IF @CategoryID = 0 BEGIN		--ADD

		INSERT INTO Categories(CategoryName)
		VALUES (@CategoryName)
		SELECT [success] = @@IDENTITY

	END	ELSE IF @Delete = 1 BEGIN		--DELETE
			DELETE FROM Categories WHERE CategoryID = @CategoryID
			SELECT [success] = 1
		END ELSE BEGIN
			SELECT [success] = 0
		END
	END IF EXISTS(	SELECT NULL 
					FROM Categories
					WHERE CategoryID = @CategoryID 
				
					) BEGIN		--UPDATE
		UPDATE dbo.Categories
		SET CategoryName = @CategoryName
		WHERE CategoryID = @CategoryID
		SELECT [success] = @CategoryID
	
	END ELSE BEGIN
		SELECT [success] = 0
	END