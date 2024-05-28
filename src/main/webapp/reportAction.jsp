<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.Properties" %>
<%@ page import="javax.mail.Authenticator" %>
<%@ page import="util.Gmail" %>
<%@ page import="util.EmailSender" %>
<%@ page import="java.util.concurrent.Executors" %>
<%@ page import="java.util.concurrent.ExecutorService" %>
<% request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
    <title>Title</title>
</head>
<body>
    <%
        String userID = null;
        if (session.getAttribute("userID") == null) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('로그인 후 이용 가능합니다.')");
            script.println("location.href='userLogin.jsp'");
            script.println("</script>");
            script.close();
        } else {
            userID = (String) session.getAttribute("userID");
        }
        String reportTitle = null;
        if (request.getParameter("reportTitle") != null) {
            reportTitle = request.getParameter("reportTitle");
        }
        String reportContent = null;
        if (request.getParameter("reportContent") != null) {
            reportContent = request.getParameter("reportContent");
        }


        if (reportTitle == null || reportContent == null) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('입력 안된 항목이 존재합니다.')");
            script.println("history.back()");
            script.println("</script>");
            script.close();
        }

        String from = "thdwns0331@gmail.com";
        String to = "thdwns0331@gmail.com";
        String subject = "강의평가 웹 사이트에서 접수된 신고 메일입니다.";
        String content = "신고자: " + userID +
                "<br>제목: " + reportTitle +
                "<br>내용: " + reportContent;

        Properties p = new Properties();
        p.put("mail.smtp.user", from);
        p.put("mail.smtp.host", "smtp.googlemail.com");
        p.put("mail.smtp.port", 465);
        p.put("mail.smtp.starttls.enable", "true");
        p.put("mail.smtp.auth", "true");
        p.put("mail.smtp.debug", "true");
        p.put("mail.smtp.socketFactory.port", "465");
        p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        p.put("mail.smtp.socketFactory.fallback", "false");

        try {
            Authenticator auth = new Gmail();
            EmailSender emailSender = new EmailSender(from, to, subject, content, p, auth);
            ExecutorService executorService = Executors.newSingleThreadExecutor();
            executorService.submit(emailSender);
            executorService.shutdown();
        } catch (Exception e) {
            e.printStackTrace();
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('오류가 발생했습니다.')");
            script.println("history.back()");
            script.println("</script>");
            script.close();
            return;
        }
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('정상적으로 신고되었습니다.')");
        script.println("history.back()");
        script.println("</script>");
        script.close();
    %>
</body>
</html>
