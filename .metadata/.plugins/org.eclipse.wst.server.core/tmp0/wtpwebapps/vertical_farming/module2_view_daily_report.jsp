<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crop Status Overview</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-image: url('mod2.jpg'); /* Update with your image path */
            background-size: cover; /* Cover the whole page */
            background-position: center; /* Center the image */
            background-attachment: fixed; /* Fix the background while scrolling */
            margin: 0;
            padding: 20px;
        }

        h2 {
            text-align: center;
            color: #333;
        }

        .table-container {
            width: 100%;
            margin: auto;
            overflow-x: auto;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            background-color: rgba(255, 255, 255, 0.8); /* White with 80% opacity for transparency */
            border-radius: 8px;
            overflow: hidden;
        }

        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid rgba(0, 0, 0, 0.1); /* Light border */
        }

        th {
            background-color: #388e3c; /* Dark green header */
            color: white;
            cursor: pointer;
        }

        td.status {
            font-weight: bold;
            text-align: center;
        }

        .available {
            color: green;
        }

        .growing {
            color: orange;
        }

        .not-available {
            color: red;
        }

        tr:hover {
            background-color: rgba(200, 230, 201, 0.5); /* Light green on hover with opacity */
            cursor: pointer; /* Change cursor to pointer */
        }
    </style>
</head>
<body>

   <h2 style="text-transform: uppercase; color: white;">Crop Status Overview</h2>

    <div class="table-container">
        <table id="cropTable">
            <thead>
                <tr>
                    <th onclick="sortTable(0)">Crop Name</th>
                    <th onclick="sortTable(1)">Total Quantity</th>
                    <th onclick="sortTable(2)">Quantity Available</th>
                    <th onclick="sortTable(3)">Growing Status</th>
                    <th onclick="sortTable(4)">Number of Growing</th>
                    <th onclick="sortTable(5)">Number of Fully Grown</th>
                    <th onclick="sortTable(6)">Growing Quantity</th>
                    <th onclick="sortTable(7)">Fully Grown Quantity</th>
                    <th onclick="sortTable(8)">Estimated Days to Maturity</th>
                    <th onclick="sortTable(9)">Notes</th>
                </tr>
            </thead>
            <tbody>
             <%
                    // Database connection details
                    String jdbcUrl = "jdbc:mysql://localhost:3306/vertical_farming"; // Update with your database name
                    String dbUser = "root"; // Update with your database username
                    String dbPassword = "root"; // Update with your database password

                    Connection conn = null;
                    Statement stmt = null;
                    ResultSet rs = null;

                    try {
                        // Establishing a database connection
                        Class.forName("com.mysql.jdbc.Driver"); // Ensure MySQL JDBC driver is included in your project
                        conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
                        stmt = conn.createStatement();
                        String sql = "SELECT Fruit_Vegetable, Total_Quantity, Quantity_Available, Growing_Status, Number_of_Growing, Number_of_Fully_Grown, Growing_Quantity, Fully_Grown_Quantity, Estimated_Days_to_Maturity, Notes FROM module2_product_availability_upload";
                        rs = stmt.executeQuery(sql);

                        // Loop through the result set and display the data in the table
                        while (rs.next()) {
                            String fruitVegetable = rs.getString("Fruit_Vegetable");
                            String totalQuantity = rs.getString("Total_Quantity");
                            String quantityAvailable = rs.getString("Quantity_Available");
                            String growingStatus = rs.getString("Growing_Status");
                            String numberOfGrowing = rs.getString("Number_of_Growing");
                            String numberOfFullyGrown = rs.getString("Number_of_Fully_Grown");
                            String growingQuantity = rs.getString("Growing_Quantity");
                            String fullyGrownQuantity = rs.getString("Fully_Grown_Quantity");
                            String estimatedDaysToMaturity = rs.getString("Estimated_Days_to_Maturity");
                            String notes = rs.getString("Notes");

                            // Determine the status class based on the growing status
                            String statusClass = "";
                            if ("Available".equalsIgnoreCase(growingStatus)) {
                                statusClass = "available";
                            } else if ("Growing".equalsIgnoreCase(growingStatus)) {
                                statusClass = "growing";
                            } else {
                                statusClass = "not-available";
                            }
                            %>
                            <tr onclick="showCropDetails('<%= fruitVegetable %>', '<%= totalQuantity %>', '<%= quantityAvailable %>', '<%= growingStatus %>', '<%= numberOfGrowing %>', '<%= numberOfFullyGrown %>', '<%= growingQuantity %>', '<%= fullyGrownQuantity %>', '<%= estimatedDaysToMaturity %>', '<%= notes %>')">
                                <td><%= fruitVegetable %></td>
                                <td><%= totalQuantity %></td>
                                <td><%= quantityAvailable %></td>
                                <td class="status <%= statusClass %>"><%= growingStatus %></td>
                                <td><%= numberOfGrowing %></td>
                                <td><%= numberOfFullyGrown %></td>
                                <td><%= growingQuantity %></td>
                                <td><%= fullyGrownQuantity %></td>
                                <td><%= estimatedDaysToMaturity %></td>
                                <td><%= notes %></td>
                            </tr>
                            <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        // Closing the resources
                        try {
                            if (rs != null) rs.close();
                            if (stmt != null) stmt.close();
                            if (conn != null) conn.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                %> </tbody>
        </table>
    </div>
      <button onclick="goBack()" style="position: fixed; bottom: 20px; right: 20px; padding: 10px 20px; background-color: #388e3c; color: white; border: none; border-radius: 5px; cursor: pointer;">
        Back
    </button>

    <script>
    function goBack() {
        window.location.href = 'module2_product_availability.html';
    }
    
    
        function sortTable(n) {
            const table = document.getElementById("cropTable");
            let switching = true;
            let shouldSwitch;
            let dir = "asc"; // Set the sorting direction to ascending
            let switchcount = 0;
            
            while (switching) {
                switching = false;
                const rows = table.rows;

                for (let i = 1; i < (rows.length - 1); i++) {
                    shouldSwitch = false;

                    const x = rows[i].getElementsByTagName("TD")[n];
                    const y = rows[i + 1].getElementsByTagName("TD")[n];

                    if (dir === "asc") {
                        if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
                            shouldSwitch = true;
                            break;
                        }
                    } else if (dir === "desc") {
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
                    if (switchcount === 0 && dir === "asc") {
                        dir = "desc"; // If no switching has been done and the direction is "asc", set the direction to "desc"
                        switching = true;
                    }
                }
            }
        }

        function showCropDetails(name, totalQuantity, quantityAvailable, status, numberOfGrowing, numberOfFullyGrown, growingQuantity, fullyGrownQuantity, estimatedDays, notes) {
            alert(`Crop Details:\n\nName: ${name}\nTotal Quantity: ${totalQuantity}\nQuantity Available: ${quantityAvailable}\nStatus: ${status}\nNumber of Growing: ${numberOfGrowing}\nNumber of Fully Grown: ${numberOfFullyGrown}\nGrowing Quantity: ${growingQuantity}\nFully Grown Quantity: ${fullyGrownQuantity}\nEstimated Days to Maturity: ${estimatedDays}\nNotes: ${notes}`);
        }
    </script>
</body>
</html>
