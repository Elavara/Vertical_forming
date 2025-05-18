<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Client Request Interactive Table</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-image: url('clv.jpg'); /* Update with your image path */
            background-size: cover; /* Cover the entire page */
            background-position: center; /* Center the image */
            background-repeat: no-repeat; /* Prevent repeating */
            margin: 0;
            padding: 20px;
            color: black; /* Change text color to ensure readability */
        }

        h2 {
            text-align: center;
            color: white; /* Changed to white as per your previous request */
            text-transform: uppercase;
        }

        .table-container {
            width: 100%;
            max-width: 100%;
            overflow-x: auto; /* Enable horizontal scrolling */
            overflow-y: auto; /* Enable vertical scrolling */
            white-space: nowrap; /* Ensure content doesn't wrap */
            max-height: 80vh; /* Set max height for the table container */
            border: 1px solid #ddd;
            padding: 10px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            font-size: 16px;
            background-color: rgba(255, 255, 255, 0.8); /* Transparent background */
            border-radius: 5px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: rgba(0, 168, 232, 0.9); /* Slightly transparent header */
            color: white;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        tr {
            cursor: pointer;
        }

        tr:hover {
            background-color: #ffeb3b;
            color: #333;
        }

        tbody tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        .back-button {
            position: fixed; /* Fixed positioning */
            bottom: 20px; /* 20px from the bottom */
            right: 20px; /* 20px from the right */
            background-color: #00a8e8; /* Button color */
            color: white; /* Text color */
            border: none; /* Remove border */
            padding: 10px 20px; /* Padding */
            border-radius: 5px; /* Rounded corners */
            cursor: pointer; /* Pointer cursor */
            font-size: 16px; /* Font size */
        }

        .back-button:hover {
            background-color: #007bb5; /* Darker shade on hover */
        }
    </style>
</head>
<body>

    <h2>Client Request Interactive Table</h2>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>Client ID</th>
                    <th>No.</th>
                    <th>Fruit/Vegetable</th>
                    <th>Variety</th>
                    <th>No. of Tons Needed</th>
                    <th>Time Period (Months)</th>
                    <th>Request Date</th>
                    <th>Client Notes</th>
                    <th>Requested By</th>
                    <th>Request Status</th>
                    <th>Delivery Date</th>
                </tr>
            </thead>
            <tbody>
                <%
                    // Database connection setup
                    String dbURL = "jdbc:mysql://localhost:3306/vertical_farming";
                    String user = "root";
                    String pass = "root";
                    Connection conn = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("com.mysql.jdbc.Driver"); // Update to the correct driver class
                        conn = DriverManager.getConnection(dbURL, user, pass);

                        String sql = "SELECT * FROM client_request"; // Adjusted SQL to match table structure
                        stmt = conn.prepareStatement(sql);
                        rs = stmt.executeQuery();

                        // Loop through result set and display rows in table
                        while (rs.next()) {
                            String clientId = rs.getString("client_id");
                            String no = rs.getString("No");
                            String fruitVegetable = rs.getString("Fruit_Vegetable");
                            String variety = rs.getString("Variety");
                            String noOfTonsNeeded = rs.getString("No_of_Tons_Needed");
                            String timePeriodMonths = rs.getString("Time_Period_Months");
                            String requestDate = rs.getString("Request_Date");
                            String clientNotes = rs.getString("Client_Notes");
                            String requestedBy = rs.getString("Requested_By");
                            String requestStatus = rs.getString("Request_Status");
                            String deliveryDate = rs.getString("Delivery_Date");

                            out.println("<tr>");
                            out.println("<td>" + clientId + "</td>");
                            out.println("<td>" + no + "</td>");
                            out.println("<td>" + fruitVegetable + "</td>");
                            out.println("<td>" + variety + "</td>");
                            out.println("<td>" + noOfTonsNeeded + "</td>");
                            out.println("<td>" + timePeriodMonths + "</td>");
                            out.println("<td>" + requestDate + "</td>");
                            out.println("<td>" + clientNotes + "</td>");
                            out.println("<td>" + requestedBy + "</td>");
                            out.println("<td>" + requestStatus + "</td>");
                            out.println("<td>" + deliveryDate + "</td>");
                            out.println("</tr>");
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    }
                %>
            </tbody>
        </table>
    </div>

    <button class="back-button" onclick="window.location.href='adminhomepage.html'">Back</button>

</body>
</html>
