<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cultivation Calculation Data</title>
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
    <h1 style="color: black; text-transform: uppercase;">Cultivation  DATA Processing</h1>
    <table id="myTable">
        <thead>
            <tr>
                <th onclick="sortTable(0)">S.No</th>
                <th onclick="sortTable(1)">Employee ID</th>
                <th onclick="sortTable(2)">Fruits/Veg.</th> <!-- Added Fruits/Veg. column -->
                <th onclick="sortTable(3)">Growth Impact of Sunlight</th>
                <th onclick="sortTable(4)">Nutrient Growth Factor</th>
                <th onclick="sortTable(5)">Space Efficiency Impact</th>
                <th onclick="sortTable(6)">Estimated Days to Cultivate</th>
                <th onclick="sortTable(7)">Yield Efficiency</th>
                <th onclick="sortTable(8)">Projected Harvest</th>
                <th onclick="sortTable(9)">Cultivation Efficiency Ratio</th>
                <th>Calculate</th>
            </tr>
        </thead>
        <tbody>
            <%
                String jdbcUrl = "jdbc:mysql://localhost:3306/vertical_farming"; // Update with your database name
                String dbUser = "root"; // Update with your database username
                String dbPassword = "root"; // Update with your database password

                Connection conn = null;
                Statement stmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
                    stmt = conn.createStatement();
                    String sql = "SELECT * FROM module3_cultivation_calculation_data"; // Update the SQL query to fetch data from the correct table
                    rs = stmt.executeQuery(sql);

                    while (rs.next()) {
                        %>
                        <tr>
                            <td data-label="S.No"><%= rs.getInt("Si_no") %></td>
                            <td data-label="Employee ID"><%= rs.getString("employee_id") %></td>
                            <td data-label="Fruits/Veg."><%= rs.getString("fruits_vegetables") != null ? rs.getString("fruits_vegetables") : "N/A" %></td> <!-- Null handling -->
                            <td data-label="Growth Impact of Sunlight"><%= rs.getString("growth_impact_sunlight") != null ? rs.getString("growth_impact_sunlight") : "N/A" %></td> <!-- Null handling -->
                            <td data-label="Nutrient Growth Factor"><%= rs.getString("nutrient_growth_factor") != null ? rs.getString("nutrient_growth_factor") : "N/A" %></td> <!-- Null handling -->
                            <td data-label="Space Efficiency Impact"><%= rs.getString("space_efficiency_impact") != null ? rs.getString("space_efficiency_impact") : "N/A" %></td> <!-- Null handling -->
                            <td data-label="Estimated Days to Cultivate"><%= rs.getString("estimated_days_to_cultivate") != null ? rs.getString("estimated_days_to_cultivate") : "N/A" %></td> <!-- Null handling -->
                            <td data-label="Yield Efficiency"><%= rs.getString("yield_efficiency") != null ? rs.getString("yield_efficiency") : "N/A" %></td> <!-- Null handling -->
                            <td data-label="Projected Harvest"><%= rs.getString("projected_harvest") != null ? rs.getString("projected_harvest") : "N/A" %></td> <!-- Null handling -->
                            <td data-label="Cultivation Efficiency Ratio"><%= rs.getString("cultivation_efficiency_ratio") != null ? rs.getString("cultivation_efficiency_ratio") : "N/A" %></td> <!-- Null handling -->
                            <td>
                                <button onclick="calculate(<%= rs.getInt("Si_no") %>, '<%= rs.getString("employee_id") %>', '<%= rs.getString("fruits_vegetables") %>', '<%= rs.getString("growth_impact_sunlight") %>', '<%= rs.getString("nutrient_growth_factor") %>', '<%= rs.getString("space_efficiency_impact") %>', '<%= rs.getString("estimated_days_to_cultivate") %>', '<%= rs.getString("yield_efficiency") %>', '<%= rs.getString("projected_harvest") %>', '<%= rs.getString("cultivation_efficiency_ratio") %>')">Calculate</button>
                            </td>
                        </tr>
                        <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
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
    
    <button class="back-button" onclick="window.location.href='module4_harvestinghomepage.html'">Back</button>
</div>

<script>
    function sortTable(n) {
        var table, rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
        table = document.getElementById("myTable");
        switching = true;
        dir = "asc"; 
        while (switching) {
            switching = false;
            rows = table.rows;
            for (i = 1; i < (rows.length - 1); i++) {
                shouldSwitch = false;
                x = rows[i].getElementsByTagName("TD")[n];
                y = rows[i + 1].getElementsByTagName("TD")[n];
                if (dir == "asc") {
                    if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
                        shouldSwitch = true;
                        break;
                    }
                } else if (dir == "desc") {
                    if (x.innerHTML.toLowerCase() < y.innerHTML.toLowerCase()) {
                        shouldSwitch = true;
                        break;
                    }
                }
            }
            if (shouldSwitch) {
                rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
                switching = true;
                switchcount++;
            } else {
                if (switchcount == 0 && dir == "asc") {
                    dir = "desc";
                    switching = true;
                }
            }
        }
    }

    function calculate(sNo, employeeId, fruitsVeg, sunlightImpact, nutrientFactor, spaceEfficiency, estimatedDays, yieldEfficiency, projectedHarvest, efficiencyRatio) {
        window.location.href = 'module4_harvesting_calculation.jsp?sNo=' + sNo + 
            '&employeeId=' + encodeURIComponent(employeeId) + 
            '&fruitsVeg=' + encodeURIComponent(fruitsVeg) + 
            '&sunlightImpact=' + encodeURIComponent(sunlightImpact) + 
            '&nutrientFactor=' + encodeURIComponent(nutrientFactor) + 
            '&spaceEfficiency=' + encodeURIComponent(spaceEfficiency) + 
            '&estimatedDays=' + encodeURIComponent(estimatedDays) + 
            '&yieldEfficiency=' + encodeURIComponent(yieldEfficiency) + 
            '&projectedHarvest=' + encodeURIComponent(projectedHarvest) + 
            '&efficiencyRatio=' + encodeURIComponent(efficiencyRatio);
    }
</script>

</body>
</html>
