CREATE PROCEDURE [spAddUpdateDeleteOrders]
	@OrderID int,
	@CustomerID int,
	@OrderDate datetime,
	@ShipAmount money,
	@TaxAmount money,
	@ShipDate datetime,
	@ShipAddressID int,
	@CardType varchar(50),
	@CardNumber char(16),
	@CardExpires char(7),
	@BillingAddressID int,
	@Delete bit = 0

AS

SET NOCOUNT ON

BEGIN
	IF @OrderID = 0 BEGIN

		INSERT INTO Orders(CustomerID, OrderDate, ShipAmount, TaxAmount, ShipDate, ShipAddressID, CardType, CardNumber, CardExpires, BillingAddressID)
		VALUES (@CustomerID, @OrderDate, @ShipAmount, @TaxAmount, @ShipDate, @ShipAddressID, @CardType, @CardNumber, @CardExpires, @BillingAddressID)
		SELECT [success] = @@IDENTITY

	END	ELSE IF @Delete = 1 BEGIN
		IF NOT EXISTS( 
						SELECT	top(1) NULL 
						FROM	OrderItems AS i, Orders AS o
						WHERE	i.OrderID = @OrderID OR
								o.OrderID = @OrderID
								
					) BEGIN
							DELETE FROM Orders WHERE OrderID = @OrderID
							SELECT [success] = 1
		END ELSE BEGIN
			SELECT [success] = 0
		END
	END ELSE IF EXISTS(	SELECT NULL 
					FROM Orders
					WHERE OrderID = @OrderID 
				
					) BEGIN
		UPDATE dbo.Orders
		SET CustomerID = @CustomerID, OrderDate = @OrderDate, ShipAmount = @ShipAmount, TaxAmount = @TaxAmount, ShipDate = @ShipDate, 
							ShipAddressID = @ShipAddressID, CardType = @CardType, CardNumber = @CardNumber, CardExpires = @CardExpires,
							BillingAddressID = @BillingAddressID
		WHERE OrderID = @OrderID
		SELECT [success] = @OrderID
	
	END ELSE BEGIN
		SELECT [success] = 0
	END
END