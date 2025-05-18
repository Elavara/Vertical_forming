package testing;

import java.io.IOException;
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

@WebServlet("/test_calculated")
public class test_calculated extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database connection parameters
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/vertical_farming";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    @SuppressWarnings("resource")
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve the data from the form submission
        String variety = request.getParameter("varieties"); // Updated from productTypes to varieties
        String avgWaterUsage = request.getParameter("avgWaterUsage");
        String totalWeight = request.getParameter("totalWeight");
        String totalRecords = request.getParameter("totalRecords");
        String avgNutrients = request.getParameter("avgNutrients");
        String avgHarvestEfficiency = request.getParameter("avgHarvestEfficiency");
        String avgSpaceUtilization = request.getParameter("avgSpaceUtilization");
        String avgYieldComparison = request.getParameter("avgYieldComparison");
        String avgSunlightEfficiency = request.getParameter("avgSunlightEfficiency");

        // Retrieve the new data for average levels
        String avgIronLevel = request.getParameter("avgIronLevel");
        String avgProteinLevel = request.getParameter("avgProteinLevel");
        String avgVitaminCLevel = request.getParameter("avgVitaminCLevel");

        // Static employee ID for each row
        String employeeId = "test_8735";

        // Database connection and statements
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSWORD);

            // Check if the variety already exists
            String checkSql = "SELECT COUNT(*) FROM module5_calculated_results WHERE product_type = ?";
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setString(1, variety); // Updated to use variety
            rs = pstmt.executeQuery();

            int count = 0;
            if (rs.next()) {
                count = rs.getInt(1);
            }

            if (count > 0) {
                // Variety already exists, show alert and redirect
                response.setContentType("text/html");
                response.getWriter().println("<script type=\"text/javascript\">");
                response.getWriter().println("alert('Variety already exists.');"); // Updated alert message
                response.getWriter().println("window.location.href = 'module5_processing.jsp';");
                response.getWriter().println("</script>");
            } else {
                // Insert the new data
                String sql = "INSERT INTO module5_calculated_results (employee_id, product_type, avg_water_usage, total_weight, " +
                             "total_records, avg_nutrient_level, avg_harvest_efficiency, avg_space_utilization, " +
                             "avg_yield_comparison, avg_sunlight_efficiency, avg_iron_level, avg_protein_level, avg_vitamin_c_level) " +
                             "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

                pstmt = conn.prepareStatement(sql);

                // Set parameters
                pstmt.setString(1, employeeId);
                pstmt.setString(2, variety); // Updated to use variety
                pstmt.setString(3, avgWaterUsage);
                pstmt.setString(4, totalWeight);
                pstmt.setString(5, totalRecords);
                pstmt.setString(6, avgNutrients);
                pstmt.setString(7, avgHarvestEfficiency);
                pstmt.setString(8, avgSpaceUtilization);
                pstmt.setString(9, avgYieldComparison);
                pstmt.setString(10, avgSunlightEfficiency);
                pstmt.setString(11, avgIronLevel);  // Set average iron level
                pstmt.setString(12, avgProteinLevel); // Set average protein level
                pstmt.setString(13, avgVitaminCLevel); // Set average vitamin C level

                // Execute the insert
                int rowsInserted = pstmt.executeUpdate();
                if (rowsInserted > 0) {
                    // Show success popup and redirect
                    response.setContentType("text/html");
                    response.getWriter().println("<script type=\"text/javascript\">");
                    response.getWriter().println("alert('Data inserted successfully.');");
                    response.getWriter().println("window.location.href = 'module5_processing.jsp';");
                    response.getWriter().println("</script>");
                } else {
                    // Show failure popup and redirect
                    response.setContentType("text/html");
                    response.getWriter().println("<script type=\"text/javascript\">");
                    response.getWriter().println("alert('Failed to insert data.');");
                    response.getWriter().println("window.location.href = 'module5_processing.jsp';");
                    response.getWriter().println("</script>");
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            // Show error popup and redirect
            response.setContentType("text/html");
            response.getWriter().println("<script type=\"text/javascript\">");
            response.getWriter().println("alert('An error occurred: " + e.getMessage().replace("'", "\\'") + "');");
            response.getWriter().println("window.location.href = 'module5_processing.jsp';");
            response.getWriter().println("</script>");
        } finally {
            // Clean up database resources
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}
