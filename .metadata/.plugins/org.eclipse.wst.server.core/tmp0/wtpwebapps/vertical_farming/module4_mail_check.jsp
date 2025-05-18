 <%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Get the email parameter from the previous page form submission
    String email = request.getParameter("email");

    // Database connection details
    String jdbcURL = "jdbc:mysql://localhost:3306/vertical_farming"; // Replace with your DB
    String jdbcUsername = "root"; // Replace with your DB username
    String jdbcPassword = "root"; // Replace with your DB password

    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;

    boolean emailExists = false;

    try {
        // Load the MySQL JDBC driver
        Class.forName("com.mysql.jdbc.Driver");

        // Establish the connection
        connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

        // Prepare SQL query to check if the email exists
        String sql = "SELECT * FROM module_4_harvesting WHERE email = ?";
        preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, email);

        // Execute the query
        resultSet = preparedStatement.executeQuery();

        if (resultSet.next()) {
            // Email exists in the database
            emailExists = true;

            // Retrieve user details
            String id = resultSet.getString("id");
            String name = resultSet.getString("name");
            String phoneNumber = resultSet.getString("phone_number");
            String address = resultSet.getString("address");
            String password = resultSet.getString("password");
            String status = resultSet.getString("status");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Details</title>
    <style>
        html, body {
            height: 100%;
            margin: 0;
            background: linear-gradient(45deg, #49a09d, #5f2c82);
            font-family: sans-serif;
            font-weight: 100;
        }

        .container {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
        }

        h1 {
            text-align: center;
            color: white;
            font-size: 28px;
            margin-bottom: 20px;
            text-transform: uppercase;
        }

        table {
            width: 800px;
            border-collapse: collapse;
            overflow: hidden;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
        }

        th,
        td {
            padding: 15px;
            background-color: rgba(255, 255, 255, 0.2);
            color: #fff;
        }

        th {
            text-align: left;
        }

        thead th {
            background-color: #55608f;
        }

        tbody tr:hover {
            background-color: rgba(255, 255, 255, 0.3);
        }

        td {
            position: relative;
        }

        td:hover:before {
            content: "";
            position: absolute;
            left: 0;
            right: 0;
            top: -9999px;
            bottom: -9999px;
            background-color: rgba(255, 255, 255, 0.2);
            z-index: -1;
        }

        .back-button {
            position: absolute;
            bottom: 20px;
            right: 20px;
            background-color: #5f2c82;
            color: white;
            padding: 10px 20px;
            border: none;
            cursor: pointer;
            text-transform: uppercase;
        }

        .back-button:hover {
            background-color: #49a09d;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>DETECTION EMPLOYEE</h1>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone Number</th>
                    <th>Address</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><%= id %></td>
                    <td><%= name %></td>
                    <td><%= email %></td>
                    <td><%= phoneNumber %></td>
                    <td><%= address %></td>
                    <td><%= status %></td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- Back Button -->
    <button class="back-button" onclick="window.location.href='module4_mailstatus.html'">Back</button>
</body>
</html>

<%
        } else {
            // Email does not exist, redirect to module2_mailstatus.html with a popup
%>
    <script type="text/javascript">
        alert("Email not found!");
        window.location.href = "module2_mailstatus.html";
    </script>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (resultSet != null) resultSet.close();
        if (preparedStatement != null) preparedStatement.close();
        if (connection != null) connection.close();
    }
%>
 