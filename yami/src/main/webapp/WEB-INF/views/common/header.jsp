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
</head>
<body>
	<c:set var="root" value="${pageContext.request.contextPath}"/>
	<c:set var="loginUser" value="${sessionScope.loginUser}"/>
	
	<script>
		let msg = "${alertMsg}"
		if(msg!=""){
			alert(msg);
		}
	</script>
	<c:remove var="alertMsg"/>
	
	<a href="${pageScope.root }">메인화면</a>
	
	<br>
	
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
	 
</body>
</html>