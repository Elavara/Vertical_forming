<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vegetable Request Table</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-image: url('clv.jpg'); /* Set your background image here */
            background-size: cover; /* Cover the entire background */
            background-repeat: no-repeat; /* Prevent tiling */
            background-position: center; /* Center the image */
            color: white; /* Change text color to white for better visibility */
        }

        .container {
            width: 90%;
            max-width: 1200px;
            margin: 50px auto;
            background-color: rgba(255, 255, 255, 0.8);
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0px 6px 18px rgba(0, 0, 0, 0.1);
            overflow-x: auto; 
        }

        h1 {
            text-align: center;
            color: black;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
            font-size: 1em;
            background-color: rgba(255, 255, 255, 0.7);
        }

        th, td {
            padding: 14px 18px;
            text-align: left;
            word-wrap: break-word;
        }

        th {
            background: linear-gradient(135deg, rgba(111, 159, 255, 0.8), rgba(76, 175, 80, 0.8));
            color: white;
            cursor: pointer;
            text-transform: uppercase;
        }

        th:hover {
            background-color: rgba(62, 142, 65, 0.8);
        }

        td {
            color: #333;
        }

        tr:nth-child(even) {
            background-color: rgba(242, 242, 242, 0.5);
        }

        tr:hover {
            background-color: rgba(224, 247, 250, 0.6);
        }

        /* Back button styling */
        .back-button {
            position: fixed; /* Fixed position */
            bottom: 20px; /* Distance from the bottom */
            right: 20px; /* Distance from the right */
            padding: 10px 15px; /* Padding for button */
            font-size: 16px; /* Font size */
            color: white; /* Text color */
            background-color: rgba(76, 175, 80, 0.8); /* Button background color */
            border: none; /* Remove border */
            border-radius: 5px; /* Rounded corners */
            cursor: pointer; /* Pointer cursor */
            transition: background-color 0.3s; /* Transition effect */
        }

        .back-button:hover {
            background-color: rgba(62, 142, 65, 0.8); /* Hover effect */
        }

        @media (max-width: 768px) {
            table, thead, tbody, th, td, tr {
                display: block;
            }

            th {
                display: none;
            }

            tr {
                margin-bottom: 20px;
                box-shadow: 0px 2px 6px rgba(0, 0, 0, 0.1);
                border-radius: 10px;
            }

            td {
                position: relative;
                padding-left: 50%;
                text-align: right;
                background-color: rgba(255, 255, 255, 0.8);
                border-bottom: 1px solid #ddd;
            }

            td:before {
                content: attr(data-label);
                position: absolute;
                left: 0;
                width: 45%;
                padding-left: 15px;
                text-align: left;
                font-weight: bold;
                text-transform: uppercase;
            }

            tr:hover {
                background-color: rgba(255, 255, 255, 0.8); 
            }
        }

        @media (max-width: 480px) {
            td {
                font-size: 0.9em;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <h1 style="color: black; text-transform: uppercase;">processing</h1>
    <table id="myTable">
        <thead>
            <tr>
                <th onclick="sortTable(0)">ID</th>
                <th onclick="sortTable(1)">Employee ID</th>
                <th onclick="sortTable(2)">Fruits/Vegetables</th>
                <th onclick="sortTable(3)">Remaining Tons Needed</th>
                <th onclick="sortTable(4)">Estimated Time (Days)</th>
                <th onclick="sortTable(5)">Total Quantity Available</th>
                <th onclick="sortTable(6)">Projected Growth Next Month</th>
                <th onclick="sortTable(7)">Inventory Turnover Rate</th>
                <th onclick="sortTable(8)">Days Until Full Stock</th>
                <th onclick="sortTable(9)">Supply Deficit</th>
                <th onclick="sortTable(10)">Growth Potential</th>
                <th onclick="sortTable(11)">Current Stock Status</th>
                <th>Calculate</th>
            </tr>
        </thead>
        <tbody>
            <%
                // Database connection and query logic as before
                String jdbcUrl = "jdbc:mysql://localhost:3306/vertical_farming"; // Update with your database name
                String dbUser = "root"; // Update with your database username
                String dbPassword = "root"; // Update with your database password

                Connection conn = null;
                Statement stmt = null;
                ResultSet rs = null;

                try {
                    // Establishing a database connection
                    Class.forName("com.mysql.jdbc.Driver"); // Use the correct driver class
                    conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
                    stmt = conn.createStatement();
                    String sql = "SELECT * FROM module2_calculated_result"; // Change the table name
                    rs = stmt.executeQuery(sql);

                    // Loop through the result set and display the data in the table
                    while (rs.next()) {
                        String currentStockStatus = rs.getString("current_stock_status"); // Get current stock status
                        boolean isAvailable = "Available".equalsIgnoreCase(currentStockStatus); // Check if status is "Available"
                        %>
                        <tr>
                            <td data-label="ID"><%= rs.getString("id") %></td>
                            <td data-label="Employee ID"><%= rs.getString("employee_id") %></td>
                            <td data-label="Fruits/Vegetables"><%= rs.getString("fruits_vegetables") %></td>
                            <td data-label="Remaining Tons Needed"><%= rs.getString("remaining_tons_needed") %></td>
                            <td data-label="Estimated Time (Days)"><%= rs.getString("estimated_time_days") %></td>
                            <td data-label="Total Quantity Available"><%= rs.getString("total_quantity_available") %></td>
                            <td data-label="Projected Growth Next Month"><%= rs.getString("projected_growth_next_month") %></td>
                            <td data-label="Inventory Turnover Rate"><%= rs.getString("inventory_turnover_rate") %></td>
                            <td data-label="Days Until Full Stock"><%= rs.getString("days_until_full_stock") %></td>
                            <td data-label="Supply Deficit"><%= rs.getString("supply_deficit") %></td>
                            <td data-label="Growth Potential"><%= rs.getString("growth_potential") %></td>
                            <td data-label="Current Stock Status"><%= currentStockStatus %></td>
                            <!-- New column with calculate button -->
                            <td>
                                <form action="module3_cultivation_calculation.jsp" method="post">
                                    <input type="hidden" name="id" value="<%= rs.getString("id") %>">
                                    <input type="hidden" name="employee_id" value="<%= rs.getString("employee_id") %>">
                                    <input type="hidden" name="fruits_vegetables" value="<%= rs.getString("fruits_vegetables") %>">
                                    <input type="hidden" name="remaining_tons_needed" value="<%= rs.getString("remaining_tons_needed") %>">
                                    <input type="hidden" name="estimated_time_days" value="<%= rs.getString("estimated_time_days") %>">
                                    <input type="hidden" name="total_quantity_available" value="<%= rs.getString("total_quantity_available") %>">
                                    <input type="hidden" name="projected_growth_next_month" value="<%= rs.getString("projected_growth_next_month") %>">
                                    <input type="hidden" name="inventory_turnover_rate" value="<%= rs.getString("inventory_turnover_rate") %>">
                                    <input type="hidden" name="days_until_full_stock" value="<%= rs.getString("days_until_full_stock") %>">
                                    <input type="hidden" name="supply_deficit" value="<%= rs.getString("supply_deficit") %>">
                                    <input type="hidden" name="growth_potential" value="<%= rs.getString("growth_potential") %>">
                                    <input type="hidden" name="current_stock_status" value="<%= rs.getString("current_stock_status") %>">
                                    <button type="submit" <%= isAvailable ? "disabled" : "" %>>Calculate</button> <!-- Disable if Available -->
                                </form>
                            </td>
                        </tr>
                        <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    // Closing resources
                    try {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            %>
        </tbody>
    </table>
    
    <!-- Back button -->
    <button class="back-button" onclick="window.location.href='module3_cultivation_homepage.html'">Back</button>
</div>

<script>
    function sortTable(n) {
        // Sorting function implementation goes here
    }
</script>
</body>
</html>
