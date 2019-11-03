using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;

/// <summary>
/// Summary description for WebService
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

	[WebMethod(Description = description + "Add New Administrator with AdminID = 0. Update using existing AdminID")]
	public void addUpdateAdministrators(int adminID, string emailAddress, string password, string firstName, string lastName) {
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
        parameters.Add(new SqlParameter("@AdminID", adminID));
        parameters.Add(new SqlParameter("@EmailAddress", ""));
        parameters.Add(new SqlParameter("@Password", ""));
        parameters.Add(new SqlParameter("@FirstName", ""));
        parameters.Add(new SqlParameter("@LastName", ""));
        parameters.Add(new SqlParameter("@Delete", 1));
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

    [WebMethod(Description = description + "Add/Update Category with CategoryID")]
    public void addUpdateCategories(int categoryID, string categoryName)
    {
        parameters.Add(new SqlParameter("@CategoryID", categoryID));
        parameters.Add(new SqlParameter("@CategoryName", categoryName));
        SerializeDataTable(spExec("spAddUpdateDeleteCategories"));
    }

    [WebMethod(Description = description + "Delete Category with CategoryID")]
    public void deleteCategories(int categoryID)
    {
        parameters.Add(new SqlParameter("@CategoryID", categoryID));
        parameters.Add(new SqlParameter("@CategoryName", ""));
        parameters.Add(new SqlParameter("@Delete", 1));
        SerializeDataTable(spExec("spAddUpdateDeleteCategories"));
    }

    [WebMethod(Description = description + "Add new Customers.")]
    public void addCustomers(string emailAddress, string password, string firstName, string lastName)
    {
        parameters.Add(new SqlParameter("@CustomerID", 0));
        parameters.Add(new SqlParameter("@EmailAddress", emailAddress));
        parameters.Add(new SqlParameter("@FirstName", firstName));
        parameters.Add(new SqlParameter("@LastName", lastName));
        SerializeDataTable(spExec("spAddDeleteCustomers"));
    }

    [WebMethod(Description = description + "Delete existing Customers with CustomerID.")]
    public void deleteCustomers(int customerID)
    {
        parameters.Add(new SqlParameter("@CustomerID", customerID));
        parameters.Add(new SqlParameter("@EmailAddress", ""));
        parameters.Add(new SqlParameter("@Password", ""));
        parameters.Add(new SqlParameter("@FirstName", ""));
        parameters.Add(new SqlParameter("@LastName", ""));
        parameters.Add(new SqlParameter("@Delete", 1));
        SerializeDataTable(spExec("spAddDeleteCustomers"));
    }

    [WebMethod(Description = description + "Delete existing Customers with CustomerID.")]
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
    public void deleteBillingAddress(int customerID, int billingAddressID)
    {
        parameters.Add(new SqlParameter("@CustomerID", customerID));
        parameters.Add(new SqlParameter("@BillingAddressID", billingAddressID));
        parameters.Add(new SqlParameter("@Delete", 1));
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
    public void deleteShippingAddress(int customerID, int shippingAddressID)
    {
        parameters.Add(new SqlParameter("@CustomerID", customerID));
        parameters.Add(new SqlParameter("@BillingAddressID", shippingAddressID));
        parameters.Add(new SqlParameter("@Delete", 1));
        SerializeDataTable(spExec("spUpdateDeleteShippingAddress"));
    }

    [WebMethod(Description = description + "Add new Order Items.")]
    public void addOrderItems(int orderID, int productID, double itemPrice, double discountAmount,
                                int quantity)
    {
        parameters.Add(new SqlParameter("@ItemID", 0));
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
        parameters.Add(new SqlParameter("@ItemID", itemID));
        parameters.Add(new SqlParameter("@OrderID", ""));
        parameters.Add(new SqlParameter("@ProductID", ""));
        parameters.Add(new SqlParameter("@ItemPrice", ""));
        parameters.Add(new SqlParameter("@DiscountAmount", ""));
        parameters.Add(new SqlParameter("@Quantity", ""));
        parameters.Add(new SqlParameter("@Delete", 1));
        SerializeDataTable(spExec("spAddUpdateDeleteOrderItems"));
    }

    [WebMethod(Description = description + "Add new Orders.")]
    public void addOrders(int customerID, DateTime orderDate, double shipAmount, double taxAmount, DateTime shipDate,
                                int shipAddressID, string cardType, string cardNumber, string cardExpires,
                                int billingAddressID)
    {
        parameters.Add(new SqlParameter("@OrderID", 0));
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
        parameters.Add(new SqlParameter("@Delete", 1));
        SerializeDataTable(spExec("spAddUpdateDeleteOrders"));
    }

    [WebMethod(Description = description + "Add new Products.")]
    public void addProducts(int categoryID, string productCode, string productName, string description, double listPrice,
                                double discountPercent, DateTime dateAdded)
    {
        parameters.Add(new SqlParameter("@ProductID", 0));
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

    [WebMethod(Description = description + "Update existing Products.")]
    public void deleteProducts(int productID)
    {
        parameters.Add(new SqlParameter("@ProductID", productID));
        parameters.Add(new SqlParameter("@CategoryID", ""));
        parameters.Add(new SqlParameter("@ProductCode", ""));
        parameters.Add(new SqlParameter("@ProductName", ""));
        parameters.Add(new SqlParameter("@Description", ""));
        parameters.Add(new SqlParameter("@ListPrice", ""));
        parameters.Add(new SqlParameter("@DiscountPercent", ""));
        parameters.Add(new SqlParameter("@DateAdded", ""));
        parameters.Add(new SqlParameter("@Delete", 1));
        SerializeDataTable(spExec("spAddUpdateDeleteProducts"));
    }

    #endregion


}
