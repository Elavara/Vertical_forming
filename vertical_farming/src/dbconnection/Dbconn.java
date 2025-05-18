package dbconnection;

import java.sql.Connection;
import java.sql.DriverManager;

public class Dbconn {
	
	static Connection con;
	public static Connection getconnection() {
		try
		{
			Class.forName("com.mysql.jdbc.Driver");	
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/vertical_farming","root","root");
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return con;
	}
}
