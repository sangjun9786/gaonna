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
		    background-color: #f8f9fa; /* 밝은 회색 배경 */
		    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
  		}

		.custom-navbar .navbar-brand {
			font-size: 50px;
		    font-weight: bold;
		    color: #FF0000; /* 노랑-주황 사이 */
		    text-shadow:
		    -1px -1px 0 #FFD700,  /* 위왼쪽 붉은 그림자 */
		     1px -1px 0 #FFD700,  /* 위오른쪽 */
		    -1px  1px 0 #FFD700,  /* 아래왼쪽 */
		     1px  1px 0 #FFD700;  /* 아래오른쪽 */
		     cursor: pointer;
		}	
		
		.custom-navbar .navbar-brand:hover {
			  color: #FF0000 !important;      /* 기존 색 유지 */
			  text-shadow:
			    -1px -1px 0 #FF5733,
			     1px -1px 0 #FF5733,
			    -1px  1px 0 #FF5733,
			     1px  1px 0 #FF5733 !important;  /* 외곽선 유지 */
			  background-color: transparent !important;
			  text-decoration: none !important;
			  cursor: pointer;
		}

 		.custom-navbar .navbar-nav .nav-link {
			font-size: 18px;
			padding: 8px 16px;
	  	}

	  /* 메뉴 항목 중앙 정렬 */
		.custom-navbar .center-menu {
		    position: absolute;
		    left: 50%;
		    transform: translateX(-50%);
		}

  	/* 로그인 메뉴 우측 정렬 고정 */
		.custom-navbar .right-menu {
	    	margin-left: auto;
	  	}
    </style>
</head>

<body>

<c:set var="root" value="${pageContext.request.contextPath}"/>
<c:set var="loginUser" value="${sessionScope.loginUser}"/>
<script>
	  var msg="${alertMsg}";
			
	  if(msg!="") {
		alert(msg);
	  }
	</script>
	<c:remove var="alertMsg"/>
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
          <a class="nav-link" href="${root }/productList2.pro">Resell</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#">Location</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#">Recommend</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#">QnA</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#">Notice</a>
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
    <div class="right-menu text-end">
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
      </c:otherwise>
    </c:choose>
  </ul>

  <!-- 인사 메시지 -->
  <c:if test="${not empty loginUser}">
    <div class="mt-1 small text-muted">
      ${loginUser.userName}님 안녕하세요
    </div>
  </c:if>
    </div>

  </div>
</nav>
</body>
</html>