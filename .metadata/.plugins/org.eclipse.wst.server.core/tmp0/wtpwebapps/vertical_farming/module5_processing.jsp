<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Harvesting Calculation Data</title>
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
    <h1 style="color: black; text-transform: uppercase;">Harvesting Data processing</h1>
    <table id="myTable">
        <thead>
            <tr>
                <th onclick="sortTable(0)">S.No</th>
                <th onclick="sortTable(1)">Employee ID</th>
                <th onclick="sortTable(2)">Crop</th>
                <th onclick="sortTable(3)">Water Usage</th>
                <th onclick="sortTable(4)">Total Nutrients</th>
                <th onclick="sortTable(5)">Harvest Efficiency</th>
                <th onclick="sortTable(6)">Space Utilization</th>
                <th onclick="sortTable(7)">Yield Comparison</th>
                <th onclick="sortTable(8)">Sunlight Efficiency</th>
                <th onclick="sortTable(9)">Total Weight</th>
                <th>Action</th>
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
                    String sql = "SELECT * FROM module4_harvesting_calculation"; 
                    rs = stmt.executeQuery(sql);

                    while (rs.next()) {
                        %>
                        <tr>
                            <td data-label="S.No"><%= rs.getInt("si_no") %></td>
                            <td data-label="Employee ID"><%= rs.getString("employee_id") %></td>
                            <td data-label="Crop"><%= rs.getString("crop") != null ? rs.getString("crop") : "N/A" %></td>
                            <td data-label="Water Usage"><%= rs.getString("water_usage") != null ? rs.getString("water_usage") : "N/A" %></td>
                            <td data-label="Total Nutrients"><%= rs.getString("total_nutrients") != null ? rs.getString("total_nutrients") : "N/A" %></td>
                            <td data-label="Harvest Efficiency"><%= rs.getString("harvest_efficiency") != null ? rs.getString("harvest_efficiency") : "N/A" %></td>
                            <td data-label="Space Utilization"><%= rs.getString("space_utilization") != null ? rs.getString("space_utilization") : "N/A" %></td>
                            <td data-label="Yield Comparison"><%= rs.getString("yield_comparison") != null ? rs.getString("yield_comparison") : "N/A" %></td>
                            <td data-label="Sunlight Efficiency"><%= rs.getString("sunlight_efficiency") != null ? rs.getString("sunlight_efficiency") : "N/A" %></td>
                            <td data-label="Total Weight"><%= rs.getString("total_weight") != null ? rs.getString("total_weight") : "N/A" %></td>
                            <td data-label="Action">
                                <form action="module5_calculation.jsp" method="post" style="display:inline;">
                                    <input type="hidden" name="si_no" value="<%= rs.getInt("si_no") %>">
                                    <input type="hidden" name="employee_id" value="<%= rs.getString("employee_id") %>">
                                    <input type="hidden" name="crop" value="<%= rs.getString("crop") != null ? rs.getString("crop") : "N/A" %>">
                                    <input type="hidden" name="water_usage" value="<%= rs.getString("water_usage") != null ? rs.getString("water_usage") : "N/A" %>">
                                    <input type="hidden" name="total_nutrients" value="<%= rs.getString("total_nutrients") != null ? rs.getString("total_nutrients") : "N/A" %>">
                                    <input type="hidden" name="harvest_efficiency" value="<%= rs.getString("harvest_efficiency") != null ? rs.getString("harvest_efficiency") : "N/A" %>">
                                    <input type="hidden" name="space_utilization" value="<%= rs.getString("space_utilization") != null ? rs.getString("space_utilization") : "N/A" %>">
                                    <input type="hidden" name="yield_comparison" value="<%= rs.getString("yield_comparison") != null ? rs.getString("yield_comparison") : "N/A" %>">
                                    <input type="hidden" name="sunlight_efficiency" value="<%= rs.getString("sunlight_efficiency") != null ? rs.getString("sunlight_efficiency") : "N/A" %>">
                                    <input type="hidden" name="total_weight" value="<%= rs.getString("total_weight") != null ? rs.getString("total_weight") : "N/A" %>">
                                    <button type="submit" style="background-color: rgba(76, 175, 80, 0.8); color: white; border: none; border-radius: 5px; cursor: pointer;">Calculate</button>
                                </form>
                            </td>
                        </tr>
                        <%
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                } catch (ClassNotFoundException e) {
                    e.printStackTrace();
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) {}
                    if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
                    if (conn != null) try { conn.close(); } catch (SQLException e) {}
                }
            %>
        </tbody>
    </table>
    
<button class="back-button" onclick="window.location.href='module5_testing_homepage.html'">Go Back</button>

</div>

<script>
    function sortTable(columnIndex) {
        var table = document.getElementById("myTable");
        var rows = Array.from(table.rows).slice(1);
        var isAscending = table.querySelector("th:nth-child(" + (columnIndex + 1) + ")").classList.toggle("asc");

        rows.sort((a, b) => {
            var cellA = a.cells[columnIndex].innerText;
            var cellB = b.cells[columnIndex].innerText;

            if (isNaN(cellA) || isNaN(cellB)) {
                return cellA.localeCompare(cellB) * (isAscending ? 1 : -1);
            } else {
                return (parseFloat(cellA) - parseFloat(cellB)) * (isAscending ? 1 : -1);
            }
        });

        rows.forEach(row => table.appendChild(row));
    }
</script>

</body>
</html>
