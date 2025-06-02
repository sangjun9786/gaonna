<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>운영실</title>
</head>
<body>
	<%@include file="/WEB-INF/views/common/header.jsp"%>
	
	<c:if test="${loginUser.roleType == 'superAdmin'}">
		<div>
			관리자 관리
			<a href="${root}/updateAdmin.ad">관리자 조회/수정</a>
			<a href="${root}/insertAdmin.ad">관리자 추가</a>
		</div>
	</c:if>
	
	<div>
		회원 관리
		<c:choose>
			<c:when test="${loginUser.roleType!='viewer'}">
				<a href="${root}/updateUser.ad">회원 조회/수정</a>
			</c:when>
			<c:otherwise>
				<a href="${root}/updateUser.ad">회원 조회</a>
			</c:otherwise>
		</c:choose>
	</div>
</body>
</html>