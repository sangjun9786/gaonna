<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8"/>
	<title>YAMI</title>
	<style>
	#consoleOverlay {
		display: none;
		position: fixed;
		z-index: 9999;
		top: 0; left: 0; width: 100vw; height: 100vh;
		background: rgba(0,0,0,0.7);
	}
	#consoleBox {
		position: absolute;
		top: 50%; left: 50%;
		transform: translate(-50%, -50%);
		background: #222;
		color: #fff;
		border-radius: 10px;
		padding: 2rem 2.5rem;
		min-width: 320px;
		box-shadow: 0 0 30px #000;
	}
	#consoleInput {
		background: #111;
		color: #fff;
		border: 1px solid #555;
	}
</style>
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
		<c:if test="${sessionScope.loginUser.roleType != 'N'}">
			<br>
			<a href="${pageScope.root}/adminPage.ad">운영실</a>
		</c:if>
		<a href="${pageScope.root}/logout.me">로그아웃</a>
	</c:otherwise>
</c:choose>

<hr>
<a href="${root}/lab">실험실</a>











<script type="text/javascript">


</script>




<%---------------콘솔 나와바리--------------------%>

<!-- 콘솔 오버레이 -->
<div id="consoleOverlay">
	<form id="consoleForm" method="post" action="${root}/console" autocomplete="off">
		<div id="consoleBox" class="shadow-lg">
			<div class="mb-3">
				<label for="consoleInput" class="form-label">관리자 콘솔</label>
				<input type="text" id="consoleInput" name="command" class="form-control" placeholder="명령어를 입력하세요" autofocus />
			</div>
			<div class="text-muted small">sda: superAdmin, ad: admin, vw: viewer로 로그인</div>
		</div>
	</form>
</div>
<script>
//콘솔 입력창
document.addEventListener('keydown', function(e) {
    // 입력창 포커스 시 무시
    if (document.activeElement.tagName === 'INPUT' || document.activeElement.tagName === 'TEXTAREA') return;
    
    // / 키 입력 + 오버레이가 닫혀 있을 때만 실행
    if (e.key === '/' && document.getElementById('consoleOverlay').style.display !== 'block') {
        e.preventDefault();
        showConsole();
    }
});


// 콘솔 오버레이 표시 함수
function showConsole() {
	const overlay = document.getElementById('consoleOverlay');
	overlay.style.display = 'block';
	
	setTimeout(() => {
		document.getElementById('consoleInput').focus();
	}, 50);
}

// ESC 누르면 콘솔닫기
document.addEventListener('keydown', function(e) {
	if (document.getElementById('consoleOverlay').style.display === 'block' && e.key === 'Escape') {
		hideConsole();
	}
});
// 콘솔 바깥쪽 누르면 콘솔닫기
document.getElementById('consoleOverlay').addEventListener('mousedown', function(e) {
	if (e.target === this) hideConsole();
});
function hideConsole() {
	document.getElementById('consoleOverlay').style.display = 'none';
	document.getElementById('consoleInput').value = '';
}

// 콘솔 명령어 처리
document.getElementById('consoleForm').addEventListener('submit', function(e) {
    e.preventDefault();
    this.submit();
    hideConsole();
});
</script>
</body>
</html>
