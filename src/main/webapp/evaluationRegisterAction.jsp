<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="evaluation.EvaluationDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="evaluationDTO" class="evaluation.EvaluationDTO" scope="page" />
<jsp:setProperty name="evaluationDTO" property="lectureName" />
<jsp:setProperty name="evaluationDTO" property="professorName" />
<jsp:setProperty name="evaluationDTO" property="lectureYear" />
<jsp:setProperty name="evaluationDTO" property="semesterDivide" />
<jsp:setProperty name="evaluationDTO" property="lectureDivide" />
<jsp:setProperty name="evaluationDTO" property="evaluationTitle" />
<jsp:setProperty name="evaluationDTO" property="evaluationContent" />
<jsp:setProperty name="evaluationDTO" property="totalScore" />
<jsp:setProperty name="evaluationDTO" property="gradeScore" />
<jsp:setProperty name="evaluationDTO" property="assignmentScore" />
<jsp:setProperty name="evaluationDTO" property="lectureScore" />
<html>
<head>
    <title>Title</title>
</head>
<body>
    <%
        String userID;
        if (session.getAttribute("userID") == null) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('로그인 후 작성가능합니다.')");
            script.println("location.href='userLogin.jsp'");
            script.println("</script>");
            script.close();
        } else {
            userID = (String) session.getAttribute("userID");
            evaluationDTO.setUserID(userID);
        }
        if (evaluationDTO.getUserID() == null || evaluationDTO.getLectureName() == null || evaluationDTO.getProfessorName() == null
                || evaluationDTO.getEvaluationTitle() == null || evaluationDTO.getEvaluationContent() == null) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('입력안된 항목이 존재합니다.')");
            script.println("history.back()");
            script.println("</script>");
            script.close();
        } else {
            int result = new EvaluationDAO().write(evaluationDTO);
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
                script.println("alert('강의평가가 등록되었습니다.')");
                script.println("location.href='index.jsp'");
                script.println("</script>");
                script.close();
            }
        }
    %>
</body>
</html>
