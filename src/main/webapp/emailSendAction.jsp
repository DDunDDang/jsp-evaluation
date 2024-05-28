<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="java.util.Properties" %>
<%@ page import="user.UserDAO" %>
<%@ page import="util.SHA256" %>
<%@ page import="util.Gmail" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="javax.mail.*" %>
<%@ page import="java.util.concurrent.ExecutorService" %>
<%@ page import="java.util.concurrent.Executors" %>
<%@ page import="util.EmailSender" %>
<%
    request.setCharacterEncoding("UTF-8");
    UserDAO userDAO = new UserDAO();
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
    boolean emailChecked = userDAO.getUserEmailChecked(userID);

    if (emailChecked) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('이미 인증된 회원입니다.')");
        script.println("location.href = 'index.jsp'");
        script.println("</script>");
        script.close();
        return;
    }

    String host = "http://localhost:8080/";
    String from = "thdwns0331@gmail.com";
    String to = userDAO.getUserEmail(userID);
    String subject = "강의평가를 위한 이메일 인증 메일입니다.";
    String content = "다음 링크에 접속하여 이메일 인증을 진행해주세요." +
        "<a href='" + host + "emailCheckAction.jsp?code=" + SHA256.getSHA256(to) + "'>이메일 인증하기</a>";

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
        <div class="alert alert-success mt-4" role="alert">
            이메일 주소 인증 메일이 전송되었습니다.<br>
            회원가입 시 입력했던 이메일에 들어가셔서 인증해주세요.
        </div>
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

