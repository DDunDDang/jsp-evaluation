<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>강의평가 웹 사이트</title>
</head>
<body>
    <%
        session.invalidate();
    %>
    <script>
        alert('로그아웃 되었습니다.')
        location.href='index.jsp'
    </script>
</body>
</html>
