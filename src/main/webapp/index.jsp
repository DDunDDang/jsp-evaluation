<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="evaluation.EvaluationDTO" %>
<%@ page import="evaluation.EvaluationDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
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
    <%
        String userID = null;
        if (session.getAttribute("userID") != null) {
            userID = (String) session.getAttribute("userID");
        }
        String lectureDivide = "전체";
        if (request.getParameter("lectureDivide") != null) {
            lectureDivide = request.getParameter("lectureDivide");
        }
        String searchType = "최신순";
        if (request.getParameter("searchType") != null) {
            searchType = request.getParameter("searchType");
        }
        String search = "";
        if (request.getParameter("search") != null) {
            search = request.getParameter("search");
        }
        int pageNumber = 1;
        if (request.getParameter("pageNumber") != null) {
            try {
                pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
            } catch (Exception e) {
                System.out.println("검색 페이지 번호 오류");
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('올바르지 않은 페이지 번호입니다.')");
                script.println("history.back();");
                script.println("</script>");
            }
        }
    %>
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
                        <%
                            if (userID == null) {
                        %>
                        <a class="dropdown-item" href="userLogin.jsp">로그인</a>
                        <a class="dropdown-item" href="userJoin.jsp">회원가입</a>
                        <%
                            } else {
                        %>
                        <a class="dropdown-item" href="userLogout.jsp">로그아웃</a>
                        <%
                            }
                        %>
                    </div>
                </li>
            </ul>
            <form action="./index.jsp" method="get" class="form-inline my-2 my-lg-0">
                <input class="form-control mr-sm-2" type="text" name="search" placeholder="내용을 입력하세요." aria-label="Search">
                <button class="btn btn-outline-success my-2 my-sm-0" type="submit">검색</button>
            </form>
        </div>
    </nav>
    <section class="container">
        <form method="get" action="./index.jsp" class="form-inline mt-3">
            <select name="lectureDivide" class="form-control mx-1 mt-2">
                <option value="전체">전체</option>
                <option value="전공" <% if (lectureDivide.equals("전공")) out.println("selected"); %>>전공</option>
                <option value="교양" <% if (lectureDivide.equals("교양")) out.println("selected"); %>>교양</option>
                <option value="기타" <% if (lectureDivide.equals("기타")) out.println("selected"); %>>기타</option>
            </select>
            <select name="searchType" class="form-control mx-1 mt-2">
                <option value="최신순" <% if (searchType.equals("최신순")) out.println("selected"); %>>최신순</option>
                <option value="추천순" <% if (searchType.equals("추천순")) out.println("selected"); %>>추천순</option>
            </select>
            <input type="text" name="search" class="form-control mx-1 mt-2" placeholder="내용을 입력하세요.">
            <button type="submit" class="btn btn-primary mx-1 mt-2">검색</button>
            <a class="btn btn-primary mx-1 mt-2" data-toggle="modal" href="#registerModal">등록하기</a>
            <a class="btn btn-danger mx-1 mt-2" data-toggle="modal" href="#reportModal">신고</a>
        </form>
        <%
            List<EvaluationDTO> list = new EvaluationDAO().getList(lectureDivide, searchType, search, pageNumber - 1);

            for (int i = 0; i < list.size(); i++) {
                if (i == 5) break;
        %>
        <div class="card bg-light mt-3">
            <div class="card-header bg-light">
                <div class="row">
                    <div class="col-8 text-left"><%= list.get(i).getLectureName() %>&nbsp;<small><%= list.get(i).getUserID() %></small></div>
                    <div class="col-4 text-right">
                        종합 <span style="color: red"><%= list.get(i).getTotalScore() %></span>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <h5 class="card-title">
                    <%= list.get(i).getEvaluationTitle() %>&nbsp;<small>(<%= list.get(i).getLectureYear() %>년 <%= list.get(i).getSemesterDivide()%>)</small>
                </h5>
                <p class="card-text"><%= list.get(i).getEvaluationContent() %></p>
                <div class="row">
                    <div class="col-9 text-left">
                        성적 <span style="color: red;"><%= list.get(i).getTotalScore() %></span>
                        과제 <span style="color: red;"><%= list.get(i).getAssignmentScore() %></span>
                        강의 <span style="color: red;"><%= list.get(i).getLectureScore() %></span>
                        <span style="color: green;">(추천 <%= list.get(i).getLikeCount() %>)</span>
                    </div>
                    <div class="col-3 text-right">
                        <a onclick="return confirm('추천하시겠습니까?')" href="./likeAction.jsp?evaluationID=<%= list.get(i).getEvaluationID() %>">추천</a>
                        <a onclick="return confirm('삭제하시겠습니까?')" href="./deleteAction.jsp?evaluationID=<%= list.get(i).getEvaluationID() %>">삭제</a>
                    </div>
                </div>
            </div>
        </div>
        <%
            }
        %>
    </section>
    <ul class="pagination justify-content-center mt-3">
        <li class="page-item">
            <%
                if (pageNumber <= 1) {
            %>
            <a class="page-link disabled">이전</a>
            <%
                } else {
            %>
            <a class="page-link" href="./index.jsp?lectureDivide=<%= URLEncoder.encode(lectureDivide, "UTF-8") %>&searchType=<%= URLEncoder.encode(searchType, "UTF-8") %>&search=<%= URLEncoder.encode(search, "UTF-8") %>&pageNumber=<%= pageNumber - 1 %>">이전</a>
            <%
                }
            %>
        </li>
        <li class="page-item">
            <%
                if (list.size() <= 5) {
            %>
            <a class="page-link disabled">다음</a>
            <%
            } else {
            %>
            <a class="page-link" href="./index.jsp?lectureDivide=<%= URLEncoder.encode(lectureDivide, "UTF-8") %>&searchType=<%= URLEncoder.encode(searchType, "UTF-8") %>&search=<%= URLEncoder.encode(search, "UTF-8") %>&pageNumber=<%= pageNumber + 1 %>">다음</a>
            <%
                }
            %>
        </li>
    </ul>
    <div class="modal fade" id="registerModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modal">평가 등록</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form action="./evaluationRegisterAction.jsp" method="post">
                        <div class="form-row">
                            <div class="form-group col-sm-6">
                                <label>강의명</label>
                                <input type="text" name="lectureName" class="form-control" maxlength="20">
                            </div>
                            <div class="form-group col-sm-6">
                                <label>교수명</label>
                                <input type="text" name="professorName" class="form-control" maxlength="20">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-sm-4">
                                <label>수강 연도</label>
                                <select name="lectureYear" class="form-control">
                                    <option value="2011">2011</option>
                                    <option value="2012">2012</option>
                                    <option value="2013">2013</option>
                                    <option value="2014">2014</option>
                                    <option value="2015">2015</option>
                                    <option value="2016">2016</option>
                                    <option value="2017">2017</option>
                                    <option value="2018">2018</option>
                                    <option value="2019">2019</option>
                                    <option value="2020">2020</option>
                                    <option value="2021">2021</option>
                                    <option value="2022">2022</option>
                                    <option value="2023">2023</option>
                                    <option value="2024" selected>2024</option>
                                </select>
                            </div>
                            <div class="form-group col-sm-4">
                                <label>수강 학기</label>
                                <select name="semesterDivide" class="form-control">
                                    <option value="1학기" selected>1학기</option>
                                    <option value="여름계절학기">여름계절학기</option>
                                    <option value="2학기">2학기</option>
                                    <option value="겨울계절학기">겨울계절학기</option>
                                </select>
                            </div>
                            <div class="form-group col-sm-4">
                                <label>강의 구분</label>
                                <select name="lectureDivide" class="form-control">
                                    <option value="전공" selected>전공</option>
                                    <option value="교양">교양</option>
                                    <option value="기타">기타</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>제목</label>
                            <input type="text" name="evaluationTitle" class="form-control" maxlength="30">
                        </div>
                        <div class="form-group">
                            <label>내용</label>
                            <textarea name="evaluationContent" class="form-control" maxlength="2048" style="height: 180px"></textarea>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-sm-3">
                                <label>종합</label>
                                <select name="totalScore" class="form-control">
                                    <option value="A" selected>A</option>
                                    <option value="B">B</option>
                                    <option value="C">C</option>
                                    <option value="D">D</option>
                                    <option value="F">F</option>
                                </select>
                            </div>
                            <div class="form-group col-sm-3">
                                <label>성적</label>
                                <select name="gradeScore" class="form-control">
                                    <option value="A" selected>A</option>
                                    <option value="B">B</option>
                                    <option value="C">C</option>
                                    <option value="D">D</option>
                                    <option value="F">F</option>
                                </select>
                            </div>
                            <div class="form-group col-sm-3">
                                <label>과제</label>
                                <select name="assignmentScore" class="form-control">
                                    <option value="A" selected>A</option>
                                    <option value="B">B</option>
                                    <option value="C">C</option>
                                    <option value="D">D</option>
                                    <option value="F">F</option>
                                </select>
                            </div>
                            <div class="form-group col-sm-3">
                                <label>강의</label>
                                <select name="lectureScore" class="form-control">
                                    <option value="A" selected>A</option>
                                    <option value="B">B</option>
                                    <option value="C">C</option>
                                    <option value="D">D</option>
                                    <option value="F">F</option>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
                            <button type="submit" class="btn btn-primary">등록하기</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="reportModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modal">신고하기</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form action="./reportAction.jsp" method="post">
                        <div class="form-group">
                            <label>신고 제목</label>
                            <input type="text" name="reportTitle" class="form-control" maxlength="30">
                        </div>
                        <div class="form-group">
                            <label>신고 내용</label>
                            <textarea name="reportContent" class="form-control" maxlength="2048" style="height: 180px"></textarea>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
                            <button type="submit" class="btn btn-danger">신고하기</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
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
