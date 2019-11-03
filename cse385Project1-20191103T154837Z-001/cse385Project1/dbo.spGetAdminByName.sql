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