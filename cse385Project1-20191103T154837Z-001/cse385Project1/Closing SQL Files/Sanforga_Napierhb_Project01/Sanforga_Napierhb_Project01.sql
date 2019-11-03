USE MyGuitarShop

GO
CREATE PROCEDURE spGetAddressByAddressID
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select *
FROM Addresses
WHERE (
		cast(AddressID as varchar(5)))
		LIKE @SearchValue
ORDER BY AddressID, CustomerID

GO
CREATE PROCEDURE spGetAddressByCustomerID
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select *
FROM Addresses
WHERE (
		cast(CustomerID as varchar(5)))
		LIKE @SearchValue
ORDER BY CustomerID

GO
CREATE PROCEDURE spGetAddressByState
	@SearchValue varchar(50)

AS

SET NOCOUNT ON


Select *
FROM Addresses
WHERE (
		State)
		LIKE ('%' + @SearchValue + '%')
ORDER BY City, CustomerID

GO
CREATE PROCEDURE spGetAdminByName
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select (LastName + ', ' + FirstName) AS Name, EmailAddress
FROM Administrators
WHERE (
		FirstName +
		' ' +
		LastName)
		LIKE ('%' + @SearchValue + '%')
ORDER BY LastName, FirstName

GO
CREATE PROCEDURE spGetCategoryByName
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select *
FROM Categories
WHERE (
		CategoryName)
		LIKE ('%' + @SearchValue + '%')
ORDER BY CategoryName

GO
CREATE PROCEDURE [spGetCustomerByName]
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select	CustomerID, (LastName + ', ' + FirstName) AS Name, 
		EmailAddress, ShippingAddressID, BillingAddressID
FROM Customers
WHERE (
		FirstName +
		' ' +
		LastName)
		LIKE ('%' + @SearchValue + '%')
ORDER BY LastName, FirstName

GO
CREATE PROCEDURE spGetOrderByCustomerID
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select OrderID, CustomerID, Convert(varchar(11), cast(OrderDate as varchar(11))) AS OrderDate, ShipAmount, TaxAmount, 
		Convert(varchar(11), cast(ShipDate as varchar(11))) AS ShipDate, ShipAddressID, CardType, CardNumber, CardExpires, BillingAddressID 
FROM Orders
WHERE (
		cast(CustomerID as varchar(5)))
		LIKE @SearchValue
ORDER BY OrderDate

GO
CREATE PROCEDURE spGetOrderByOrderDate
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select	OrderID, CustomerID, Convert(varchar(11), cast(OrderDate as varchar(11))) AS OrderDate, ShipAmount, TaxAmount, 
		Convert(varchar(11), cast(ShipDate as varchar(11))) AS ShipDate, ShipAddressID, CardType, CardNumber, CardExpires, BillingAddressID
FROM Orders
WHERE Cast([OrderDate] AS DATE) = Cast(@SearchValue As DATE)
ORDER BY OrderDate, CustomerID

GO
CREATE PROCEDURE spGetOrderByOrderDateRange
	@StartDate varchar(50),
	@EndDate varchar(50)

AS

SET NOCOUNT ON

Select	OrderID, CustomerID, Convert(varchar(11), cast(OrderDate as varchar(11))) AS OrderDate, ShipAmount, TaxAmount, 
		Convert(varchar(11), cast(ShipDate as varchar(11))) AS ShipDate, ShipAddressID, CardType, CardNumber, CardExpires, BillingAddressID
FROM Orders
WHERE CAST([OrderDate] AS DATE) BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE)
ORDER BY OrderDate, CustomerID

GO
CREATE PROCEDURE spGetOrderByShipDate
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select	OrderID, CustomerID, Convert(varchar(11), cast(OrderDate as varchar(11))) AS OrderDate, ShipAmount, TaxAmount, 
		Convert(varchar(11), cast(ShipDate as varchar(11))) AS ShipDate, ShipAddressID, CardType, CardNumber, CardExpires, BillingAddressID
FROM Orders
WHERE CAST([ShipDate] AS DATE) = CAST(@SearchValue AS DATE)
ORDER BY ShipDate, CustomerID

GO
CREATE PROCEDURE spGetOrderByShipDateRange
	@StartDate varchar(50),
	@EndDate varchar(50)

AS

SET NOCOUNT ON

Select OrderID, CustomerID, Convert(varchar(11), cast(OrderDate as varchar(11))) AS OrderDate, ShipAmount, TaxAmount, 
		Convert(varchar(11), cast(ShipDate as varchar(11))) AS ShipDate, ShipAddressID, CardType, CardNumber, CardExpires, BillingAddressID
FROM Orders
WHERE CAST([ShipDate] AS DATE) BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE)
ORDER BY ShipDate, CustomerID

GO
CREATE PROCEDURE spGetOrderItemsByOrderID
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select	ItemID, OrderID, ProductID, ItemPrice, DiscountAmount, Quantity
FROM OrderItems
WHERE (
		cast(OrderID as varchar(5)))
		LIKE @SearchValue 
ORDER BY OrderID

GO
CREATE PROCEDURE spGetOrderItemsByProductID
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select ItemID, OrderID, ProductID, ItemPrice, DiscountAmount, Quantity
FROM OrderItems
WHERE (
		cast(ProductID as varchar(5)))
		LIKE @SearchValue
ORDER BY ProductID

GO
CREATE PROCEDURE spGetProductByCategoryID
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select	ProductID, CategoryID, ProductCode, ProductName, Description, 
		ListPrice, DiscountPercent, 
		Convert(varchar(11), cast(DateAdded as varchar(11))) AS DateAdded
FROM Products
WHERE (
		cast(CategoryID as varchar(20)))
		LIKE @SearchValue
ORDER BY CategoryID

GO
CREATE PROCEDURE spGetProductByDateAdded
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select	ProductID, CategoryID, ProductCode, ProductName, Description, 
		ListPrice, DiscountPercent, 
		Convert(varchar(11), cast(DateAdded as varchar(11))) AS DateAdded
FROM Products
WHERE CAST([DateAdded] AS DATE) = CAST(@SearchValue AS DATE)
ORDER BY DateAdded, ProductID

GO
CREATE PROCEDURE spGetProductByDateAddedRange
	@StartDate varchar(50),
	@EndDate varchar(50)

AS

SET NOCOUNT ON

Select	ProductID, CategoryID, ProductCode, ProductName, Description, 
		ListPrice, DiscountPercent, 
		Convert(varchar(11), cast(DateAdded as varchar(11))) AS DateAdded
FROM Products
WHERE CAST([DateAdded] AS DATE) BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE)
ORDER BY DateAdded, ProductID

GO
CREATE PROCEDURE spGetProductByDiscountPercent
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select	ProductID, CategoryID, ProductCode, ProductName, Description, 
		ListPrice, DiscountPercent, 
		Convert(varchar(11), cast(DateAdded as varchar(11))) AS DateAdded
FROM Products
WHERE cast(DiscountPercent as varchar(20)) LIKE ('%' + @SearchValue + '%')
ORDER BY ProductID, ProductName, DateAdded

GO
CREATE PROCEDURE spGetProductByProductCode
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select	ProductID, CategoryID, ProductCode, ProductName, Description, 
		ListPrice, DiscountPercent, 
		Convert(varchar(11), cast(DateAdded as varchar(11))) AS DateAdded
FROM Products
WHERE ProductCode LIKE ('%' + @SearchValue + '%')
ORDER BY ProductID, DateAdded

GO
CREATE PROCEDURE spGetProductByProductID
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select	ProductID, CategoryID, ProductCode, ProductName, Description, 
		ListPrice, DiscountPercent, 
		Convert(varchar(11), cast(DateAdded as varchar(11))) AS DateAdded
FROM Products
WHERE (
		cast(ProductID as varchar(20)))
		LIKE @SearchValue 
ORDER BY ProductID

GO
CREATE PROCEDURE spGetProductByProductName
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select	ProductID, CategoryID, ProductCode, ProductName, Description, 
		ListPrice, DiscountPercent, 
		Convert(varchar(11), cast(DateAdded as varchar(11))) AS DateAdded
FROM Products
WHERE ProductName LIKE ('%' + @SearchValue + '%')
ORDER BY ProductID, ProductName, DateAdded

GO
CREATE PROCEDURE spGetTotalOrderCostByCustomer
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

SELECT	o.OrderID, (LastName + ', ' + FirstName) AS Name,
		'$' + CONVERT(varchar(12),CAST(SUM(((ItemPrice - DiscountAmount) * Quantity) + ShipAmount + TaxAmount) as MONEY),1) AS TotalOrderCost,
		Convert(varchar(11), cast(OrderDate as varchar(11))) AS OrderDate, 
		ShipAddressID, CardType, CardNumber, CardExpires, o.BillingAddressID
FROM Customers c
		JOIN Orders o 
			ON c.CustomerID = o.CustomerID
		JOIN OrderItems i
			ON o.OrderID = i.OrderID 
WHERE (
		FirstName +
		' ' +
		LastName)
		LIKE ('%' + @SearchValue + '%')
GROUP BY o.OrderID, LastName, FirstName, OrderDate, ShipAddressID, CardType, CardNumber, CardExpires, o.BillingAddressID
ORDER BY OrderDate, TotalOrderCost

GO
CREATE PROCEDURE spGetTotalOrderCostByCustomerAndOrderDateRange
	@SearchValue varchar(50),
	@StartDate varchar(50),
	@EndDate varchar(50)

AS

SET NOCOUNT ON

SELECT	o.OrderID, (LastName + ', ' + FirstName) AS Name,
		'$' + CONVERT(varchar(12),CAST(SUM(((ItemPrice - DiscountAmount) * Quantity) + ShipAmount + TaxAmount) as MONEY),1) AS TotalOrderCost,
		Convert(varchar(11), cast(OrderDate as varchar(11))) AS OrderDate, 
		ShipAddressID, CardType, CardNumber, CardExpires, o.BillingAddressID
FROM Customers c
		JOIN Orders o 
			ON c.CustomerID = o.CustomerID
		JOIN OrderItems i
			ON o.OrderID = i.OrderID 
WHERE ((
		FirstName +
		' ' +
		LastName)
		LIKE ('%' + @SearchValue + '%'))
		AND CAST([OrderDate] AS DATE) BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE)
GROUP BY o.OrderID, LastName, FirstName, OrderDate, ShipAddressID, CardType, CardNumber, CardExpires, o.BillingAddressID
ORDER BY OrderDate, TotalOrderCost

GO
CREATE PROCEDURE spGetTotalOrderCostByOrderDateRange
	@StartDate datetime,
	@EndDate datetime

AS

SET NOCOUNT ON

SELECT '$' + CONVERT(varchar(12),CAST(SUM(((ItemPrice - DiscountAmount) * Quantity) + ShipAmount + TaxAmount) as MONEY),1)  AS TotalOrderCost
FROM Orders o
		JOIN OrderItems i
			ON o.OrderID = i.OrderID 
WHERE [OrderDate] BETWEEN @StartDate AND @EndDate

GO
CREATE PROCEDURE [spAddDeleteCustomers]
	@CustomerID int,
	@EmailAddress varchar(255),
	@Password varchar(60),
	@FirstName varchar(60),
	@LastName varchar(60),
	@Delete bit = 0

AS

SET NOCOUNT ON

IF @CustomerID = 0 BEGIN		--ADD

		INSERT INTO Customers(EmailAddress, [Password], FirstName, LastName)
		VALUES (@EmailAddress, @Password, @FirstName, @LastName)
		SELECT [success] = @@IDENTITY

	END	ELSE IF @Delete = 1 BEGIN		--DELETE
		IF NOT EXISTS( 
						SELECT	top(1) NULL 
						FROM	Customers AS c, Orders AS o, Addresses as a
						WHERE	
								o.CustomerID = @CustomerID OR
								a.CustomerID = @CustomerID
					) BEGIN
							DELETE FROM Customers WHERE CustomerID = @CustomerID
							SELECT [success] = 1
		END ELSE BEGIN
			SELECT [success] = 0
		END
END

GO
CREATE PROCEDURE [spAddUpdateDeleteAddresses]
	@AddressID int,
	@CustomerID int,
	@Line1 varchar(60),
	@Line2 varchar(60),
	@City varchar(40),
	@State varchar(2),
	@ZipCode varchar(10),
	@Phone varchar(12),
	@Disabled int,
	@Delete bit = 0

AS

SET NOCOUNT ON


BEGIN
	IF @AddressID = 0 BEGIN		--ADD

		INSERT INTO Addresses(CustomerID, Line1, Line2, City, [State], ZipCode, Phone, [Disabled])
		VALUES (@CustomerID, @Line1, @Line2, @City, @State, @ZipCode, @Phone, @Disabled)
		SELECT [success] = @@IDENTITY

	END	ELSE IF @Delete = 1 BEGIN	--DELETE
		IF NOT EXISTS( 
						SELECT	top(1) NULL 
						FROM	Customers AS c, Orders AS o 
						WHERE	c.ShippingAddressID = @AddressID OR
								o.ShipAddressID = @AddressID
					) BEGIN
							DELETE FROM Addresses WHERE AddressID = @AddressID
							SELECT [success] = 1
		END ELSE BEGIN
			SELECT @Disabled = 1
			SELECT [success] = 1
		END
	END ELSE IF EXISTS(	SELECT NULL 
					FROM Addresses
					WHERE AddressID = @AddressID 
				
					) BEGIN		--UPDATE
		UPDATE dbo.Addresses
		SET CustomerID = @CustomerID, Line1 = @Line1, Line2 = @Line2, City = @City, [State] = @State, ZipCode = @ZipCode, Phone = @Phone, [Disabled] = @Disabled
		WHERE AddressID = @AddressID
		SELECT [success] = @AddressID
	
	END ELSE BEGIN
		SELECT [success] = 0
	END
END

GO
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

	GO
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

	GO
	CREATE PROCEDURE [spAddUpdateDeleteCustomers]
	@CustomerID int,
	@EmailAddress varchar(255),
	@Password varchar(60),
	@FirstName varchar(60),
	@LastName varchar(60),
	@ShippingAddressID int,
	@BillingAddressID int,
	@Delete bit = 0

AS

SET NOCOUNT ON

BEGIN
	IF @CustomerID = 0 BEGIN		--ADD

		INSERT INTO Customers(EmailAddress, [Password], FirstName, LastName, ShippingAddressID, BillingAddressID)
		VALUES (@EmailAddress, @Password, @FirstName, @LastName, @ShippingAddressID, @BillingAddressID)
		SELECT [success] = @@IDENTITY

	END	ELSE IF @Delete = 1 BEGIN		--DELETE
		IF NOT EXISTS( 
						SELECT	top(1) NULL 
						FROM	Orders AS o, Addresses as a
						WHERE	
								o.CustomerID = @CustomerID OR
								a.CustomerID = @CustomerID
					) BEGIN
							DELETE FROM Customers WHERE CustomerID = @CustomerID
							SELECT [success] = 1
		END ELSE BEGIN
			SELECT [success] = 0
		END
	END ELSE IF EXISTS(	SELECT NULL 
					FROM Customers
					WHERE CustomerID = @CustomerID 
				
					) BEGIN		--UPDATE
		UPDATE dbo.Customers
		SET EmailAddress = @EmailAddress, [Password] = @Password, FirstName = @FirstName, LastName = @LastName, ShippingAddressID = @ShippingAddressID, BillingAddressID = @BillingAddressID
		WHERE CustomerID = @CustomerID
		SELECT [success] = @CustomerID
	
	END ELSE BEGIN
		SELECT [success] = 0
	END
END

GO
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

	GO
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
	IF @OrderID = 0 BEGIN		--ADD

		INSERT INTO Orders(CustomerID, OrderDate, ShipAmount, TaxAmount, ShipDate, ShipAddressID, CardType, CardNumber, CardExpires, BillingAddressID)
		VALUES (@CustomerID, @OrderDate, @ShipAmount, @TaxAmount, @ShipDate, @ShipAddressID, @CardType, @CardNumber, @CardExpires, @BillingAddressID)
		SELECT [success] = @@IDENTITY

	END	ELSE IF @Delete = 1 BEGIN		--DELETE
		IF NOT EXISTS( 
						SELECT	top(1) NULL 
						FROM	OrderItems AS i
						WHERE	i.OrderID = @OrderID
								
								
					) BEGIN
							DELETE FROM Orders WHERE OrderID = @OrderID
							SELECT [success] = 1
		END ELSE BEGIN
			SELECT [success] = 0
		END
	END ELSE IF EXISTS(	SELECT NULL 
					FROM Orders
					WHERE OrderID = @OrderID 
				
					) BEGIN		--UPDATE
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

GO
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

GO
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

GO
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

GO
CREATE PROCEDURE spUpdateDeleteBillingAddress
	@CustomerID int,
	@BillingAddressID int = NULL,
	@Delete bit = 0
AS
	IF(@Delete = 1)		SELECT @BillingAddressID = NULL
						SELECT [success] = 1
	IF( (@BillingAddressID IS NULL) OR
		(EXISTS(SELECT NULL FROM Addresses WHERE AddressID = @BillingAddressID)))
			UPDATE Customers
			SET BillingAddressID = @BillingAddressID
			WHERE CustomerID = @CustomerID

GO
CREATE PROCEDURE spUpdateDeleteShippingAddress
	@CustomerID int,
	@ShippingAddressID int = NULL,
	@Delete bit = 0
AS
	IF(@Delete = 1)		SELECT @ShippingAddressID = NULL
						SELECT [success] = 1

	IF( (@ShippingAddressID IS NULL) OR
		(EXISTS(SELECT NULL FROM Addresses WHERE AddressID = @ShippingAddressID)))
			UPDATE Customers
			SET ShippingAddressID = @ShippingAddressID
			WHERE CustomerID = @CustomerID