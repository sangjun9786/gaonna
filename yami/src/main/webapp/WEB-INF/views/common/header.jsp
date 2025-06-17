<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <link href="${pageContext.request.contextPath}/webjars/bootstrap/5.3.5/css/bootstrap.min.css" rel="stylesheet">
    <script src="${pageContext.request.contextPath}/webjars/bootstrap/5.3.5/js/bootstrap.bundle.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <meta charset="UTF-8">
    <title>헤더</title>
    <style>
        .custom-navbar {
            padding: 30px 0;
            background-color: #f8f9fa;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
        }
        .custom-navbar .navbar-brand {
            font-size: 50px;
            font-weight: bold;
            color: #FF0000;
            text-shadow:
                -1px -1px 0 #FFD700,
                1px -1px 0 #FFD700,
                -1px  1px 0 #FFD700,
                1px  1px 0 #FFD700;
            cursor: pointer;
        }
        .custom-navbar .navbar-brand:hover {
            color: #FF0000 !important;
            text-shadow:
                -1px -1px 0 #FF5733,
                1px -1px 0 #FF5733,
                -1px  1px 0 #FF5733,
                1px  1px 0 #FF5733 !important;
            background-color: transparent !important;
            text-decoration: none !important;
            cursor: pointer;
        }
        .custom-navbar .navbar-nav .nav-link {
            font-size: 18px;
            padding: 8px 16px;
        }
        .custom-navbar .center-menu {
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
        }
        .custom-navbar .right-menu {
            margin-left: auto;
        }
        /* 알림 종 + 뱃지 + 드롭다운 */
        .alarm-bell-btn { cursor:pointer; position:relative; }
        .alarm-bell-btn svg { vertical-align:middle; }
        .alarm-count-badge {
            position: absolute;
            top: 0;
            right: 0;
            transform: translate(40%, -30%);
            font-size: 13px;
            display: none;
        }
        .alarm-dropdown {
            position: absolute;
            right: 0;
            top: 45px;
            min-width: 260px;
            max-width: 400px;
            background: #fff;
            border: 1px solid #eee;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            padding: 7px 0;
            display: none;
            z-index: 2222;
        }
    </style>
</head>
<body>
<c:set var="root" value="${pageContext.request.contextPath}"/>
<c:set var="loginUser" value="${sessionScope.loginUser}"/>

<c:if test="${not empty alertMsg}">
<script>
    var msg="${alertMsg}";
    if(msg!="") { alert(msg); }
</script>
<c:remove var="alertMsg"/>
	</c:if>
<nav class="navbar navbar-expand-lg custom-navbar position-relative">
  <div class="container-fluid">

    <!-- 왼쪽: 야미 파비콘  -->
    <a class="navbar-brand" href="${root}/index.jsp">
        <img src="${pageContext.request.contextPath}/resources/img/야미콘.png" alt="favicon" width="45" height="45">
        Yami
    </a>

    <!-- 가운데: 메뉴 항목들 중앙 정렬 각 기능 링크 넣기 필요-->
    <div class="center-menu">
      <ul class="navbar-nav mb-2 mb-lg-0 d-flex flex-row">
        <li class="nav-item">
          <a class="nav-link" href="${root }/filter.bo">Resell</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${root}/dongneMain.dn">Location</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${root }/recommend.bo">Recommend</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${root }/doTest.me">Purchase</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/notice/list">Notice</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${root }/event.ev">Event</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#">Report</a>
        </li>
      </ul>
    </div>

    <!-- 오른쪽: 로그인/회원가입 메뉴 -->
    <div class="right-menu text-end" style="position:relative;">
      <ul class="navbar-nav fs-6 d-flex flex-row align-items-center">
        <c:choose>
          <c:when test="${empty loginUser}">
            <li class="nav-item">
              <a class="nav-link" href="${root}/login.me">Login</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="${root}/insert.me">Sign up</a>
            </li>
          </c:when>
          <c:otherwise>
            <li class="nav-item">
              <a class="nav-link" href="${root}/mypage.me">My Page</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="${root}/logout.me">Log out</a>
            </li>
            <c:if test="${loginUser.roleType != 'N'}">
              <li class="nav-item">
                <a class="nav-link" href="${root}/adminPage.ad">운영실</a>
              </li>
            </c:if>
            <!-- 알림 종 -->
            <li class="nav-item position-relative ms-3">
			  <a href="${pageContext.request.contextPath}/alarm/alarmPage" class="nav-link alarm-bell-btn" id="alarmBellBtn" style="padding:0 10px;">
			    <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" fill="none" viewBox="0 0 24 24">
			      <path d="M12 22a2 2 0 0 0 2-2H10a2 2 0 0 0 2 2zm6-6V11a6 6 0 0 0-5-5.92V4a1 1 0 1 0-2 0v1.08A6 6 0 0 0 6 11v5l-1.29 1.29A1 1 0 0 0 6 19h12a1 1 0 0 0 .71-1.71L18 17z" fill="#FFB700"/>
			    </svg>
			    <span id="alarmCount" class="alarm-count-badge badge rounded-pill bg-danger">0</span>
			  </a>
			</li>
          </c:otherwise>
        </c:choose>
      </ul>
      <!-- 인사 메시지 -->
      <c:if test="${not empty loginUser}">
        <div class="mt-1 small text-muted">
          ${loginUser.userName}님 안녕하세요
        </div>
        <div class="mt-1 small text-muted">
        	보유 포인트: <span class="fw-bold">${loginUser.point}</span>P
    	</div>
      </c:if>
    </div>
  </div>
</nav>
<script>
<c:if test="${not empty loginUser}">
function fetchAlarmCount() {
    $.get("${pageContext.request.contextPath}/alarm/count", function(count) {
        if(count > 0) {
            $("#alarmCount").text(count).show();
        } else {
            $("#alarmCount").hide();
        }
    });
}
$(document).ready(function(){
    fetchAlarmCount();
    setInterval(fetchAlarmCount, 500);
});
</c:if>
</script>
</body>
</html>
