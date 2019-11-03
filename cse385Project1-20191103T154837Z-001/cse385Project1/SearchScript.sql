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

Select *
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

Select OrderID, CustomerID, Convert(varchar(11), cast(OrderDate as varchar(11))) AS OrderDate, ShipAmount, TaxAmount, Convert(varchar(11), cast(ShipDate as varchar(11))) AS ShipDate, ShipAddressID, CardType, CardNumber, CardExpires, BillingAddressID
FROM Orders
WHERE Cast([OrderDate] AS DATE) = Cast(@SearchValue As DATE)
ORDER BY OrderDate, CustomerID

GO
CREATE PROCEDURE spGetOrderByOrderDateRange
	@StartDate varchar(50),
	@EndDate varchar(50)

AS

SET NOCOUNT ON

Select OrderID, CustomerID, Convert(varchar(11), cast(OrderDate as varchar(11))) AS OrderDate, ShipAmount, TaxAmount, Convert(varchar(11), cast(ShipDate as varchar(11))) AS ShipDate, ShipAddressID, CardType, CardNumber, CardExpires, BillingAddressID
FROM Orders
WHERE CAST([OrderDate] AS DATE) BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE)
ORDER BY OrderDate, CustomerID

GO
CREATE PROCEDURE spGetOrderByShipDate
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select OrderID, CustomerID, Convert(varchar(11), cast(OrderDate as varchar(11))) AS OrderDate, ShipAmount, TaxAmount, Convert(varchar(11), cast(ShipDate as varchar(11))) AS ShipDate, ShipAddressID, CardType, CardNumber, CardExpires, BillingAddressID
FROM Orders
WHERE CAST([ShipDate] AS DATE) = CAST(@SearchValue AS DATE)
ORDER BY ShipDate, CustomerID

GO
CREATE PROCEDURE spGetOrderByShipDateRange
	@StartDate varchar(50),
	@EndDate varchar(50)

AS

SET NOCOUNT ON

Select OrderID, CustomerID, Convert(varchar(11), cast(OrderDate as varchar(11))) AS OrderDate, ShipAmount, TaxAmount, Convert(varchar(11), cast(ShipDate as varchar(11))) AS ShipDate, ShipAddressID, CardType, CardNumber, CardExpires, BillingAddressID
FROM Orders
WHERE CAST([ShipDate] AS DATE) BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE)
ORDER BY ShipDate, CustomerID

GO
CREATE PROCEDURE spGetOrderItemByOrderID
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select *
FROM OrderItems
WHERE (
		cast(OrderID as varchar(5)))
		LIKE @SearchValue 
ORDER BY OrderID

GO
CREATE PROCEDURE spGetOrderItemByProductID
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select *
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

Select ProductID, CategoryID, ProductCode, ProductName, Description, ListPrice, DiscountPercent, Convert(varchar(11), cast(DateAdded as varchar(11))) AS DateAdded
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

Select ProductID, CategoryID, ProductCode, ProductName, Description, ListPrice, DiscountPercent, Convert(varchar(11), cast(DateAdded as varchar(11))) AS DateAdded
FROM Products
WHERE CAST([DateAdded] AS DATE) = CAST(@SearchValue AS DATE)
ORDER BY DateAdded, ProductID

GO
CREATE PROCEDURE spGetProductByDateAddedRange
	@StartDate varchar(50),
	@EndDate varchar(50)

AS

SET NOCOUNT ON

Select ProductID, CategoryID, ProductCode, ProductName, Description, ListPrice, DiscountPercent, Convert(varchar(11), cast(DateAdded as varchar(11))) AS DateAdded
FROM Products
WHERE CAST([DateAdded] AS DATE) BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE)
ORDER BY DateAdded, ProductID

GO
CREATE PROCEDURE spGetProductByDiscountPercent
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select ProductID, CategoryID, ProductCode, ProductName, Description, ListPrice, DiscountPercent, Convert(varchar(11), cast(DateAdded as varchar(11))) AS DateAdded
FROM Products
WHERE cast(DiscountPercent as varchar(20)) LIKE ('%' + @SearchValue + '%')
ORDER BY ProductID, ProductName, DateAdded

GO
CREATE PROCEDURE spGetProductByProductCode
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select ProductID, CategoryID, ProductCode, ProductName, Description, ListPrice, DiscountPercent, Convert(varchar(11), cast(DateAdded as varchar(11))) AS DateAdded
FROM Products
WHERE ProductCode LIKE ('%' + @SearchValue + '%')
ORDER BY ProductID, DateAdded

GO
CREATE PROCEDURE spGetProductByProductID
	@SearchValue varchar(50)

AS

SET NOCOUNT ON

Select ProductID, CategoryID, ProductCode, ProductName, Description, ListPrice, DiscountPercent, Convert(varchar(11), cast(DateAdded as varchar(11))) AS DateAdded
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

Select ProductID, CategoryID, ProductCode, ProductName, Description, ListPrice, DiscountPercent, Convert(varchar(11), cast(DateAdded as varchar(11))) AS DateAdded
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