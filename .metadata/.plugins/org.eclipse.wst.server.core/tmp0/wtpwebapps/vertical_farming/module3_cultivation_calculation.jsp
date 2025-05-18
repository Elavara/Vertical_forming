<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
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
            padding: 0;
            background-image: url('m3u.png'); /* Add your background image path here */
            background-size: cover; /* Cover the entire body */
            background-position: center; /* Center the image */
        }

        .container {
            width: 90%;
            max-width: 800px;
            margin: 50px auto;
            background-color: rgba(255, 255, 255, 0.8); /* Slightly transparent white for better visibility */
            padding: 20px;
            box-shadow: 0px 6px 18px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            position: relative; /* Added to position child elements */
        }

        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
            text-transform: uppercase;
        }

        .back-button, .calculate-button {
            padding: 10px 15px;
            font-size: 16px;
            color: white;
            background-color: #4CAF50;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            display: block;
            margin: 20px auto 0;
            width: 150px;
            text-align: center;
        }

        .back-button:hover, .calculate-button:hover {
            background-color: #45a049;
        }

        /* New styles for positioning */
        .back-button {
            position: absolute; /* Allows positioning at bottom right */
            bottom: 20px;
            right: 20px;
        }

        .calculate-button {
            margin: 30px auto 0; /* Centered with margin */
        }
    </style>
</head>
<body>

<div class="container">
    <h1>Calculated Data</h1>
    <form id="calculationForm" action="CultivationDataServlet" method="post"> <!-- Update with your servlet URL -->
        <%
            // Parse the parameters as doubles
            String fruitsVegetables = request.getParameter("fruits_vegetables");
            double estimatedTime = Double.parseDouble(request.getParameter("estimated_time_days"));
            double totalQuantityAvailable = Double.parseDouble(request.getParameter("total_quantity_available"));
            double projectedGrowthNextMonth = Double.parseDouble(request.getParameter("projected_growth_next_month"));
            double inventoryTurnoverRate = Double.parseDouble(request.getParameter("inventory_turnover_rate"));
            double daysUntilFullStock = Double.parseDouble(request.getParameter("days_until_full_stock"));
            double supplyDeficit = Double.parseDouble(request.getParameter("supply_deficit"));
            double growthPotential = Double.parseDouble(request.getParameter("growth_potential"));

            // Initialize variables for averages and totals
            double totalSunlightExposure = 0.0;
            double totalGrowthRate = 0.0;
            double totalNutrientDelivery = 0.0;
            double totalSpaceEfficiency = 0.0;
            int count = 0;

            // Connect to the database and retrieve cultivation data
            String jdbcUrl = "jdbc:mysql://localhost:3306/vertical_farming"; // Update with your database name
            String dbUser = "root"; // Update with your database username
            String dbPassword = "root"; // Update with your database password

            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                // Establishing a database connection
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);

                // Prepare statement to select rows matching the fruits_vegetables parameter
                String sql = "SELECT * FROM module3_cultivation_uploaded WHERE `Fruits/Vegetables` = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, fruitsVegetables);
                rs = pstmt.executeQuery();

                // Loop through the result set and aggregate data for calculations
                while (rs.next()) {
                    totalSunlightExposure += rs.getDouble("Sunlight Exposure (hours/day)");
                    totalGrowthRate += rs.getDouble("Growth Rate (days)");
                    totalNutrientDelivery += rs.getDouble("Nutrient Delivery (g/week)");
                    totalSpaceEfficiency += rs.getDouble("Space Efficiency (sq ft/plant)");
                    count++;
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                // Closing resources
                try {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }

            // Perform average calculations if count is not zero
            if (count > 0) {
                double avgSunlightExposure = totalSunlightExposure / count;
                double avgGrowthRate = totalGrowthRate / count;
                double avgNutrientDelivery = totalNutrientDelivery / count;
                double avgSpaceEfficiency = totalSpaceEfficiency / count;

                // Example final calculations
                double growthImpact = (avgSunlightExposure * totalQuantityAvailable) / avgGrowthRate;
                double nutrientGrowthFactor = (avgNutrientDelivery * growthPotential) / avgGrowthRate;
                double spaceEfficiencyImpact = totalQuantityAvailable / avgSpaceEfficiency;

                // Additional Calculations
                double estimatedDaysToCultivate = avgGrowthRate;  // Directly using average growth rate
                double yieldEfficiency = totalQuantityAvailable / avgSpaceEfficiency;
                double projectedHarvestInXDays = (projectedGrowthNextMonth / 30) * estimatedDaysToCultivate;  // Assuming monthly growth
                double cultivationEfficiencyRatio = (avgNutrientDelivery * avgSpaceEfficiency) / avgGrowthRate;

                // Output the calculated results
                out.println("<p><strong>Growth Impact from Sunlight Exposure: </strong>" + String.format("%.2f", growthImpact) + " tons/day</p>");
                out.println("<p><strong>Nutrient Growth Factor: </strong>" + String.format("%.2f", nutrientGrowthFactor) + " tons</p>");
                out.println("<p><strong>Space Efficiency Impact: </strong>" + String.format("%.2f", spaceEfficiencyImpact) + " tons</p>");
                out.println("<p><strong>Estimated Days to Cultivate: </strong>" + String.format("%.2f", estimatedDaysToCultivate) + " days</p>");
                out.println("<p><strong>Yield Efficiency: </strong>" + String.format("%.2f", yieldEfficiency) + " tons/plant sq.ft</p>");
                out.println("<p><strong>Projected Harvest in " + String.format("%.2f", estimatedDaysToCultivate) + " Days: </strong>" + String.format("%.2f", projectedHarvestInXDays) + " tons</p>");
                out.println("<p><strong>Cultivation Efficiency Ratio: </strong>" + String.format("%.2f", cultivationEfficiencyRatio) + " units</p>");

                // Adding hidden inputs for calculated results
                out.println("<input type='hidden' name='fruits_vegetables' value='" + fruitsVegetables + "' />"); // Added hidden input for fruits/vegetables
                out.println("<input type='hidden' name='growthImpact' value='" + String.format("%.2f", growthImpact) + "' />");
                out.println("<input type='hidden' name='nutrientGrowthFactor' value='" + String.format("%.2f", nutrientGrowthFactor) + "' />");
                out.println("<input type='hidden' name='spaceEfficiencyImpact' value='" + String.format("%.2f", spaceEfficiencyImpact) + "' />");
                out.println("<input type='hidden' name='estimatedDaysToCultivate' value='" + String.format("%.2f", estimatedDaysToCultivate) + "' />");
                out.println("<input type='hidden' name='yieldEfficiency' value='" + String.format("%.2f", yieldEfficiency) + "' />");
                out.println("<input type='hidden' name='projectedHarvestInXDays' value='" + String.format("%.2f", projectedHarvestInXDays) + "' />");
                out.println("<input type='hidden' name='cultivationEfficiencyRatio' value='" + String.format("%.2f", cultivationEfficiencyRatio) + "' />");
            } else {
                out.println("<p>No cultivation data available for calculation.</p>");
            }
        %>

        <button type="button" class="calculate-button" onclick="document.getElementById('calculationForm').submit()">Submit</button>
        <a href="module3_culativation_process.jsp" class="back-button">Go Back</a>
    </form>
</div>

</body>
</html>
