<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<link
	href="${pageContext.request.contextPath}/webjars/bootstrap/5.3.5/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="${pageContext.request.contextPath}/webjars/bootstrap/5.3.5/js/bootstrap.bundle.min.js"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<meta charset="UTF-8" />
<title>YAMI</title>
<style>
#consoleOverlay {
	display: none;
	position: fixed;
	z-index: 9999;
	top: 0;
	left: 0;
	width: 100vw;
	height: 100vh;
	background: rgba(0, 0, 0, 0.7);
}

#consoleBox {
	position: absolute;
	top: 50%;
	left: 50%;
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

#user-menu {
	background: #f8f9fa;
	border-radius: 1rem;
	padding: 1.2rem 2rem;
	box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
	display: flex;
	flex-direction: column;
	align-items: center;
	margin-bottom: 2rem;
}

#user-name-label {
	font-weight: 600;
	font-size: 1.1rem;
	margin-bottom: 0.7rem;
	color: #444;
	letter-spacing: 0.01em;
	text-align: center;
}

.user-menu-links {
	display: flex;
	flex-direction: row;
	gap: 5rem;
	justify-content: center;
	align-items: center;
}

.user-menu-link {
	position: relative;
	display: flex;
	flex-direction: column;
	align-items: center;
	color: #333;
	text-decoration: none;
	font-size: 1.8rem;
	transition: color 0.2s;
}

.user-menu-link .menu-label {
	opacity: 0;
	position: absolute;
	top: 120%;
	left: 50%;
	transform: translateX(-50%);
	background: #222;
	color: #fff;
	padding: 0.25em 0.8em;
	border-radius: 0.5em;
	font-size: 1rem;
	white-space: nowrap;
	pointer-events: none;
	transition: opacity 0.2s;
	z-index: 10;
}

.user-menu-link:hover, .user-menu-link:focus {
	color: #0d6efd;
}

.user-menu-link:hover .menu-label, .user-menu-link:focus .menu-label {
	opacity: 1;
}
.disabled-location-card {
    pointer-events: auto !important;
}
.disabled-location-card .card {
    background-color: #e9ecef !important;
    opacity: 0.85;
}
.disabled-location-card .card-body {
    cursor: pointer;
}

.select {
	margin-right: 10px;
	margin-top: 15px;
}
</style>
</head>
<body>
	<c:set var="root" value="${pageContext.request.contextPath}" />
	<c:set var="loginUser" value="${sessionScope.loginUser}" />

	<div
		class="container min-vh-100 d-flex flex-column justify-content-center align-items-center">

		<div class="container" style="max-width: 700px;">
			<div class="row align-items-center mb-4">
				<!-- 로고 영역 -->
				<div class="col-auto pe-0">
					<img src="${root}/resources/img/yami-logo.png" alt="YAMI!"
						style="height: 200px; width: auto; display: block;" />
				</div>
				<!-- 검색창 영역: 남은 공간 모두 차지 -->
				<div class="col ps-2">
					<div class="input-group">
						<div class="select">
		                    <select class="form-select form-select-lg mb-3" id="condition">
		                        <option value="resell">Resell</option>
		                        <option value="location">Location</option>
		                        <option value="notice">Notice</option>
		                        <option value="qna">QnA</option>
		                        <option value="report">Report</option>
		                    </select>
		                </div>
						<input type="text" class="form-control form-control-lg"
							id="keyword" placeholder="제목 또는 내용으로 검색" aria-label="Search">
						<button class="btn btn-primary btn-lg" type="submit" id="searchBtn">
							<i class="bi bi-search"></i>
						</button>
					</div>
				</div>
				
				<script>
				    $(function () {
				        $('#searchBtn').on('click', function () {
				            let condition = $('#condition').val();
				            let keyword = $('#keyword').val();
				            let encodedKeyword = encodeURIComponent(keyword);
				            
				            if (condition == 'resell') {
					            $.ajax({
					                type: 'POST', // 데이터를 전송하므로 POST 방식 사용
					                url: 'saveKeyword', // 세션 저장을 처리할 서버의 URL
					                data: {
					                    keyword: keyword // 서버로 보낼 데이터. { key: value } 형태
					                },
					                success: function(response) {
					                    // 세션 저장이 성공하면 원래의 검색 로직을 실행합니다.
					                    console.log('세션에 키워드 저장 성공:', response);
					                    
					                    // 2. 원래 의도했던 검색 기능 실행 (예: 검색 결과 페이지로 이동)
					                    location.href = '${root}/filter.bo';
					                },
					                error: function(xhr, status, error) {
					                    // 에러 처리
					                    console.error('세션 저장 실패:', error);
					                    alert('검색어 저장 중 오류가 발생했습니다.');
					                }
					            });
				            } else if (condition == 'location') {
				                url = '${root}/locationSearch?keyword=' + encodedKeyword;
				            } else if (condition == 'notice') {
				                url = '${root}/noticeSearch?keyword=' + encodedKeyword;
				            } else if (condition == 'qna') {
				                url = '${root}/qnaSearch?keyword=' + encodedKeyword;
				            } else if (condition == 'report') {
				                url = '${root}/reportSearch?keyword=' + encodedKeyword;
				            }
				        });
				    });
				</script>
				
			</div>
		</div>

		<!-- 서비스 카드: 아이콘 + 링크 (회원 카드 포함) -->
		<div
			class="row row-cols-2 row-cols-md-4 g-3 mb-4 justify-content-center"
			style="max-width: 800px;">
			<!-- 1행 -->
			<div class="col">
				<a href="${root}/productList2.pro"
					class="card text-center h-100 shadow-sm text-decoration-none">
					<div class="card-body">
						<i class="bi bi-bag fs-1 text-primary"></i>
						<h6 class="card-title mt-2 mb-0">Resell</h6>
					</div>
				</a>
			</div>
			<div class="col">
			    <c:choose>
			        <c:when test="${loginUser.mainCoord == 0}">
			            <a href="${root}/dongne.me" 
			               class="text-decoration-none disabled-location-card"
			               style="pointer-events:auto;">
			                <div class="card text-center h-100 shadow-sm bg-secondary bg-opacity-25"
			                     style="cursor:pointer;">
			                    <div class="card-body position-relative"
			                         data-bs-toggle="tooltip" 
			                         data-bs-placement="top" 
			                         title="먼저 대표동네를 설정해 주세요">
			                        <i class="bi bi-geo-alt fs-1 text-secondary"></i>
			                        <h6 class="card-title mt-2 mb-0 text-secondary">Location</h6>
			                    </div>
			                </div>
			            </a>
			        </c:when>
			        <c:otherwise>
			            <a href="${root}/dongneMain.dn" class="text-decoration-none">
			                <div class="card text-center h-100 shadow-sm">
			                    <div class="card-body">
			                        <i class="bi bi-geo-alt fs-1 text-success"></i>
			                        <h6 class="card-title mt-2 mb-0">Location</h6>
			                    </div>
			                </div>
			            </a>
			        </c:otherwise>
			    </c:choose>
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

			<!-- 회원 카드 -->
			<div class="col">
				<div class="card text-center h-100 shadow-sm bg-light">
					<div
						class="card-body d-flex flex-column justify-content-center align-items-center p-2">
						<c:choose>
							<c:when test="${empty loginUser}">
								<div class="user-menu-links d-flex gap-4 mb-2">
									<a class="user-menu-link" href="${root}/login.me" title="로그인">
										<i class="bi bi-box-arrow-in-right fs-3"></i> <span
										class="menu-label">로그인</span>
									</a> <a class="user-menu-link" href="${root}/insert.me"
										title="회원가입"> <i class="bi bi-person-plus fs-3"></i> <span
										class="menu-label">회원가입</span>
									</a>
								</div>
							</c:when>
							<c:otherwise>
								<div id="user-name-label" class="mb-2">${loginUser.userName}님</div>
								<div class="user-menu-links d-flex gap-4">
									<c:if test="${loginUser.roleType != 'N'}">
										<a class="user-menu-link" href="${root}/adminPage.ad"
											title="운영실"> <i class="bi bi-shield-lock fs-3"></i> <span
											class="menu-label">운영실</span>
										</a>
									</c:if>
									<a class="user-menu-link" href="${root}/mypage.me"
										title="마이페이지"> <i class="bi bi-person-gear fs-3"></i> <span
										class="menu-label">마이페이지</span>
									</a> <a class="user-menu-link" href="${root}/logout.me"
										title="로그아웃"> <i class="bi bi-box-arrow-right fs-3"></i> <span
										class="menu-label">로그아웃</span>
									</a>
								</div>
							</c:otherwise>
						</c:choose>
					</div>
				</div>
			</div>

			<!-- 2행 -->
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
							<i class="bi bi-megaphone fs-1 text-danger"></i>
							<h6 class="card-title mt-2 mb-0">Notice</h6>
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
							<i class="bi bi-exclamation-triangle fs-1 text-warning"></i>
							<h6 class="card-title mt-2 mb-0">Report</h6>
						</div>
					</div>
				</a>
			</div>
		</div>

		<hr>
		<a href="${root}/lab">실험실</a>







<script>
let msg="${alertMsg}";
if(msg!="") {
	alert(msg);
}

<%--location카드 이벤트 핸들러--%>
document.addEventListener('DOMContentLoaded', function () {
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.forEach(function (tooltipTriggerEl) {
        new bootstrap.Tooltip(tooltipTriggerEl);
    });
});

</script>
<c:remove var="alertMsg"/>

<%---------------콘솔 나와바리--------------------%>

<!-- 콘솔 오버레이 -->
<div id="consoleOverlay">
	<form id="consoleForm" method="post" action="${root}/console"
		autocomplete="off">
		<div id="consoleBox" class="shadow-lg">
			<div class="mb-3">
				<label for="consoleInput" class="form-label">관리자 콘솔</label> <input
					type="text" id="consoleInput" name="command" class="form-control"
					placeholder="명령어를 입력하세요" autofocus />
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
