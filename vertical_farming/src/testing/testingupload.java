package testing;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.DriverManager;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mysql.jdbc.Connection;
import com.mysql.jdbc.PreparedStatement;
import com.mysql.jdbc.ResultSet;

@WebServlet("/testingupload")
public class testingupload extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database connection parameters
    private static final String URL = "jdbc:mysql://localhost:3306/vertical_farming"; // Replace with your database URL
    private static final String USER = "root"; // Replace with your database username
    private static final String PASSWORD = "root"; // Replace with your database password

    // Path to the CSV file
    private static final String CSV_FILE_PATH = "D:/vertical_farming/vertical_farming/WebContent/datasheet/module5_testing_upload.csv"; // Adjusted to match new table name

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // Set a fixed employee ID for all rows
        String employeeId = "hv_7865"; // Fixed employee ID

        // SQL query to check if data is already present
        String checkDataQuery = "SELECT COUNT(*) FROM module5_testing_upload"; // Updated to count all records

        // SQL query to load data from CSV
        String loadDataQuery = "LOAD DATA LOCAL INFILE '" + CSV_FILE_PATH + "' INTO TABLE module5_testing_upload "
                + "FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' "
                + "IGNORE 1 LINES "
                + "(SampleID, ProductType, Variety, Weight, Color, Size, Firmness, "
                + "SugarContent, MoistureContent, pHLevel, AppearanceDefects, "
                + "PesticideResidue, StorageTemperature, TesterName, Notes, "
                + "WaterUsage, TotalNutrient, HarvestEfficiency, SpaceUtilization, "
                + "YieldComparison, SunlightEfficiency, IronLevel, ProteinLevel, "
                + "VitaminCLevel) "
                + "SET employee_id = ?"; // Include employee ID for each inserted row

        try {
            // Load MySQL JDBC driver
            Class.forName("com.mysql.jdbc.Driver"); // Updated to use the newer driver class

            // Establish connection to the database
            try (java.sql.Connection connection = DriverManager.getConnection(URL, USER, PASSWORD);
                 java.sql.PreparedStatement checkStatement = connection.prepareStatement(checkDataQuery)) {

                // Execute the check query
                try (java.sql.ResultSet resultSet = checkStatement.executeQuery()) {
                    if (resultSet.next() && resultSet.getInt(1) > 0) {
                        // Data already exists
                        out.println("<html><body>");
                        out.println("<script>");
                        out.println("alert('Data has already been inserted.');");
                        out.println("window.location.href = 'module5_testing_homepage.html';"); // Redirect to homepage
                        out.println("</script>");
                        out.println("</body></html>");
                    } else {
                        // Data does not exist, proceed with loading
                        try (java.sql.PreparedStatement loadStatement = connection.prepareStatement(loadDataQuery)) {
                            loadStatement.setString(1, employeeId); // Set the fixed employee ID
                            loadStatement.execute();
                            out.println("<html><body>");
                            out.println("<script>");
                            out.println("alert('Data loaded successfully!');");
                            out.println("window.location.href = 'module5_testing_homepage.html';"); // Redirect to homepage
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
                out.println("window.location.href = 'module5_testing_homepage.html';"); // Redirect to error page
                out.println("</script>");
                out.println("</body></html>");
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            out.println("<html><body>");
            out.println("<script>");
            out.println("alert('JDBC Driver not found: " + e.getMessage() + "');");
            out.println("window.location.href = 'module5_testing_homepage.html';"); // Redirect to error page
            out.println("</script>");
            out.println("</body></html>");
        }
    }
}
