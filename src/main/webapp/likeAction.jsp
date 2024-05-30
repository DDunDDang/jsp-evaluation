<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="evaluation.EvaluationDAO" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="likey.LikeyDAO" %>
<% request.setCharacterEncoding("UTF-8"); %>
<%!
    public static String getClientIP(HttpServletRequest request) {
        String ip = request.getHeader("X-FORWARDED-FOR");
        if (ip == null || ip.length() == 0) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }
%>
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
        String evaluationID = null;
        if (request.getParameter("evaluationID") != null) {
            evaluationID = request.getParameter("evaluationID");
        }
        EvaluationDAO evaluationDAO = new EvaluationDAO();
        LikeyDAO likeyDAO = new LikeyDAO();
        int result = likeyDAO.like(userID, evaluationID, getClientIP(request));
        if (result == 1) {
            result = evaluationDAO.like(evaluationID);
            if (result == 1) {
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('추천이 완료되었습니다.')");
                script.println("location.href='index.jsp'");
                script.println("</script>");
                script.close();
            } else {
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('데이터베이스 오류가 발생했습니다.')");
                script.println("history.back()");
                script.println("</script>");
                script.close();
            }
        } else {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('이미 추천을 누른 글 입니다.')");
            script.println("history.back()");
            script.println("</script>");
            script.close();
        };

    %>
</body>
</html>
