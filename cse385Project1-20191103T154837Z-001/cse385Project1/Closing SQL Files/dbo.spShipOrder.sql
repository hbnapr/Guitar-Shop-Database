CREATE PROCEDURE [spShipOrder]
	@OrderID int,
	@ShipDate datetime

AS

SET NOCOUNT ON

BEGIN
	
	IF EXISTS(	SELECT NULL 
					FROM Orders
					WHERE OrderID = @OrderID 
				
					) BEGIN
		UPDATE dbo.Orders
		SET ShipDate = @ShipDate
		WHERE OrderID = @OrderID
		SELECT [success] = @OrderID
	
	END ELSE BEGIN
		SELECT [success] = 0
	END
END