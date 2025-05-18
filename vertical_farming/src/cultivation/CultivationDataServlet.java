package cultivation;

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

@WebServlet("/CultivationDataServlet")
public class CultivationDataServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // JDBC connection details
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/vertical_farming"; // Update database URL
    private static final String JDBC_USER = "root";  // Update database username
    private static final String JDBC_PASSWORD = "root";  // Update database password

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Set the content type to HTML
        response.setContentType("text/html");

        // Get values from the form
        String fruitsVegetables = request.getParameter("fruits_vegetables");
        String growthImpact = request.getParameter("growthImpact");
        String nutrientGrowthFactor = request.getParameter("nutrientGrowthFactor");
        String spaceEfficiencyImpact = request.getParameter("spaceEfficiencyImpact");
        String estimatedDaysToCultivate = request.getParameter("estimatedDaysToCultivate");
        String yieldEfficiency = request.getParameter("yieldEfficiency");
        String projectedHarvestInXDays = request.getParameter("projectedHarvestInXDays");
        String cultivationEfficiencyRatio = request.getParameter("cultivationEfficiencyRatio");

        // Fixed employee ID
        String employeeId = "el_7683";

        // Database connection and insert logic
        Connection conn = null;
        PreparedStatement pstmt = null;
        PreparedStatement checkPstmt = null;
        ResultSet rs = null;
        
        try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.jdbc.Driver");
            // Establish database connection
            conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);

            // Check for duplicates
            String checkSql = "SELECT COUNT(*) FROM module3_cultivation_calculation_data WHERE fruits_vegetables = ?";
            checkPstmt = conn.prepareStatement(checkSql);
            checkPstmt.setString(1, fruitsVegetables);
            rs = checkPstmt.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                // If a duplicate exists, show alert and redirect
                response.getWriter().println("<script type='text/javascript'>");
                response.getWriter().println("alert('Duplicate entry for Fruits/Vegetables. Please enter a unique value.');");
                response.getWriter().println("window.location.href = 'module3_culativation_process.jsp';");
                response.getWriter().println("</script>");
                return; // Exit after showing alert
            }

            // Prepare SQL insert statement
            String sql = "INSERT INTO module3_cultivation_calculation_data(employee_id, fruits_vegetables, growth_impact_sunlight, nutrient_growth_factor, space_efficiency_impact, estimated_days_to_cultivate, yield_efficiency, projected_harvest, cultivation_efficiency_ratio) "
                       + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            
            // Set the parameters for the query
            pstmt.setString(1, employeeId);
            pstmt.setString(2, fruitsVegetables);
            pstmt.setString(3, growthImpact);
            pstmt.setString(4, nutrientGrowthFactor);
            pstmt.setString(5, spaceEfficiencyImpact);
            pstmt.setString(6, estimatedDaysToCultivate);
            pstmt.setString(7, yieldEfficiency);
            pstmt.setString(8, projectedHarvestInXDays);
            // Assuming projected_harvest is the ninth parameter
            pstmt.setString(9, cultivationEfficiencyRatio);

            // Execute the insert
            int rowsInserted = pstmt.executeUpdate();
            if (rowsInserted > 0) {
                // Show success alert and redirect
                response.getWriter().println("<script type='text/javascript'>");
                response.getWriter().println("alert('Data inserted successfully!');");
                response.getWriter().println("window.location.href = 'module3_culativation_process.jsp';");
                response.getWriter().println("</script>");
            } else {
                // Show failure alert and redirect
                response.getWriter().println("<script type='text/javascript'>");
                response.getWriter().println("alert('Failed to insert data.');");
                response.getWriter().println("window.location.href = 'module3_culativation_process.jsp';");
                response.getWriter().println("</script>");
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            response.getWriter().println("<script type='text/javascript'>");
            response.getWriter().println("alert('MySQL driver not found.');");
            response.getWriter().println("window.location.href = 'module3_culativation_process.jsp';");
            response.getWriter().println("</script>");
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("<script type='text/javascript'>");
            response.getWriter().println("alert('Database error: " + e.getMessage() + "');");
            response.getWriter().println("window.location.href = 'module3_culativation_process.jsp';");
            response.getWriter().println("</script>");
        } finally {
            // Close the connection and statement
            try {
                if (rs != null) rs.close();
                if (checkPstmt != null) checkPstmt.close(); // Close the check statement
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }


 
}
