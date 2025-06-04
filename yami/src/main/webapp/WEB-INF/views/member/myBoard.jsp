<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>나의 게시글</title>
</head>
<body>
	<%@include file="/WEB-INF/views/common/header.jsp" %>
	
	
	<div>
		작성한 게시글
	</div>
	<div>
		검색할 게시판
		<select name="searchType" required>
			<option value="all">전체 게시판</option>
			<option value="all">전체검색</option>
			<option value="all">전체검색</option>
			<option value="question">질문게시판</option>
			<option value="report">신고게시판</option>
		</select>
	</div>
	
	
</body>
</html>