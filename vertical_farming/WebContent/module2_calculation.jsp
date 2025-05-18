<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Calculation Result</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-image: url('vew.jpg'); /* Update with your image URL */
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            color: #333;
            position: relative; /* Added for positioning child elements */
            min-height: 100vh; /* Ensure body takes full height */
        }

        .container {
            width: 90%;
            max-width: 800px;
            margin: 50px auto;
            background-color: rgba(255, 255, 255, 0.9); /* Semi-transparent background */
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            position: relative; /* Added for positioning */
            padding-bottom: 80px; /* Added padding to prevent overlap with fixed buttons */
        }

        h1 {
            text-align: center;
            color: #007BFF;
        }

        .calculation {
            margin-top: 20px;
            padding: 10px;
            border: 1px solid #ffc107;
            background-color: rgba(255, 193, 7, 0.1);
            border-radius: 5px;
            overflow: auto; /* Ensure content can scroll */
            max-height: 400px; /* Set max height for scrolling */
        }

        .results-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .results-table th, .results-table td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: center;
            word-wrap: break-word; /* Ensure text wraps properly */
        }

        .results-table th {
            background-color: #007BFF;
            color: white;
        }

        button {
            background-color: #007BFF;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
            display: block;
        }

        button:hover {
            background-color: #0056b3;
        }

        .back-button {
            position: fixed; /* Fixed positioning to stick to the viewport */
            bottom: 20px; /* Distance from the bottom */
            right: 20px; /* Distance from the right */
        }

        .submit-button {
            position: fixed; /* Fixed positioning to stick to the viewport */
            bottom: 20px; /* Distance from the bottom */
            left: 50%; /* Center it horizontally */
            transform: translateX(-50%); /* Adjust for center alignment */
        }
    </style>
</head>
<body>

<div class="container">
    <h1>Calculation Result</h1>

    <%
        // Database connection details
        String jdbcUrl = "jdbc:mysql://localhost:3306/vertical_farming"; // Update with your database name
        String dbUser = "root"; // Update with your database username
        String dbPassword = "root"; // Update with your database password

        String fruitVegetable = request.getParameter("fruitVegetable");
        int noOfTonsNeeded = Integer.parseInt(request.getParameter("noOfTonsNeeded"));
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // Establishing a database connection
            Class.forName("com.mysql.jdbc.Driver"); // Ensure the MySQL JDBC driver is in your classpath
            conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
            String sql = "SELECT * FROM module2_product_availability_upload WHERE Fruit_Vegetable = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, fruitVegetable);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                int totalQuantity = Integer.parseInt(rs.getString("Total_Quantity"));
                int quantityAvailable = Integer.parseInt(rs.getString("Quantity_Available"));
                int estimatedDaysToMaturity = Integer.parseInt(rs.getString("Estimated_Days_to_Maturity"));
                String growingStatus = rs.getString("Growing_Status");

                // Calculating remaining tons needed and estimated time
                int remainingTonsNeeded = noOfTonsNeeded - quantityAvailable;
                int estimatedTimePerTon = estimatedDaysToMaturity;
                int totalEstimatedTime = remainingTonsNeeded > 0 ? (remainingTonsNeeded * estimatedTimePerTon) : 0;

                // Additional Calculations
                int totalAvailableQuantity = quantityAvailable + (remainingTonsNeeded > 0 ? 0 : remainingTonsNeeded);
                int totalTimeToGrow = (totalQuantity - quantityAvailable) * estimatedDaysToMaturity;
                double growthRate = (double) quantityAvailable / totalQuantity * 100;
                double projectedGrowthNextMonth = totalQuantity * 0.1; // Assuming 10% growth rate next month
                int inventoryTurnoverRate = totalQuantity / noOfTonsNeeded; 
                int daysUntilFullStock = estimatedDaysToMaturity * remainingTonsNeeded;
                double supplyDeficit = remainingTonsNeeded > 0 ? remainingTonsNeeded : 0;

                // Show the calculation result
    %>
                <div class="calculation">
                    <h2>Calculation Results:</h2>
                    <form action="SubmitResults" method="post"> <!-- Change "YourServletURL" to your actual servlet URL -->
                        <table class="results-table">
                            <thead>
                                <tr><th>fruitVegetable</th>
                                    <th>Remaining Tons Needed</th>
                                    <th>Estimated Time (Days)</th>
                                    <th>Total Quantity Available</th>
                                    <th>Projected Growth Next Month</th>
                                    <th>Inventory Turnover Rate</th>
                                    <th>Days Until Full Stock</th>
                                    <th>Supply Deficit</th>
                                    <th>Growth Potential</th>
                                    <th>Current Stock Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                
                                        
                                    <td><input type="text" name="fruitVegetable" value="<%=fruitVegetable%>" readonly></td>
                                         
                                    <td><input type="text" name="remainingTonsNeeded" value="<%= remainingTonsNeeded < 0 ? 0 : remainingTonsNeeded %>" readonly></td>
                                    <td><input type="text" name="estimatedTimeDays" value="<%= estimatedTimePerTon %>" readonly></td>
                                    <td><input type="text" name="totalQuantityAvailable" value="<%= totalAvailableQuantity %>" readonly></td>
                                    <td><input type="text" name="projectedGrowthNextMonth" value="<%= projectedGrowthNextMonth %>" readonly></td>
                                    <td><input type="text" name="inventoryTurnoverRate" value="<%= inventoryTurnoverRate %>" readonly></td>
                                    <td><input type="text" name="daysUntilFullStock" value="<%= daysUntilFullStock %>" readonly></td>
                                    <td><input type="text" name="supplyDeficit" value="<%= supplyDeficit %>" readonly></td>
                                    <td><input type="text" name="growthPotential" value="<%= String.format("%.2f", growthRate) %>" readonly></td>
                                    <td><input type="text" name="currentStockStatus" value="<%= growingStatus.equalsIgnoreCase("Growing") ? "Not Available" : "Available" %>" readonly></td>
                                </tr>
                            </tbody>
                        </table>
                        <button type="submit" class="submit-button">Submit</button> <!-- Submit button -->
                    </form>
                </div>
    <%
            } else {
    %>
                <div class="calculation">
                    <h2>No Availability Information Found for <%= fruitVegetable %>.</h2>
                </div>
    <%
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Closing the resources
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>

    <button class="back-button" onclick="window.location.href='modul2_processing_data.jsp';">Back</button> <!-- Back button -->
</div>

</body>
</html>
