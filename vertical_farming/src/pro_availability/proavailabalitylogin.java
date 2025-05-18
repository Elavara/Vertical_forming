package pro_availability;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/proavailabalitylogin")
public class proavailabalitylogin extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static final String DB_URL = "jdbc:mysql://localhost:3306/vertical_farming";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("username");
        String password = request.getParameter("password");
        System.out.println(email);

        System.out.println(password);
        boolean isValidUser = false;

        try {
            // Load database driver (optional for newer versions)
            Class.forName("com.mysql.jdbc.Driver");
            
            // Establish connection to the database
            Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            
            // Prepare SQL query to select user
            String query = "SELECT * FROM module_2_pro_availability WHERE email = ? AND password = ?";
            PreparedStatement preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, email);
            preparedStatement.setString(2, password);
            
            // Execute query
            ResultSet resultSet = preparedStatement.executeQuery();
            
            // Check if user exists
            if (resultSet.next()) {
                isValidUser = true;
            }
            
            resultSet.close();
            preparedStatement.close();
            connection.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (isValidUser) {
            // Redirect to detect homepage
            response.sendRedirect("module2_product_availability.html");
        } else {
            // Send an alert and redirect back to login page
            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
            out.println("<script type='text/javascript'>");
            out.println("alert('Invalid email or password');");
            out.println("window.location.href = 'module2_login.html';");
            out.println("</script>");
        }
    }
}
