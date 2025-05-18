package harvesting;

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

@WebServlet("/harvestupload")
public class harvestupload extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database connection parameters
    private static final String URL = "jdbc:mysql://localhost:3306/vertical_farming"; // Replace with your database URL
    private static final String USER = "root"; // Replace with your database username
    private static final String PASSWORD = "root"; // Replace with your database password

    // Path to the CSV file
    private static final String CSV_FILE_PATH = "D:/vertical_farming/vertical_farming/WebContent/datasheet/module4_harvesting_upload.csv"; // Adjusted to match table name

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // Set a fixed employee ID for all rows
        String employeeId = "hv_7865"; // Fixed employee ID

        // SQL query to check if data is already present
        String checkDataQuery = "SELECT COUNT(*) FROM module4_harvserting_upload"; // Updated to count all records

        // SQL query to load data from CSV
        String loadDataQuery = "LOAD DATA LOCAL INFILE '" + CSV_FILE_PATH + "' INTO TABLE module4_harvserting_upload "
                + "FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' "
                + "IGNORE 1 LINES "
                + "(ID, Crop, Type, Harvest_Method, Soil_Type, Climate, Days_to_Harvest, "
                + "Height_cm, Weight_kg, Watering_L_per_week, N_kg_per_ha, P_kg_per_ha, "
                + "K_kg_per_ha, Ca_kg_per_ha, Mg_kg_per_ha, Fe_kg_per_ha, "
                + "pH, EC_dS_m, Yield_kg_per_ha, Spacing_cm, Notes) "
                + "SET employee_id = ?"; // Include employee ID for each inserted row

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
                        out.println("window.location.href = 'module4_harvestinghomepage.html';"); // Redirect to homepage
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
                            out.println("window.location.href = 'module4_harvestinghomepage.html';"); // Redirect to homepage
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
                out.println("window.location.href = 'module4_harvestinghomepage.html';"); // Redirect to error page
                out.println("</script>");
                out.println("</body></html>");
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            out.println("<html><body>");
            out.println("<script>");
            out.println("alert('JDBC Driver not found: " + e.getMessage() + "');");
            out.println("window.location.href = 'module4_harvestinghomepage.html';"); // Redirect to error page
            out.println("</script>");
            out.println("</body></html>");
        }
    }
}
