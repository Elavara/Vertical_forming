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

@WebServlet("/SubmitResults")
public class SubmitResultsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Database connection details
        String jdbcUrl = "jdbc:mysql://localhost:3306/vertical_farming"; // Update with your database name
        String dbUser = "root"; // Update with your database username
        String dbPassword = "root"; // Update with your database password

        // Getting form data
        String fruitVegetable = request.getParameter("fruitVegetable");
        String remainingTonsNeeded = request.getParameter("remainingTonsNeeded");
        String estimatedTimeDays = request.getParameter("estimatedTimeDays");
        String totalQuantityAvailable = request.getParameter("totalQuantityAvailable");
        String projectedGrowthNextMonth = request.getParameter("projectedGrowthNextMonth");
        String inventoryTurnoverRate = request.getParameter("inventoryTurnoverRate");
        String daysUntilFullStock = request.getParameter("daysUntilFullStock");
        String supplyDeficit = request.getParameter("supplyDeficit");
        String growthPotential = request.getParameter("growthPotential");
        String currentStockStatus = request.getParameter("currentStockStatus");

        String employeeId = "pro_5436"; // Static employee ID

        Connection conn = null;
        PreparedStatement checkStmt = null;
        PreparedStatement insertStmt = null;
        ResultSet rs = null;
        PrintWriter out = response.getWriter();

        try {
            // Establishing a database connection
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);

            // Check if the fruit/vegetable already exists
            String checkQuery = "SELECT COUNT(*) FROM module2_calculated_result WHERE fruits_vegetables = ?";
            checkStmt = conn.prepareStatement(checkQuery);
            checkStmt.setString(1, fruitVegetable);
            rs = checkStmt.executeQuery();
            rs.next();
            int count = rs.getInt(1);

            if (count > 0) {
                // If entry exists, show alert and redirect
                out.println("<script type='text/javascript'>");
                out.println("alert('Data already inserted!');");
                out.println("window.location.href = 'modul2_processing_data.jsp';");
                out.println("</script>");
            } else {
                // Insert data if not duplicate
                String insertQuery = "INSERT INTO module2_calculated_result "
                        + "(employee_id, fruits_vegetables, remaining_tons_needed, estimated_time_days, total_quantity_available, "
                        + "projected_growth_next_month, inventory_turnover_rate, days_until_full_stock, "
                        + "supply_deficit, growth_potential, current_stock_status) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

                insertStmt = conn.prepareStatement(insertQuery);
                insertStmt.setString(1, employeeId);
                insertStmt.setString(2, fruitVegetable);
                insertStmt.setString(3, remainingTonsNeeded);
                insertStmt.setString(4, estimatedTimeDays);
                insertStmt.setString(5, totalQuantityAvailable);
                insertStmt.setString(6, projectedGrowthNextMonth);
                insertStmt.setString(7, inventoryTurnoverRate);
                insertStmt.setString(8, daysUntilFullStock);
                insertStmt.setString(9, supplyDeficit);
                insertStmt.setString(10, growthPotential);
                insertStmt.setString(11, currentStockStatus);

                insertStmt.executeUpdate();

                // Send success message
                out.println("<script type='text/javascript'>");
                out.println("alert('Data submitted successfully!');");
                out.println("window.location.href = 'modul2_processing_data.jsp';");
                out.println("</script>");
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            out.println("<script type='text/javascript'>");
            out.println("alert('Error occurred: " + e.getMessage() + "');");
            out.println("window.location.href = 'modul2_processing_data.jsp';");
            out.println("</script>");
        } finally {
            // Closing resources
            try {
                if (rs != null) rs.close();
                if (checkStmt != null) checkStmt.close();
                if (insertStmt != null) insertStmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
