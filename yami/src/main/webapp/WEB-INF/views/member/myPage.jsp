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
	
	<div class="container py-5">
		<div class="row justify-content-center">
			<div class="col-md-10 col-lg-8">
				<!-- 사용자 정보 헤더 -->
				<div class="text-center mb-4">
					<h2 class="text-primary fw-bold">${pageScope.loginUser.userName}님의 YAMI</h2>
					<p class="text-muted">YAMI!</p>
				</div>
				
				<!-- 사용자 설정 카드 -->
				<div class="card shadow-sm mb-4">
					<div class="card-header bg-primary text-white">
						<h4 class="mb-0">
							<i class="bi bi-gear me-2"></i>사용자 설정
						</h4>
					</div>
					<div class="card-body">
						<h5 class="card-title mb-3">계정 및 개인정보</h5>
						
						<div class="table-responsive">
							<table class="table table-borderless align-middle">
								<tbody>
									<tr>
										<td class="fw-bold text-primary" style="width: 25%;">
											<i class="bi bi-person-badge me-2"></i>아이디
										</td>
										<td class="border-start ps-3">${pageScope.loginUser.userId}</td>
									</tr>
									<tr>
										<td class="fw-bold text-primary">
											<i class="bi bi-person me-2"></i>이름
										</td>
										<td class="border-start ps-3">${pageScope.loginUser.userName}</td>
									</tr>
									<tr>
										<td class="fw-bold text-primary">
											<i class="bi bi-telephone me-2"></i>전화번호
										</td>
										<td class="border-start ps-3">
											<c:choose>
												<c:when test="${not empty pageScope.loginUser.phone}">
													${pageScope.loginUser.phone}
												</c:when> 
												<c:otherwise>
													<span class="text-danger">❌전화번호가 없어요</span>
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
									<tr>
										<td class="fw-bold text-primary">
											<i class="bi bi-calendar-check me-2"></i>가입일
										</td>
										<td class="border-start ps-3">
											<fmt:formatDate value="${pageScope.loginUser.enrollDate}" pattern="yyyy년 MM월 dd일"/>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						
						<div class="text-end mt-3">
							<a href='${root}/update.me' class="btn btn-outline-primary">
								<i class="bi bi-pencil-square me-1"></i>수정하기
							</a>
						</div>
					</div>
				</div>
				
				<!-- 나의 활동 카드 -->
				<div class="card shadow-sm mb-4">
					<div class="card-header bg-success text-white">
						<h4 class="mb-0">
							<i class="bi bi-activity me-2"></i>나의 활동
						</h4>
					</div>
					<div class="card-body">
						<div class="row g-3">
							<div class="col-md-4">
								<a href='${root}/boared.me' class="btn btn-outline-success w-100 d-flex align-items-center justify-content-center">
									<i class="bi bi-file-text me-2"></i>내가 쓴 게시글
								</a>
							</div>
							<div class="col-md-4">
								<a href='${root}/reply.me' class="btn btn-outline-success w-100 d-flex align-items-center justify-content-center">
									<i class="bi bi-chat-dots me-2"></i>내가 쓴 댓글
								</a>
							</div>
							<div class="col-md-4">
								<a href='${root}/block.me' class="btn btn-outline-success w-100 d-flex align-items-center justify-content-center">
									<i class="bi bi-shield-x me-2"></i>차단 관리
								</a>
							</div>
						</div>
					</div>
				</div>
				
				<!-- 위치 및 주소 카드 -->
				<div class="card shadow-sm">
					<div class="card-header bg-info text-white">
						<h4 class="mb-0">
							<i class="bi bi-geo-alt me-2"></i>위치 및 주소
						</h4>
					</div>
					<div class="card-body">
						<div class="row g-3">
							<div class="col-md-6">
								<a href='${root}/dongne.me' class="btn btn-outline-info w-100 d-flex align-items-center justify-content-center">
									<i class="bi bi-house-door me-2"></i>우리동네 설정
								</a>
							</div>
							<div class="col-md-6">
								<a href='${root}/deliveryAddress.me' class="btn btn-outline-info w-100 d-flex align-items-center justify-content-center">
									<i class="bi bi-truck me-2"></i>배송지 설정
								</a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
