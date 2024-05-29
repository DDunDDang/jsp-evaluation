<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="evaluation.EvaluationDAO" %>
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
        String evaluationID = null;
        if (request.getParameter("evaluationID") != null) {
            evaluationID = request.getParameter("evaluationID");
        }
        EvaluationDAO evaluationDAO = new EvaluationDAO();
        if (userID.equals(evaluationDAO.getUserID(evaluationID))) {
            int result = evaluationDAO.delete(evaluationID);
            if (result == -1) {
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('데이터베이스 오류가 발생했습니다.')");
                script.println("history.back()");
                script.println("</script>");
                script.close();
            } else {
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('삭제가 완료되었습니다.')");
                script.println("location.href='index.jsp'");
                script.println("</script>");
                script.close();
            }
        } else {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('작성자만 삭제 가능합니다.')");
            script.println("history.back()");
            script.println("</script>");
            script.close();
        }

    %>
</body>
</html>
