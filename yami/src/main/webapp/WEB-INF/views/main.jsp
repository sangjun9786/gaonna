<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<link href="${pageContext.request.contextPath}/webjars/bootstrap/5.3.5/css/bootstrap.min.css" rel="stylesheet">
	<script src="${pageContext.request.contextPath}/webjars/bootstrap/5.3.5/js/bootstrap.bundle.min.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
	
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
<c:set var="root" value="${pageContext.request.contextPath}"/>
<c:set var="loginUser" value="${sessionScope.loginUser}"/>

<div class="container min-vh-100 d-flex flex-column justify-content-center align-items-center">
  <!-- 중앙 검색창 -->
  <div class="w-100" style="max-width: 500px;">
    <form action="${root}/search" method="get" class="input-group mb-4">
      <input type="text" class="form-control form-control-lg" name="keyword" placeholder="검색어를 입력하세요" aria-label="Search">
      <button class="btn btn-primary btn-lg" type="submit">
        <i class="bi bi-search"></i>
      </button>
    </form>
  </div>


  <!-- 중앙 메뉴 영역: 로그인/회원가입 버튼만 표시 -->
<div class="center-menu d-flex justify-content-center mb-4">
  <ul class="navbar-nav d-flex flex-row align-items-center">
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
</div>


  <!-- 서비스 카드: 아이콘 + 링크 -->
  <div class="row row-cols-2 row-cols-md-4 g-3 mb-4 justify-content-center" style="max-width: 800px;">
    <div class="col">
      <a href="${root}/productList.pro" class="card text-center h-100 shadow-sm text-decoration-none">
        <div class="card-body">
            <i class="bi bi-bag fs-1 text-primary"></i>
            <h6 class="card-title mt-2 mb-0">Resell</h6>
        </div>
      </a>
    </div>
    <div class="col">
      <a href="#" class="text-decoration-none">
        <div class="card text-center h-100 shadow-sm">
          <div class="card-body">
            <i class="bi bi-geo-alt fs-1 text-success"></i>
            <h6 class="card-title mt-2 mb-0">Location</h6>
          </div>
        </div>
      </a>
    </div>
    <div class="col">
      <a href="#" class="text-decoration-none">
        <div class="card text-center h-100 shadow-sm">
          <div class="card-body">
            <i class="bi bi-star fs-1 text-warning"></i>
            <h6 class="card-title mt-2 mb-0">Recommend</h6>
          </div>
        </div>
      </a>
    </div>
    <div class="col">
      <a href="#" class="text-decoration-none">
        <div class="card text-center h-100 shadow-sm">
          <div class="card-body">
            <i class="bi bi-question-circle fs-1 text-info"></i>
            <h6 class="card-title mt-2 mb-0">QnA</h6>
          </div>
        </div>
      </a>
    </div>
    <div class="col">
      <a href="#" class="text-decoration-none">
        <div class="card text-center h-100 shadow-sm">
          <div class="card-body">
            <i class="bi bi-megaphone fs-1 text-danger"></i>
            <h6 class="card-title mt-2 mb-0">Notice</h6>
          </div>
        </div>
      </a>
    </div>
    <div class="col">
      <a href="${root}/event.ev" class="text-decoration-none">
        <div class="card text-center h-100 shadow-sm">
          <div class="card-body">
            <i class="bi bi-calendar-event fs-1 text-secondary"></i>
            <h6 class="card-title mt-2 mb-0">Event</h6>
          </div>
        </div>
      </a>
    </div>
    <div class="col">
      <a href="#" class="text-decoration-none">
        <div class="card text-center h-100 shadow-sm">
          <div class="card-body">
            <i class="bi bi-exclamation-triangle fs-1 text-warning"></i>
            <h6 class="card-title mt-2 mb-0">Report</h6>
          </div>
        </div>
      </a>
    </div>
  </div>
</div>

<hr>
<a href="${root}/lab">실험실</a>








<script>
	let msg="${alertMsg}";
	if(msg!="") {
		alert(msg);
	}
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
