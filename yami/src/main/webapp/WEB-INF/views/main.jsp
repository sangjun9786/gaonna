<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8"/>
    <title>YAMI</title>
  </head>
  <body>
  <%@include file="/WEB-INF/views/common/header.jsp" %>
	<c:choose>
		<c:when test="${empty sessionScope.loginUser}">
			<a href="${pageScope.root}/insert.me">회원가입</a>
			<br>
			<a href="${pageScope.root}/login.me">로그인</a>
		</c:when>
		<c:otherwise>
			${sessionScope.loginUser.userName}님 안녕하세요
			<br>
			<a href="${pageScope.root}/mypage.me">마이페이지</a>
			<c:if test="${pageScope.loginUser.roleType != 'N'}">
				<br>
				<a href="${pageScope.root}/adminpage.ad">운영실</a>
			</c:if>
			<a href="${pageScope.root}/logout.me">로그아웃</a>
		</c:otherwise>
	</c:choose>
	
	<hr>
	<a href="${root}/lab">실험실</a>
	
  </body>
</html>
