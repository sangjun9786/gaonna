<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>오류</title>
</head>
<body>
	<%@include file="header.jsp" %>
	<br>
	<h1>--------초!!!!비상!!!!!-----------</h1>
	<h3>너의 허접한 코딩 실력 때문에 <br>
		'${requestScope.errorMsg}'<br>
		오류가 발생했다!!!</h3>
	
		
    <br>
</body>
</html>