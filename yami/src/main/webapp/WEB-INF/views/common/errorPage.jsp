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
	<script>
		var msg="${errorMsg}";
		
		if(msg!="") {
			alert(msg);
		}
	</script>
	<c:remove var="errorMsg"/>
    <br>
    <div align="center">
        <h1 style="font-weight:bold;color:gray;">흠... 다시 해 봅시다...</h1>
        <img src="https://cdn.pixabay.com/photo/2016/09/14/16/44/emoticon-1669804_640.png">
        <br><br>
    </div>
    <br>
</body>
</html>