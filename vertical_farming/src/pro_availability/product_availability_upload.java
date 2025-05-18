package pro_availability;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/proavaiupload")
public class product_availability_upload extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database connection parameters
    private static final String URL = "jdbc:mysql://localhost:3306/vertical_farming"; // Replace with your database URL
    private static final String USER = "root"; // Replace with your database username
    private static final String PASSWORD = "root"; // Replace with your database password

    // Path to the CSV file
    private static final String CSV_FILE_PATH = "D:/vertical_farming/vertical_farming/WebContent/datasheet/product.csv"; // Replace with your CSV file path

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // Set a fixed employee ID for all rows
        String employeeId = "emp_12345"; // Fixed employee ID

        // SQL query to check if data is already present
        String checkDataQuery = "SELECT COUNT(*) FROM module2_product_availability_upload"; // Changed to count all records

        // SQL query to load data from CSV
        String loadDataQuery = "LOAD DATA LOCAL INFILE '" + CSV_FILE_PATH + "' INTO TABLE module2_product_availability_upload "
                + "FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' "
                + "IGNORE 1 LINES "
                + "(S_No, Fruit_Vegetable, Total_Quantity, Quantity_Available, Growing_Status, "
                + "Number_of_Growing, Number_of_Fully_Grown, Growing_Quantity, Fully_Grown_Quantity, "
                + "Notes, Estimated_Days_to_Maturity) "
                + "SET Employee_ID = ?"; // Include employee ID for each inserted row

        try {
            // Load MySQL JDBC driver
            Class.forName("com.mysql.jdbc.Driver"); // Updated to use the newer driver class

            // Establish connection to the database
            try (Connection connection = DriverManager.getConnection(URL, USER, PASSWORD);
                 PreparedStatement checkStatement = connection.prepareStatement(checkDataQuery)) {

                // Execute the check query
                try (ResultSet resultSet = checkStatement.executeQuery()) {
                    if (resultSet.next() && resultSet.getInt(1) > 0) {
                        // Data already exists
                        out.println("<html><body>");
                        out.println("<script>");
                        out.println("alert('Data has already been inserted.');");
                        out.println("window.location.href = 'module2_product_availability.html';"); // Redirect to homepage
                        out.println("</script>");
                        out.println("</body></html>");
                    } else {
                        // Data does not exist, proceed with loading
                        try (PreparedStatement loadStatement = connection.prepareStatement(loadDataQuery)) {
                            loadStatement.setString(1, employeeId); // Set the fixed employee ID
                            loadStatement.execute();
                            out.println("<html><body>");
                            out.println("<script>");
                            out.println("alert('Data loaded successfully!');");
                            out.println("window.location.href = 'module2_product_availability.html';"); // Redirect to homepage
                            out.println("</script>");
                            out.println("</body></html>");
                        }
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<html><body>");
                out.println("<script>");
                out.println("alert('Failed to load data: " + e.getMessage() + "');");
                out.println("window.location.href = 'module2_product_availability.html';"); // Redirect to error page
                out.println("</script>");
                out.println("</body></html>");
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            out.println("<html><body>");
            out.println("<script>");
            out.println("alert('JDBC Driver not found: " + e.getMessage() + "');");
            out.println("window.location.href = 'module2_product_availability.html';"); // Redirect to error page
            out.println("</script>");
            out.println("</body></html>");
        }
    }
}
