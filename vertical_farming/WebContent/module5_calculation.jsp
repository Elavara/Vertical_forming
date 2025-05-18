<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Set, java.util.HashSet" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Calculated Results</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background-image: url('test.jpg'); /* Background image path */
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            background-repeat: no-repeat;
        }
        .container {
            background: rgba(255, 255, 255, 0.9);
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.1);
            margin-bottom: 40px;
            text-align: center;
        }
        h1 {
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        .button-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
        }
        .button {
            background-color: rgba(76, 175, 80, 0.8);
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            padding: 10px 20px;
            font-size: 16px;
        }
        .button.back {
            background-color: #f44336;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>Calculated Results Table</h1>
    
    <form action="test_calculated" method="post">
        <table>
            <tr>
                <th>Variety</th>
                <th>Average Water Usage</th>
                <th>Total Weight</th>
                <th>Number of Records</th>
                <th>Average Nutrient Level</th>
                <th>Average Harvest Efficiency</th>
                <th>Average Space Utilization</th>
                <th>Average Yield Comparison</th>
                <th>Average Sunlight Efficiency</th>
                <th>Average Iron Level</th>
                <th>Average Protein Level</th>
                <th>Average Vitamin C Level</th>
            </tr>
            <tr>
                <%
                // Getting the crop from the previous page
                String crop = request.getParameter("crop");
                String jdbcUrl = "jdbc:mysql://localhost:3306/vertical_farming";
                String dbUser = "root";
                String dbPassword = "root";
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                
                double totalWaterUsage = 0;
                double totalWeightCalculated = 0;
                double totalNutrients = 0;
                double totalHarvestEfficiency = 0;
                double totalSpaceUtilization = 0;
                double totalYieldComparison = 0;
                double totalSunlightEfficiency = 0;
                double totalIronLevel = 0;
                double totalProteinLevel = 0;
                double totalVitaminCLevel = 0;
                int totalRecords = 0;

                // Set to keep track of varieties
                Set<String> varieties = new HashSet<>();

                try {
                    Class.forName("com.mysql.jdbc.Driver"); // Updated JDBC driver
                    conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
                    
                    // Query to find the matching variety
                    String sql = "SELECT * FROM module5_testing_upload WHERE Variety= ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, crop);
                    rs = pstmt.executeQuery();

                    while (rs.next()) {
                        // Get values from the result set
                        double waterUsage = rs.getDouble("WaterUsage"); // Fetching Water Usage from DB
                        double totalNutrient = rs.getDouble("TotalNutrient"); // Fetching Total Nutrient from DB
                        double harvestEfficiency = rs.getDouble("HarvestEfficiency"); // Fetching Harvest Efficiency from DB
                        double spaceUtilization = rs.getDouble("SpaceUtilization"); // Fetching Space Utilization from DB
                        double yieldComparison = rs.getDouble("YieldComparison"); // Fetching Yield Comparison from DB
                        double sunlightEfficiency = rs.getDouble("SunlightEfficiency"); // Fetching Sunlight Efficiency from DB
                        double totalWeight = rs.getDouble("Weight"); // Fetching Weight from DB
                        double ironLevel = rs.getDouble("IronLevel"); // Fetching Iron Level from DB
                        double proteinLevel = rs.getDouble("ProteinLevel"); // Fetching Protein Level from DB
                        double vitaminCLevel = rs.getDouble("VitaminCLevel"); // Fetching Vitamin C Level from DB

                        totalWaterUsage += waterUsage;
                        totalWeightCalculated += totalWeight;
                        totalNutrients += totalNutrient;
                        totalHarvestEfficiency += harvestEfficiency;
                        totalSpaceUtilization += spaceUtilization;
                        totalYieldComparison += yieldComparison;
                        totalSunlightEfficiency += sunlightEfficiency;
                        totalIronLevel += ironLevel;
                        totalProteinLevel += proteinLevel;
                        totalVitaminCLevel += vitaminCLevel;
                        totalRecords++;

                        varieties.add(rs.getString("Variety")); // Store unique varieties
                    }
                } catch (SQLException | ClassNotFoundException e) {
                    e.printStackTrace();
                } finally {
                    // Closing resources
                    if (rs != null) try { rs.close(); } catch (SQLException e) {}
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
                    if (conn != null) try { conn.close(); } catch (SQLException e) {}
                }

                // Calculate averages and display results
                double avgWaterUsage = totalWaterUsage / (totalRecords > 0 ? totalRecords : 1);
                double avgNutrients = totalNutrients / (totalRecords > 0 ? totalRecords : 1);
                double avgHarvestEfficiency = totalHarvestEfficiency / (totalRecords > 0 ? totalRecords : 1);
                double avgSpaceUtilization = totalSpaceUtilization / (totalRecords > 0 ? totalRecords : 1);
                double avgYieldComparison = totalYieldComparison / (totalRecords > 0 ? totalRecords : 1);
                double avgSunlightEfficiency = totalSunlightEfficiency / (totalRecords > 0 ? totalRecords : 1);
                double avgIronLevel = totalIronLevel / (totalRecords > 0 ? totalRecords : 1);
                double avgProteinLevel = totalProteinLevel / (totalRecords > 0 ? totalRecords : 1);
                double avgVitaminCLevel = totalVitaminCLevel / (totalRecords > 0 ? totalRecords : 1);
                %>

                <td><input type="hidden" name="varieties" value="<%= String.join(", ", varieties) %>"><%= String.join(", ", varieties) %></td>
                <td><input type="hidden" name="avgWaterUsage" value="<%= avgWaterUsage %>"><%= avgWaterUsage %></td>
                <td><input type="hidden" name="totalWeight" value="<%= totalWeightCalculated %>"><%= totalWeightCalculated %></td>
                <td><input type="hidden" name="totalRecords" value="<%= totalRecords %>"><%= totalRecords %></td>
                <td><input type="hidden" name="avgNutrients" value="<%= avgNutrients %>"><%= avgNutrients %></td>
                <td><input type="hidden" name="avgHarvestEfficiency" value="<%= avgHarvestEfficiency %>"><%= avgHarvestEfficiency %></td>
                <td><input type="hidden" name="avgSpaceUtilization" value="<%= avgSpaceUtilization %>"><%= avgSpaceUtilization %></td>
                <td><input type="hidden" name="avgYieldComparison" value="<%= avgYieldComparison %>"><%= avgYieldComparison %></td>
                <td><input type="hidden" name="avgSunlightEfficiency" value="<%= avgSunlightEfficiency %>"><%= avgSunlightEfficiency %></td>
                <td><input type="hidden" name="avgIronLevel" value="<%= avgIronLevel %>"><%= avgIronLevel %></td>
                <td><input type="hidden" name="avgProteinLevel" value="<%= avgProteinLevel %>"><%= avgProteinLevel %></td>
                <td><input type="hidden" name="avgVitaminCLevel" value="<%= avgVitaminCLevel %>"><%= avgVitaminCLevel %></td>
            </tr>
        </table>
        
        <div class="button-container">
            <button type="button" class="button back" onclick="window.location.href='module5_processing.jsp'">Go Back</button>
            <button type="submit" class="button">Submit</button>
        </div>
    </form>
</div>

</body>
</html>
