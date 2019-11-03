using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;

/// <summary>
/// Girard Sanford and Heath Napier
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
public class WebService : System.Web.Services.WebService {

	#region ========================================================================================================================== Constants

	// These are just some variations of styles you could use for the web service page
	private const string description = "<div style='font-weight:bold;margin-bottom:20px;margin-top:5px;margin-left:20px;color:black;background-color:#d4d9de;border:solid 1px grey;padding:3px 3px 3px 3px;padding:10px;border-radius:5px;max-width:60%;box-shadow: 0 2px 2px 0 #C2C2C2;'>";
	private const string descriptionNew = "<div style='font-weight:bold;margin-bottom:20px;margin-top:5px;margin-left:20px;color:white;background-color:green;border:solid 1px grey;padding:3px 3px 3px 3px;padding:10px;border-radius:5px;max-width:60%;box-shadow: 0 2px 2px 0 #C2C2C2;'>(NEW) ";
	private const string descriptionUpdated = "<div style='font-weight:bold;margin-bottom:20px;margin-top:5px;margin-left:20px;color:black;background-color:pink;border:solid 1px grey;padding:3px 3px 3px 3px;padding:10px;border-radius:5px;max-width:60%;box-shadow: 0 2px 2px 0 #C2C2C2;'>(Updated) ";

	#endregion

	#region ========================================================================================================================== General Stuff / dB

	private string conn = System.Configuration.ConfigurationManager.ConnectionStrings["connStr"].ConnectionString;
	private List<SqlParameter> parameters = new List<SqlParameter>();

	private DataTable doSqlExec(string sql, CommandType ct) {
		DataSet userDataset = new DataSet();
		try {
			using (SqlConnection objConn = new SqlConnection(conn)) {
				SqlDataAdapter myCommand = new SqlDataAdapter(sql, objConn);
				myCommand.SelectCommand.CommandType = ct;
				myCommand.SelectCommand.Parameters.AddRange(parameters.ToArray());
				myCommand.Fill(userDataset);
				parameters.Clear();
			}
		} catch (Exception e) {
			userDataset.Tables.Add();
			setDataTableToError(userDataset.Tables[0], e);
		}
		if (userDataset.Tables.Count == 0) userDataset.Tables.Add();
		return userDataset.Tables[0];
	}

	private DataTable sqlExec(string sql) {
		return doSqlExec(sql, CommandType.Text);
	}

	private DataTable spExec(string sql) {
		return doSqlExec(sql, CommandType.StoredProcedure );
	}

	// This method is used by the above method to insert an Error row if needed
	private void setDataTableToError(DataTable tbl, Exception e) {
		tbl.Columns.Add(new DataColumn("Error", typeof(String)));
		DataRow row = tbl.NewRow();
		row["Error"] = e.Message;
		try {
			tbl.Rows.Add(row);
		} catch (Exception) { }
	}

	// Simple method to serialize an object into a JSON string and write it to the stream
	private void serialize(Object obj) {
		streamJson(new JavaScriptSerializer().Serialize(obj));
	}

	// Streams out a JSON string
	private void streamJson(string jsonString) {
		Context.Response.Clear();
		Context.Response.ContentType = "application/json";
		Context.Response.Write(jsonString);
		Context.Response.Flush();
		HttpContext.Current.ApplicationInstance.CompleteRequest();
	}

	// A method that will take a DataTable and convert it into a Dictionary objects of rows.
	private void SerializeDataTable(DataTable dt) {
		List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
		Dictionary<string, object> row;

		row = new Dictionary<string, object>();
		foreach (DataRow dr in dt.Rows) {
			row = new Dictionary<string, object>();
			foreach (DataColumn col in dt.Columns)
				row.Add(col.ColumnName, dr[col]);
			rows.Add(row);
		}
		serialize(rows);
	}

    #endregion

    #region ========================================================================================================================== Web Methods

    [WebMethod(Description = description + "Search Addresses by AddressID Number")]
    public void GetAddressByAddressID(string Search)
    {
        parameters.Add(new SqlParameter("@SearchValue", Search));
        SerializeDataTable(spExec("spGetAddressByAddressID"));
    }

    [WebMethod(Description = description + "Search Addresses by CustomerID Number")]
    public void GetAddressByCustomerID(string Search)
    {
        parameters.Add(new SqlParameter("@SearchValue", Search));
        SerializeDataTable(spExec("spGetAddressByCustomerID"));
    }

    [WebMethod(Description = description + "Search Addresses by Two-Letter State code, i.e. MI, OH, etc")]
    public void GetAddressByState(string Search)
    {
        parameters.Add(new SqlParameter("@SearchValue", Search));
        SerializeDataTable(spExec("spGetAddressByState"));
    }

    [WebMethod(Description = description + "Search Administrators by Name")]
    public void GetAdminByName(string Search)
    {
        parameters.Add(new SqlParameter("@SearchValue", Search));
        SerializeDataTable(spExec("spGetAdminByName"));
    }

    [WebMethod(Description = description + "Search Categories by Name")]
    public void GetCategoryByName(string Search)
    {
        parameters.Add(new SqlParameter("@SearchValue", Search));
        SerializeDataTable(spExec("spGetCategoryByName"));
    }

    [WebMethod(Description = description + "Search Customers by Name")]
    public void GetCustomerByName(string Search)
    {
        parameters.Add(new SqlParameter("@SearchValue", Search));
        SerializeDataTable(spExec("spGetCustomerByName"));
    }

    [WebMethod(Description = description + "Search Orders By CustomerID")]
    public void GetOrderByCustomerID(string Search)
    {
        parameters.Add(new SqlParameter("@SearchValue", Search));
        SerializeDataTable(spExec("spGetOrderByCustomerID"));
    }

    [WebMethod(Description = description + "Search Orders By OrderDate, Use mm/dd/yyyy format")]
    public void GetOrderByOrderDate(string Search)
    {
        parameters.Add(new SqlParameter("@SearchValue", Search));
        SerializeDataTable(spExec("spGetOrderByOrderDate"));
    }

    [WebMethod(Description = description + "Search Orders using a date range, Use mm/dd/yyyy format")]
    public void GetOrderByOrderDateRange(string StartDate, string EndDate)
    {
        parameters.Add(new SqlParameter("@StartDate", StartDate));
        parameters.Add(new SqlParameter("@EndDate", EndDate));
        SerializeDataTable(spExec("spGetOrderByOrderDateRange"));
    }

    [WebMethod(Description = description + "Search Orders By ShipDate, Use mm/dd/yyyy format")]
    public void GetOrderByShipDate(string Search)
    {
        parameters.Add(new SqlParameter("@SearchValue", Search));
        SerializeDataTable(spExec("spGetOrderByShipDate"));
    }

    [WebMethod(Description = description + "Search Orders by ShipDate using a date range, Use mm/dd/yyyy format")]
    public void GetOrderByShipDateRange(string StartDate, string EndDate)
    {
        parameters.Add(new SqlParameter("@StartDate", StartDate));
        parameters.Add(new SqlParameter("@EndDate", EndDate));
        SerializeDataTable(spExec("spGetOrderByShipDateRange"));
    }

    [WebMethod(Description = description + "Search OrderItems By OrderID")]
    public void GetOrderItemsByOrderID(string Search)
    {
        parameters.Add(new SqlParameter("@SearchValue", Search));
        SerializeDataTable(spExec("spGetOrderItemsByOrderID"));
    }

    [WebMethod(Description = description + "Search OrderItems By ProductID")]
    public void GetOrderItemsByProductID(string Search)
    {
        parameters.Add(new SqlParameter("@SearchValue", Search));
        SerializeDataTable(spExec("spGetOrderItemsByProductID"));
    }

    [WebMethod(Description = description + "Search Products By CategoryID")]
    public void GetProductByCategoryID(string Search)
    {
        parameters.Add(new SqlParameter("@SearchValue", Search));
        SerializeDataTable(spExec("spGetProductByCategoryID"));
    }

    [WebMethod(Description = description + "Search Products By DateAdded, Use mm/dd/yyyy format")]
    public void GetProductByDateAdded(string Search)
    {
        parameters.Add(new SqlParameter("@SearchValue", Search));
        SerializeDataTable(spExec("spGetProductByDateAdded"));
    }

    [WebMethod(Description = description + "Search Products By DateAdded using a date range, Use mm/dd/yyyy format")]
    public void GetProductByDateAddedRange(string StartDate, string EndDate)
    {
        parameters.Add(new SqlParameter("@StartDate", StartDate));
        parameters.Add(new SqlParameter("@EndDate", EndDate));
        SerializeDataTable(spExec("spGetProductByDateAddedRange"));
    }

    [WebMethod(Description = description + "Search Products By DiscountPercent")]
    public void GetProductByDiscountPercent(string Search)
    {
        parameters.Add(new SqlParameter("@SearchValue", Search));
        SerializeDataTable(spExec("spGetProductByDiscountPercent"));
    }

    [WebMethod(Description = description + "Search Products By ProductCode")]
    public void GetProductByProductCode(string Search)
    {
        parameters.Add(new SqlParameter("@SearchValue", Search));
        SerializeDataTable(spExec("spGetProductByProductCode"));
    }

    [WebMethod(Description = description + "Search Products By ProductID")]
    public void GetProductByProductID(string Search)
    {
        parameters.Add(new SqlParameter("@SearchValue", Search));
        SerializeDataTable(spExec("spGetProductByProductID"));
    }

    [WebMethod(Description = description + "Search Products By ProductName")]
    public void GetProductByProductName(string Search)
    {
        parameters.Add(new SqlParameter("@SearchValue", Search));
        SerializeDataTable(spExec("spGetProductByProductName"));
    }

    [WebMethod(Description = description + "Find the Total Order Cost for each Customer's order by CustomerName")]
    public void GetTotalOrderCostByCustomer(string Search)
    {
        parameters.Add(new SqlParameter("@SearchValue", Search));
        SerializeDataTable(spExec("spGetTotalOrderCostByCustomer"));
    }

    [WebMethod(Description = description + "Find the Total Order Cost for each Customer's order by CustomerName and desired date range")]
    public void GetTotalOrderCostByCustomerAndOrderDateRange(string Search, string StartDate, string EndDate)
    {
        parameters.Add(new SqlParameter("@SearchValue", Search));
        parameters.Add(new SqlParameter("@StartDate", StartDate));
        parameters.Add(new SqlParameter("@EndDate", EndDate));
        SerializeDataTable(spExec("spGetTotalOrderCostByCustomerAndOrderDateRange"));
    }

    [WebMethod(Description = description + "Find the Total Cost of all orders in a given date range")]
    public void GetTotalOrderCostByOrderDateRange(string StartDate, string EndDate)
    {
        parameters.Add(new SqlParameter("@StartDate", StartDate));
        parameters.Add(new SqlParameter("@EndDate", EndDate));
        SerializeDataTable(spExec("spGetTotalOrderCostByOrderDateRange"));
    }

    [WebMethod(Description = description + "Add New Administrator with AdminID = 0. Update using existing AdminID")]
    public void addUpdateAdministrators(int adminID, string emailAddress, string password, string firstName, string lastName)
    {
        parameters.Add(new SqlParameter("@AdminID", adminID));
        parameters.Add(new SqlParameter("@EmailAddress", emailAddress));
        parameters.Add(new SqlParameter("@Password", password));
        parameters.Add(new SqlParameter("@FirstName", firstName));
        parameters.Add(new SqlParameter("@LastName", lastName));
        SerializeDataTable(spExec("spAddUpdateDeleteAdministrators"));
    }

    [WebMethod(Description = description + "Delete Administrator with AdminID")]
    public void deleteAdministrators(int adminID)
    {
        int one = 1;

        parameters.Add(new SqlParameter("@AdminID", adminID));
        parameters.Add(new SqlParameter("@EmailAddress", ""));
        parameters.Add(new SqlParameter("@Password", ""));
        parameters.Add(new SqlParameter("@FirstName", ""));
        parameters.Add(new SqlParameter("@LastName", ""));
        parameters.Add(new SqlParameter("@Delete", one));
        SerializeDataTable(spExec("spAddUpdateDeleteAdministrators"));
    }

    [WebMethod(Description = description + "Add New Address with AddressID = 0. Update using existing AddressID.")]
    public void addUpdateAddresses(int addressID, int customerID, string line1, string line2, string city, string state, string zipCode,
        string phone, int disabled)
    {
        parameters.Add(new SqlParameter("@AddressID", addressID));
        parameters.Add(new SqlParameter("@CustomerID", customerID));
        parameters.Add(new SqlParameter("@Line1", line1));
        parameters.Add(new SqlParameter("@Line2", line2));
        parameters.Add(new SqlParameter("@City", city));
        parameters.Add(new SqlParameter("@State", state));
        parameters.Add(new SqlParameter("@ZipCode", zipCode));
        parameters.Add(new SqlParameter("@Phone", phone));
        parameters.Add(new SqlParameter("@Disabled", disabled));
        SerializeDataTable(spExec("spAddUpdateDeleteAddresses"));
    }

    [WebMethod(Description = description + "Delete Address from a Customer.")]
    public void deleteAddresses(int addressID, int customerID)
    {
        parameters.Add(new SqlParameter("@AddressID", addressID));
        parameters.Add(new SqlParameter("@CustomerID", customerID));
        parameters.Add(new SqlParameter("@Line1", ""));
        parameters.Add(new SqlParameter("@Line2", ""));
        parameters.Add(new SqlParameter("@City", ""));
        parameters.Add(new SqlParameter("@State", ""));
        parameters.Add(new SqlParameter("@ZipCode", ""));
        parameters.Add(new SqlParameter("@Phone", ""));
        parameters.Add(new SqlParameter("@Disabled", 1));
        parameters.Add(new SqlParameter("@Delete", 1));
        SerializeDataTable(spExec("spAddUpdateDeleteAddresses"));
    }

    [WebMethod(Description = description + "Add new Category with CategoryID = 0, Update Category with existing CategoryID")]
    public void addUpdateCategories(int categoryID, string categoryName)
    {
        parameters.Add(new SqlParameter("@CategoryID", categoryID));
        parameters.Add(new SqlParameter("@CategoryName", categoryName));
        SerializeDataTable(spExec("spAddUpdateDeleteCategories"));
    }

    [WebMethod(Description = description + "Delete Category with CategoryID")]
    public void deleteCategories(int categoryID)
    {
        int one = 1;
        parameters.Add(new SqlParameter("@CategoryID", categoryID));
        parameters.Add(new SqlParameter("@CategoryName", ""));
        parameters.Add(new SqlParameter("@Delete", one));
        SerializeDataTable(spExec("spAddUpdateDeleteCategories"));
    }

    [WebMethod(Description = description + "Add new Customers.")]
    public void addCustomers(string emailAddress, string password, string firstName, string lastName)
    {
        int zero = 0;

        parameters.Add(new SqlParameter("@CustomerID", zero));
        parameters.Add(new SqlParameter("@EmailAddress", emailAddress));
        parameters.Add(new SqlParameter("@Password", password));
        parameters.Add(new SqlParameter("@FirstName", firstName));
        parameters.Add(new SqlParameter("@LastName", lastName));
        SerializeDataTable(spExec("spAddDeleteCustomers"));
    }

    [WebMethod(Description = description + "Delete existing Customers with CustomerID.")]
    public void deleteCustomers(int customerID)
    {
        int one = 1;

        parameters.Add(new SqlParameter("@CustomerID", customerID));
        parameters.Add(new SqlParameter("@EmailAddress", ""));
        parameters.Add(new SqlParameter("@Password", ""));
        parameters.Add(new SqlParameter("@FirstName", ""));
        parameters.Add(new SqlParameter("@LastName", ""));
        parameters.Add(new SqlParameter("@Delete", one));
        SerializeDataTable(spExec("spAddDeleteCustomers"));
    }

    [WebMethod(Description = description + "Update existing Customers with CustomerID.")]
    public void updateCustomers(int customerID, string emailAddress, string password, string firstName, string lastName)
    {
        parameters.Add(new SqlParameter("@CustomerID", customerID));
        parameters.Add(new SqlParameter("@EmailAddress", emailAddress));
        parameters.Add(new SqlParameter("@Password", password));
        parameters.Add(new SqlParameter("@FirstName", firstName));
        parameters.Add(new SqlParameter("@LastName", lastName));
        SerializeDataTable(spExec("spUpdateCustomers"));
    }

    [WebMethod(Description = description + "Changes Shipping Date of Order")]
    public void shipOrder(int orderID, DateTime shipDate)
    {
        parameters.Add(new SqlParameter("@OrderID", orderID));
        parameters.Add(new SqlParameter("@ShipDate", shipDate));
        SerializeDataTable(spExec("spShipOrder"));
    }

    [WebMethod(Description = description + "Update the Billing Address of a Customer.")]
    public void updateBillingAddress(int customerID, int billingAddressID)
    {
        parameters.Add(new SqlParameter("@CustomerID", customerID));
        parameters.Add(new SqlParameter("@BillingAddressID", billingAddressID));
        SerializeDataTable(spExec("spUpdateDeleteBillingAddress"));
    }

    [WebMethod(Description = description + "Delete the Billing Address of a Customer.")]
    public void deleteBillingAddress(int customerID)
    {
        int one = 1;
        parameters.Add(new SqlParameter("@CustomerID", customerID));
        parameters.Add(new SqlParameter("@BillingAddressID", ""));
        parameters.Add(new SqlParameter("@Delete", one));
        SerializeDataTable(spExec("spUpdateDeleteBillingAddress"));
    }

    [WebMethod(Description = description + "Update the Shipping Address of a Customer.")]
    public void updateShippingAddress(int customerID, int shippingAddressID)
    {
        parameters.Add(new SqlParameter("@CustomerID", customerID));
        parameters.Add(new SqlParameter("@ShippingAddressID", shippingAddressID));
        SerializeDataTable(spExec("spUpdateDeleteShippingAddress"));
    }

    [WebMethod(Description = description + "Delete the Shipping Address of a Customer.")]
    public void deleteShippingAddress(int customerID)
    {

        int one = 1;
        parameters.Add(new SqlParameter("@CustomerID", customerID));
        parameters.Add(new SqlParameter("@ShippingAddressID", ""));
        parameters.Add(new SqlParameter("@Delete", one));
        SerializeDataTable(spExec("spUpdateDeleteShippingAddress"));
    }

    [WebMethod(Description = description + "Add new Order Items.")]
    public void addOrderItems(int orderID, int productID, double itemPrice, double discountAmount,
                                int quantity)
    {
        int zero = 0;

        parameters.Add(new SqlParameter("@ItemID", zero));
        parameters.Add(new SqlParameter("@OrderID", orderID));
        parameters.Add(new SqlParameter("@ProductID", productID));
        parameters.Add(new SqlParameter("@ItemPrice", itemPrice));
        parameters.Add(new SqlParameter("@DiscountAmount", discountAmount));
        parameters.Add(new SqlParameter("@Quantity", quantity));
        SerializeDataTable(spExec("spAddUpdateDeleteOrderItems"));
    }

    [WebMethod(Description = description + "Update existing Order Items.")]
    public void updateOrderItems(int itemID, int orderID, int productID, double itemPrice, double discountAmount,
                                int quantity)
    {
        parameters.Add(new SqlParameter("@ItemID", itemID));
        parameters.Add(new SqlParameter("@OrderID", orderID));
        parameters.Add(new SqlParameter("@ProductID", productID));
        parameters.Add(new SqlParameter("@ItemPrice", itemPrice));
        parameters.Add(new SqlParameter("@DiscountAmount", discountAmount));
        parameters.Add(new SqlParameter("@Quantity", quantity));
        SerializeDataTable(spExec("spAddUpdateDeleteOrderItems"));
    }

    [WebMethod(Description = description + "Delete existing Order Items.")]
    public void deleteOrderItems(int itemID)
    {
        int one = 1;
        parameters.Add(new SqlParameter("@ItemID", itemID));
        parameters.Add(new SqlParameter("@OrderID", ""));
        parameters.Add(new SqlParameter("@ProductID", ""));
        parameters.Add(new SqlParameter("@ItemPrice", ""));
        parameters.Add(new SqlParameter("@DiscountAmount", ""));
        parameters.Add(new SqlParameter("@Quantity", ""));
        parameters.Add(new SqlParameter("@Delete", one));
        SerializeDataTable(spExec("spAddUpdateDeleteOrderItems"));
    }

    [WebMethod(Description = description + "Add new Orders.")]
    public void addOrders(int customerID, DateTime orderDate, double shipAmount, double taxAmount, DateTime shipDate,
                                int shipAddressID, string cardType, string cardNumber, string cardExpires,
                                int billingAddressID)
    {
        int zero = 0;

        parameters.Add(new SqlParameter("@OrderID", zero));
        parameters.Add(new SqlParameter("@CustomerID", customerID));
        parameters.Add(new SqlParameter("@OrderDate", orderDate));
        parameters.Add(new SqlParameter("@ShipAmount", shipAmount));
        parameters.Add(new SqlParameter("@TaxAmount", taxAmount));
        parameters.Add(new SqlParameter("@ShipDate", shipDate));
        parameters.Add(new SqlParameter("@ShipAddressID", shipAddressID));
        parameters.Add(new SqlParameter("@CardType", cardType));
        parameters.Add(new SqlParameter("@CardNumber", cardNumber));
        parameters.Add(new SqlParameter("@CardExpires", cardExpires));
        parameters.Add(new SqlParameter("@BillingAddressID", billingAddressID));
        SerializeDataTable(spExec("spAddUpdateDeleteOrders"));
    }

    [WebMethod(Description = description + "Update existing Orders.")]
    public void updateOrders(int orderID, int customerID, DateTime orderDate, double shipAmount, double taxAmount,
                                DateTime shipDate, int shipAddressID, string cardType, string cardNumber,
                                string cardExpires, int billingAddressID)
    {
        parameters.Add(new SqlParameter("@OrderID", orderID));
        parameters.Add(new SqlParameter("@CustomerID", customerID));
        parameters.Add(new SqlParameter("@OrderDate", orderDate));
        parameters.Add(new SqlParameter("@ShipAmount", shipAmount));
        parameters.Add(new SqlParameter("@TaxAmount", taxAmount));
        parameters.Add(new SqlParameter("@ShipDate", shipDate));
        parameters.Add(new SqlParameter("@ShipAddressID", shipAddressID));
        parameters.Add(new SqlParameter("@CardType", cardType));
        parameters.Add(new SqlParameter("@CardNumber", cardNumber));
        parameters.Add(new SqlParameter("@CardExpires", cardExpires));
        parameters.Add(new SqlParameter("@BillingAddressID", billingAddressID));
        SerializeDataTable(spExec("spAddUpdateDeleteOrders"));
    }

    [WebMethod(Description = description + "Delete existing Orders.")]
    public void deleteOrders(int orderID)
    {

        int one = 1;
        parameters.Add(new SqlParameter("@OrderID", orderID));
        parameters.Add(new SqlParameter("@CustomerID", ""));
        parameters.Add(new SqlParameter("@OrderDate", ""));
        parameters.Add(new SqlParameter("@ShipAmount", ""));
        parameters.Add(new SqlParameter("@TaxAmount", ""));
        parameters.Add(new SqlParameter("@ShipDate", ""));
        parameters.Add(new SqlParameter("@ShipAddressID", ""));
        parameters.Add(new SqlParameter("@CardType", ""));
        parameters.Add(new SqlParameter("@CardNumber", ""));
        parameters.Add(new SqlParameter("@CardExpires", ""));
        parameters.Add(new SqlParameter("@BillingAddressID", ""));
        parameters.Add(new SqlParameter("@Delete", one));
        SerializeDataTable(spExec("spAddUpdateDeleteOrders"));
    }

    [WebMethod(Description = description + "Add new Products.")]
    public void addProducts(int categoryID, string productCode, string productName, string description, double listPrice,
                                double discountPercent, DateTime dateAdded)
    {
        int zero = 0;

        parameters.Add(new SqlParameter("@ProductID", zero));
        parameters.Add(new SqlParameter("@CategoryID", categoryID));
        parameters.Add(new SqlParameter("@ProductCode", productCode));
        parameters.Add(new SqlParameter("@ProductName", productName));
        parameters.Add(new SqlParameter("@Description", description));
        parameters.Add(new SqlParameter("@ListPrice", listPrice));
        parameters.Add(new SqlParameter("@DiscountPercent", discountPercent));
        parameters.Add(new SqlParameter("@DateAdded", dateAdded));
        SerializeDataTable(spExec("spAddUpdateDeleteProducts"));
    }

    [WebMethod(Description = description + "Update existing Products.")]
    public void updateProducts(int productID, int categoryID, string productCode, string productName, string description, double listPrice,
                                double discountPercent, DateTime dateAdded)
    {
        parameters.Add(new SqlParameter("@ProductID", productID));
        parameters.Add(new SqlParameter("@CategoryID", categoryID));
        parameters.Add(new SqlParameter("@ProductCode", productCode));
        parameters.Add(new SqlParameter("@ProductName", productName));
        parameters.Add(new SqlParameter("@Description", description));
        parameters.Add(new SqlParameter("@ListPrice", listPrice));
        parameters.Add(new SqlParameter("@DiscountPercent", discountPercent));
        parameters.Add(new SqlParameter("@DateAdded", dateAdded));
        SerializeDataTable(spExec("spAddUpdateDeleteProducts"));
    }

    [WebMethod(Description = description + "Delete existing Products.")]
    public void deleteProducts(int productID)
    {

        int one = 1;
        parameters.Add(new SqlParameter("@ProductID", productID));
        parameters.Add(new SqlParameter("@CategoryID", ""));
        parameters.Add(new SqlParameter("@ProductCode", ""));
        parameters.Add(new SqlParameter("@ProductName", ""));
        parameters.Add(new SqlParameter("@Description", ""));
        parameters.Add(new SqlParameter("@ListPrice", ""));
        parameters.Add(new SqlParameter("@DiscountPercent", ""));
        parameters.Add(new SqlParameter("@DateAdded", ""));
        parameters.Add(new SqlParameter("@Delete", one));
        SerializeDataTable(spExec("spAddUpdateDeleteProducts"));
    }

    #endregion


}
