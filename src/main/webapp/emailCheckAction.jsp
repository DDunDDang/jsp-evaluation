<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="user.UserDAO" %>
<%@ page import="util.SHA256" %>
<%@ page import="java.io.PrintWriter" %>

<%
    request.setCharacterEncoding("UTF-8");
    UserDAO userDAO = new UserDAO();
    String code = null;
    if (request.getParameter("code") != null) {
        code = request.getParameter("code");
    }
    String userID = null;
    if (session.getAttribute("userID") != null) {
        userID = (String)session.getAttribute("userID");
    }
    if (session.getAttribute("userID") == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인을 해 주세요.')");
        script.println("location.href = 'userLogin.jsp'");
        script.println("</script>");
    }

    String userEmail = userDAO.getUserEmail(userID);
    boolean isRight = SHA256.getSHA256(userEmail).equals(code);

    if (isRight) {
        userDAO.setUserEmailChecked(userID);
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('인증에 성공했습니다.')");
        script.println("location.href='index.jsp'");
        script.println("</script>");
    } else {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('유효하지 않은 코드입니다.')");
        script.println("location.href='index.jsp'");
        script.println("</script>");
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>강의평가 웹 사이트</title>
    <%-- 부트스트랩 CSS 추가하기 --%>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <%-- 커스텀 CSS 추가하기 --%>
    <link rel="stylesheet" href="./css/custom.css">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <a class="navbar-brand" href="index.jsp">강의평가 웹 사이트</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div id="navbar" class="collapse navbar-collapse">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item active">
                    <a class="nav-link" href="index.jsp">메인</a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" id="dropdown" data-toggle="dropdown">
                        회원 관리
                    </a>
                    <div class="dropdown-menu" aria-labelledby="dropdown">
                        <a class="dropdown-item" href="userLogin.jsp">로그인</a>
                        <a class="dropdown-item" href="userJoin.jsp">회원가입</a>
                        <a class="dropdown-item" href="userLogout.jsp">로그아웃</a>
                    </div>
                </li>
            </ul>
            <form class="form-inline my-2 my-lg-0">
                <input class="form-control mr-sm-2" type="search" placeholder="내용을 입력하세요." aria-label="Search">
                <button class="btn btn-outline-success my-2 my-sm-0" type="submit">검색</button>
            </form>
        </div>
    </nav>
    <section class="container mt-3" style="max-width: 560px">
    </section>
    <footer class="bg-dark mt-4 p-5 text-center" style="color: #FFFFFF">
        Copyright &copy; 푸터
    </footer>
    <%-- JQuery 추가하기 --%>
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.slim.min.js"></script>
    <%--  부트스트랩 추가하기  --%>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    <%--  popper 추가하기  --%>
    <script src="./js/popper.js"></script>
</body>
</html>

