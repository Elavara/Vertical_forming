package harvesting;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/harvestcalculation") // Ensure this matches your form action
public class HarvestingCalculationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        // Employee ID to be inserted
        String employeeId = "hav_5830";

        // Database connection variables
        Connection conn = null;
        PreparedStatement pstmt = null;
        PreparedStatement checkStmt = null;

        try {
            // Load the JDBC driver
            Class.forName("com.mysql.jdbc.Driver"); // Use this driver for MySQL 8 and above
            // Establish connection to the database
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/vertical_farming", "root", "root");

            // Retrieve form data
            String[] crops = request.getParameterValues("crop");
            String[] waterUsages = request.getParameterValues("waterUsage");
            String[] totalNutrients = request.getParameterValues("totalNutrients");
            String[] harvestEfficiencies = request.getParameterValues("harvestEfficiency");
            String[] spaceUtilizations = request.getParameterValues("spaceUtilization");
            String[] yieldComparisons = request.getParameterValues("yieldComparison");
            String[] sunlightEfficiencies = request.getParameterValues("sunlightEfficiency");
            String[] totalWeights = request.getParameterValues("totalWeight");

            // Loop through the arrays and insert each row into the database
            if (crops != null) {
                for (int i = 0; i < crops.length; i++) {
                    // Check for duplicates
                    String checkSql = "SELECT COUNT(*) FROM module4_harvesting_calculation WHERE employee_id = ? AND crop = ?";
                    checkStmt = conn.prepareStatement(checkSql);
                    checkStmt.setString(1, employeeId);
                    checkStmt.setString(2, crops[i]);

                    ResultSet rs = checkStmt.executeQuery();
                    rs.next();
                    int count = rs.getInt(1);

                    if (count > 0) {
                        // Duplicate crop found
                        out.println("<script type='text/javascript'>");
                        out.println("alert('Duplicate crop entry: " + crops[i] + ". Data not inserted.');");
                        out.println("window.location.href = 'module4_harvest_processing.jsp';"); // Redirect to defined page
                        out.println("</script>");
                        return; // Exit the servlet if a duplicate is found
                    }

                    // Prepare the SQL insert statement
                    String sql = "INSERT INTO module4_harvesting_calculation (employee_id, crop, water_usage, total_nutrients, harvest_efficiency, space_utilization, yield_comparison, sunlight_efficiency, total_weight) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                    pstmt = conn.prepareStatement(sql);

                    // Set parameters for insertion
                    pstmt.setString(1, employeeId);
                    pstmt.setString(2, crops[i]);
                    pstmt.setString(3, waterUsages[i]);
                    pstmt.setString(4, totalNutrients[i]);
                    pstmt.setString(5, harvestEfficiencies[i]);
                    pstmt.setString(6, spaceUtilizations[i]);
                    pstmt.setString(7, yieldComparisons[i]);
                    pstmt.setString(8, sunlightEfficiencies[i]);
                    pstmt.setString(9, totalWeights[i]);

                    // Execute the insert
                    pstmt.executeUpdate();
                }
            }

            // Success message
            out.println("<script type='text/javascript'>");
            out.println("alert('Data inserted successfully!');");
            out.println("window.location.href = 'module4_harvest_processing.jsp';"); // Replace with your defined page
            out.println("</script>");

        } catch (Exception e) {
            e.printStackTrace();
            // Error message
            out.println("<script type='text/javascript'>");
            out.println("alert('Error occurred while inserting data.');");
            out.println("window.location.href = 'module4_harvest_processing.jsp';"); // Replace with your defined page
            out.println("</script>");
        } finally {
            // Close resources
            if (pstmt != null) try { pstmt.close(); } catch (Exception ignore) {}
            if (checkStmt != null) try { checkStmt.close(); } catch (Exception ignore) {}
            if (conn != null) try { conn.close(); } catch (Exception ignore) {}
            out.close();
        }
    }
}
