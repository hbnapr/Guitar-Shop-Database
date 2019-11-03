CREATE PROCEDURE [spAddUpdateDeleteCategories]
	@CategoryID int,
	@CategoryName varchar(255),
	@Delete bit = 0

AS

SET NOCOUNT ON

BEGIN
	IF @CategoryID = 0 BEGIN

		INSERT INTO Categories(CategoryID, CategoryName)
		VALUES (@CategoryID, @CategoryName)
		SELECT [success] = @@IDENTITY

	END	ELSE IF @Delete = 1 BEGIN
		IF NOT EXISTS( 
						SELECT	top(1) NULL 
						FROM	Categories 
						WHERE	CategoryID = @CategoryID 
					) BEGIN
							DELETE FROM Categories WHERE CategoryID = @CategoryID
							SELECT [success] = 1
		END ELSE BEGIN
			SELECT [success] = 0
		END
	END ELSE IF EXISTS(	SELECT NULL 
					FROM Categories
					WHERE CategoryID = @CategoryID 
				
					) BEGIN
		UPDATE dbo.Categories
		SET CategoryName = @CategoryName
		WHERE CategoryID = @CategoryID
		SELECT [success] = @CategoryID
	
	END ELSE BEGIN
		SELECT [success] = 0
	END
END