<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Calculated Results Data</title>
    <style>
      body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-image: url('clv.jpg');
            background-size: cover;
            background-repeat: no-repeat;
            background-position: center;
            color: white;
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

        .back-button {
            position: fixed;
            bottom: 20px;
            right: 20px;
            padding: 10px 15px;
            font-size: 16px;
            color: white;
            background-color: rgba(76, 175, 80, 0.8);
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .back-button:hover {
            background-color: rgba(62, 142, 65, 0.8);
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
    <h1 style="color: black; text-transform: uppercase;">Calculated Results Data</h1>
    <table id="myTable">
        <thead>
            <tr>
                <th onclick="sortTable(0)">S.No</th>
                <th onclick="sortTable(1)">Employee ID</th>
                <th onclick="sortTable(2)">Fruits/Veggies</th>
                <th onclick="sortTable(3)">Remaining Tons Needed</th>
                <th onclick="sortTable(4)">Estimated Time (Days)</th>
                <th onclick="sortTable(5)">Total Quantity Available</th>
                <th onclick="sortTable(6)">Projected Growth Next Month</th>
                <th onclick="sortTable(7)">Inventory Turnover Rate</th>
                <th onclick="sortTable(8)">Days Until Full Stock</th>
                <th onclick="sortTable(9)">Supply Deficit</th>
                <th onclick="sortTable(10)">Growth Potential</th>
                <th onclick="sortTable(11)">Current Stock Status</th>
            </tr>
        </thead>
        <tbody>
            <%
                String jdbcUrl = "jdbc:mysql://localhost:3306/vertical_farming"; 
                String dbUser = "root"; 
                String dbPassword = "root"; 

                Connection conn = null;
                Statement stmt = null;
                ResultSet rs = null;
                try {
                    Class.forName("com.mysql.jdbc.Driver"); 
                    conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
                    stmt = conn.createStatement();
                    String sql = "SELECT * FROM module2_calculated_result"; // Updated to fetch from the new table
                    rs = stmt.executeQuery(sql);

                    int index = 1; // To keep track of serial numbers
                    while (rs.next()) {
                        %>
                        <tr>
                            <td data-label="S.No"><%= index++ %></td> <!-- Incremental Serial No -->
                            <td data-label="Employee ID"><%= rs.getString("employee_id") %></td>
                            <td data-label="Fruits/Veggies"><%= rs.getString("fruits_vegetables") != null ? rs.getString("fruits_vegetables") : "N/A" %></td>
                            <td data-label="Remaining Tons Needed"><%= rs.getString("remaining_tons_needed") != null ? rs.getString("remaining_tons_needed") : "N/A" %></td>
                            <td data-label="Estimated Time (Days)"><%= rs.getString("estimated_time_days") != null ? rs.getString("estimated_time_days") : "N/A" %></td>
                            <td data-label="Total Quantity Available"><%= rs.getString("total_quantity_available") != null ? rs.getString("total_quantity_available") : "N/A" %></td>
                            <td data-label="Projected Growth Next Month"><%= rs.getString("projected_growth_next_month") != null ? rs.getString("projected_growth_next_month") : "N/A" %></td>
                            <td data-label="Inventory Turnover Rate"><%= rs.getString("inventory_turnover_rate") != null ? rs.getString("inventory_turnover_rate") : "N/A" %></td>
                            <td data-label="Days Until Full Stock"><%= rs.getString("days_until_full_stock") != null ? rs.getString("days_until_full_stock") : "N/A" %></td>
                            <td data-label="Supply Deficit"><%= rs.getString("supply_deficit") != null ? rs.getString("supply_deficit") : "N/A" %></td>
                            <td data-label="Growth Potential"><%= rs.getString("growth_potential") != null ? rs.getString("growth_potential") : "N/A" %></td>
                            <td data-label="Current Stock Status"><%= rs.getString("current_stock_status") != null ? rs.getString("current_stock_status") : "N/A" %></td>
                        </tr>
                        <%
                    }
                } catch (SQLException e) {
                    out.println("<tr><td colspan='12'>Error fetching data: " + e.getMessage() + "</td></tr>");
                } finally {
                    // Close resources
                    try {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        out.println("<tr><td colspan='12'>Error closing resources: " + e.getMessage() + "</td></tr>");
                    }
                }
            %>
        </tbody>
    </table>
    
    <button class="back-button" onclick="window.location.href='module2_product_availability.html'">Back</button>
</div>

<script>
    // Sorting function remains the same
</script>

</body>
</html>
