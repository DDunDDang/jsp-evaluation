<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="userDTO" class="user.UserDTO" scope="page" />
<jsp:setProperty name="userDTO" property="userID" />
<jsp:setProperty name="userDTO" property="userPassword" />
<html>
<head>
    <title>강의평가 웹 사이트</title>
    <%
        if (session.getAttribute("userID") != null) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('이미 로그인이 되어 있습니다.')");
            script.println("history.back()");
            script.println("</script>");
            script.close();
        }
        UserDAO userDAO = new UserDAO();
        int result = userDAO.login(userDTO.getUserID(), userDTO.getUserPassword());
        if (result == 0) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('비밀번호가 일치하지 않습니다.')");
            script.println("history.back()");
            script.println("</script>");
            script.close();
        } else if (result == -1) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('존재하지 않는 아이디 입니다.')");
            script.println("history.back()");
            script.println("</script>");
            script.close();
        } else if (result == -2) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('데이터베이스 오류가 발생했습니다.')");
            script.println("</script>");
            script.close();
        } else {
            session.setAttribute("userID", userDTO.getUserID());
            if (userDAO.getUserEmailChecked(userDTO.getUserID())) {
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("location.href='index.jsp'");
                script.println("</script>");
                script.close();
            } else {
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('메일 인증이 되지 않았습니다. 이메일 인증 페이지로 이동합니다.')");
                script.println("location.href='emailSendAction.jsp'");
                script.println("</script>");
                script.close();
            }
        }
    %>
</head>
<body>

</body>
</html>
