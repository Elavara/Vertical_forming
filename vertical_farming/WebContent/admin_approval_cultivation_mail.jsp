<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="dbconnection.Dbconn"%>
<%@ page import="java.sql.*, java.util.*, java.io.*"%>
<%@ page import="javax.mail.*, javax.mail.internet.*, javax.activation.*"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%
Multipart multipart = new MimeMultipart();
MimeBodyPart textPart = new MimeBodyPart();

try {
    String name = request.getParameter("user_name");
    String coemail = request.getParameter("email");
    String pas = request.getParameter("password");
    String nn = "provided";

    // Create email content
    textPart.setContent("<html><head></head>"
        + "<body><p>Your Registered Mail ID by the name of <b>'" + coemail + "</b>' profile has been accepted successfully. Your password is <b>'" + pas + "</b>'. Make sure you enter this password while login.</p></body></html>",
        "text/html; charset=UTF-8");
    multipart.addBodyPart(textPart);

    String message1 = "Your Profile Accepted Successfully. Your password is '" + pas + "'.";
    String host = "smtp.gmail.com";
    String user = "elavarasans8056@gmail.com";
    String pass = "nkfyrgqpbfgdlrzv";  // Ensure you secure the password
    String SSL_FACTORY = "javax.net.ssl.SSLSocketFactory";
    String to = "elavarasans8056@gmail.com";
    String from = "elavarasans8056@gmail.com";
    String subject = "Employee Acceptance Information";

    // Set mail properties
    Properties props = System.getProperties();
    props.put("mail.smtp.host", host);
    props.put("mail.smtp.auth", "true");
    props.put("mail.smtp.port", "465");
    props.put("mail.smtp.socketFactory.class", SSL_FACTORY);
    props.put("mail.smtp.socketFactory.fallback", "false");
    props.put("mail.smtp.ssl.protocols", "TLSv1.2");

    Session mailSession = Session.getDefaultInstance(props, null);
    mailSession.setDebug(true);
    Message msg = new MimeMessage(mailSession);
    msg.setFrom(new InternetAddress(from));
    msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
    msg.setSubject(subject);
    msg.setContent(multipart);

    // Send email
    Transport transport = mailSession.getTransport("smtp");
    transport.connect(host, user, pass);
    transport.sendMessage(msg, msg.getAllRecipients());
    transport.close();

    // Update database status
    String pstatus = "Accepted";
    Connection conn = Dbconn.getconnection();
    String sql = "UPDATE module_3_cultivation SET status=? WHERE password=?";
    PreparedStatement ps = conn.prepareStatement(sql);
    ps.setString(1, pstatus);
    ps.setString(2, pas);
    int status = ps.executeUpdate();

    // Check if update was successful
    if (status > 0) {
        %>
        <script>
            alert("Acceptance details successfully sent to mail");
            window.location="adminhomepage.html";
        </script>
        <%
    } else {
        %>
        <script>
            alert("Acceptance details not successfully sent");
            window.location="adminhomepage.html";
        </script>
        <%
    }

} catch (Exception ex) {
    ex.printStackTrace();
}
%>
</body>
</html>
