<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="dbconnection.Dbconn"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>View LogStatus - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
    <style type="text/css">
        @import url(https://fonts.googleapis.com/css?family=Open+Sans:400,600);

        *, *:before, *:after {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background: url("leaf.jpg") no-repeat center center fixed;
            background-size: cover;
            font-family: 'Open Sans', sans-serif;
            color: #fff; /* Ensure text is visible on dark backgrounds */
        }

        table {
            background: #012B39;
            border-radius: 0.25em;
            border-collapse: collapse;
            margin: 1em;
            margin-left: auto;  
            margin-right: auto; 
            margin-top: 1em; 
        }

        th {
            border-bottom: 1px solid #364043;
            color: #E2B842;
            font-size: 0.85em;
            font-weight: 600;
            padding: 0.5em 1em;
            text-align: center;
        }

        td {
            color: #fff;
            font-weight: 400;
            padding: 0.65em 1em;  
        }

        .disabled td {
            color: #4F5F64;
        }

        tbody tr {
            transition: background 0.25s ease;
        }

        tbody tr:hover {
            background: #014055;
        }

        h1 {
            padding-top: 80px;
            text-align: center;
            color: black;
        }

        .btn-disabled {
            pointer-events: none;
            opacity: 0.6;
            background-color: black; 
            border-color: black; 
            color: white; 
        }

        .back-button {
            position: fixed;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-align: center;
            font-size: 16px;
        }

        .back-button:hover {
            background-color: #45a049;
        }
    </style>
    <script>
        function disableButton(buttonId) {
            var button = document.getElementById(buttonId);
            button.classList.add('btn-disabled');
            button.textContent = 'Processing...';
            button.disabled = true;
        }

        window.onload = function() {
            var acceptButtons = document.querySelectorAll('.btn-success');
            acceptButtons.forEach(function(button) {
                if (button.classList.contains('btn-disabled')) {
                    button.disabled = true;
                    button.classList.add('btn-disabled');
                }
            });
        }
    </script>
</head>
<body>
<h1 style="color: black;">CULTIVATION EMPLOYEE DETAILS AND STATUS</h1>
<table>
<%
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        // Establish connection
        conn = Dbconn.getconnection();
        
        String qry = "SELECT * FROM module_3_cultivation";
        ps = conn.prepareStatement(qry);
        rs = ps.executeQuery();
%>
    <thead>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Address</th>
            <th>Password</th>
            <th>Status</th>
            <th>Action</th>
        </tr>
    </thead>
    <tbody>
    <%
        while (rs.next()) {
    %>
        <tr style="text-align: center;">
            <td><%= rs.getString("id") %></td>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("email") %></td>
            <td><%= rs.getString("phone_number") %></td>
            <td><%= rs.getString("address") %></td>
            <td><%= rs.getString("password") %></td>
            <td><%= rs.getString("status") %></td>
            <%
            if (rs.getString("status").equalsIgnoreCase("Accepted")) {
            %>
                <td>
                    <a href="admin_approval_cultivation_mail.jsp?user_name=<%= rs.getString("name") %>&email=<%= rs.getString("email") %>&password=<%= rs.getString("password") %>" 
                       id="accept_<%= rs.getString("email") %>" class="btn btn-dark btn-disabled" style="pointer-events: none; text-decoration: none; color: black;">Accept</a>
                    <br><br>
                    <a href="admin_reject_cultivation_mail.jsp?name=<%= rs.getString("name") %>&email=<%= rs.getString("email") %>" class="btn btn-danger">Reject</a>
                </td>
            <%
            } else {
            %>
                <td>
                    <a id="accept_<%= rs.getString("email") %>" href="admin_approval_cultivation_mail.jsp?user_name=<%= rs.getString("name") %>&email=<%= rs.getString("email") %>&password=<%= rs.getString("password") %>" 
                       class="btn btn-success" onclick="disableButton('accept_<%= rs.getString("email") %>');">Accept</a>
                    <br><br>
                    <a href="admin_reject_cultivation_mail.jsp?name=<%= rs.getString("name") %>&email=<%= rs.getString("email") %>" class="btn btn-danger">Reject</a>
                </td>
            <%
            }
            %>
        </tr>
    <%
        }
    } catch (SQLException e) {
        out.println("SQL Error: " + e.getMessage());
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        // Clean up resources
        try {
            if (rs != null) rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if (ps != null) ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
    </tbody>
</table>
<br><center><a href="employeedropdown.html" class="btn btn-primary">Go Back</a></center>
</body>
</html>
