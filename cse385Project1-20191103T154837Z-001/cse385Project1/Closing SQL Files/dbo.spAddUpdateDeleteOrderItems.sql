CREATE PROCEDURE [spAddUpdateDeleteOrderItems]
	@ItemID int,
	@OrderID int,
	@ProductID int,
	@ItemPrice money,
	@DiscountAmount money,
	@Quantity int,
	@Delete bit = 0

AS

SET NOCOUNT ON

BEGIN
	IF @ItemID = 0 BEGIN		--ADD

		INSERT INTO OrderItems(OrderID, ProductID, ItemPrice, DiscountAmount, Quantity)
		VALUES (@OrderID, @ProductID, @ItemPrice, @DiscountAmount, @Quantity)
		SELECT [success] = @@IDENTITY

	END	ELSE IF @Delete = 1 BEGIN		--DELETE
			DELETE FROM OrderItems WHERE ItemID = @ItemID
			SELECT [success] = 1
		END ELSE BEGIN
			SELECT [success] = 0
		END
	END 
	
	IF EXISTS(	SELECT NULL 
					FROM OrderItems
					WHERE ItemID = @ItemID 
				
					) BEGIN		--UPDATE
		UPDATE dbo.OrderItems
		SET OrderID = @OrderID, ProductID = @ProductID, ItemPrice = @ItemPrice, DiscountAmount = @DiscountAmount, Quantity = @Quantity
		WHERE ItemID = @ItemID
		SELECT [success] = @ItemID
	
	END ELSE BEGIN
		SELECT [success] = 0
	END