<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
</head>
<body>
	<%@include file="/WEB-INF/views/common/header.jsp" %>
	
	<span>나의 YAMI</span>
	
	<div>
		<span>사용자 설정</span>
		<button type="button" id="update">계정 및 개인정보</button>
		<div>
			<button type="button" id="myaccount">나의 계정</button>
			<button type="button" id="myinfo">나의 정보</button>
		</div>
		
		<button type="button" id="block">차단 관리</button>
		<button type="button" id="location">위치 설정</button>
	</div>
	
	<div>
		<span>나의 활동</span>
		<button type="button" id="boared">내가 쓴 게시글</button>
		<button type="button" id="reply">내가 쓴 댓글</button>
	</div>
	
	<script type="text/javascript">
		document.getElementById("update").addEventListener('click', function(){
			location.href("${root}/")
		});
	</script>
</body>
</html>