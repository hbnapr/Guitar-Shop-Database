CREATE PROCEDURE [spAddUpdateDeleteProducts]
	@ProductID int,
	@CategoryID int,
	@ProductCode varchar(10),
	@ProductName varchar(255),
	@Description text,
	@ListPrice money,
	@DiscountPercent money,
	@DateAdded datetime,
	@Delete bit = 0

AS

SET NOCOUNT ON

BEGIN
	IF @ProductID = 0 BEGIN		--ADD

		INSERT INTO Products(CategoryID, ProductCode, ProductName, [Description], ListPrice, DiscountPercent, DateAdded)
		VALUES (@CategoryID, @ProductCode, @ProductName, @Description, @ListPrice, @DiscountPercent, @DateAdded)
		SELECT [success] = @@IDENTITY

	END	ELSE IF @Delete = 1 BEGIN		--DELETE
		IF NOT EXISTS( 
						SELECT	top(1) NULL 
						FROM	OrderItems AS i
						WHERE	
								i.ProductID = @ProductID
								
					) BEGIN
							DELETE FROM Products WHERE ProductID = @ProductID
							SELECT [success] = 1
		END ELSE BEGIN
			SELECT [success] = 0
		END
	END ELSE IF EXISTS(	SELECT NULL 
					FROM Products
					WHERE ProductID = @ProductID 
				
					) BEGIN		--UPDATE
		UPDATE dbo.Products
		SET CategoryID = @CategoryID, ProductCode = @ProductCode, [Description] = @Description, ListPrice = @ListPrice, DiscountPercent = @DiscountPercent, 
							DateAdded = @DateAdded
		WHERE ProductID = @ProductID
		SELECT [success] = @ProductID
	
	END ELSE BEGIN
		SELECT [success] = 0
	END
END