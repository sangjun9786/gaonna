<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://cdn.jsdelivr.net/npm/lodash@4.17.21/lodash.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
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
					<h2 class="text-secondary fw-bold">${pageScope.loginUser.userName}님의 YAMI</h2>
					<p class="text-muted" id="ratingArea">YAMI!</p>
				</div>
				
				<!-- 사용자 설정 카드 -->
				<div class="card shadow-sm mb-4">
					<div class="card-header bg-secondary text-white">
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
										<td class="fw-bold text-secondary" style="width: 25%;">
											<i class="bi bi-person-badge me-2"></i>아이디
										</td>
										<td class="border-start ps-3">${pageScope.loginUser.userId}</td>
									</tr>
									<tr>
										<td class="fw-bold text-secondary">
											<i class="bi bi-person me-2"></i>이름
										</td>
										<td class="border-start ps-3">${pageScope.loginUser.userName}</td>
									</tr>
									<tr>
										<td class="fw-bold text-secondary">
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
										<td class="fw-bold text-secondary">
											<i class="bi bi-calendar-check me-2"></i>가입일
										</td>
										<td class="border-start ps-3">
											<fmt:formatDate value="${pageScope.loginUser.enrollDate}" pattern="yyyy년 MM월 dd일"/>
										</td>
									</tr>
									<tr>
										<td class="fw-bold text-secondary">
											<i class="bi bi-point me-2"></i>포인트
										</td>
										<td class="border-start ps-3">${pageScope.loginUser.point}</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="text-end mt-3">
						    <button type="button" class="btn btn-outline-secondary" 
						      id="editTriggerBtn">
						        <i class="bi bi-pencil-square me-1"></i>수정하기
						    </button>
					    
						    <!-- 숨겨진 비밀번호 확인 영역 -->
						    <div id="passwordSection" class="mt-3 d-none">
						        <div class="card border-secondary">
						            <div class="card-body">
						                <div class="row g-3 align-items-center">
						                    <div class="col-md-12">
						                        <input type="password" class="form-control" 
						                          id="inputPwd" name="inputPwd" 
						                          placeholder="비밀번호 확인">
						                        <div id="passwordFeedback" class="invalid-feedback"></div>
						                    </div>
						                </div>
						            </div>
						        </div>
						    </div>
						</div>
					</div>
				</div>
				
				<!-- 나의 활동 카드 -->
				<div class="card shadow-sm mb-4">
					<div class="card-header bg-primary text-white">
						<h4 class="mb-0">
							<i class="bi bi-activity me-2"></i>나의 활동
						</h4>
					</div>
					<div class="card-body">
					  <div class="row row-cols-2 g-3">
					    <div class="col">
					      <a href='${root}/wishlist.co' class="btn btn-outline-primary w-100 d-flex align-items-center justify-content-center">
					        <i class="bi bi-file-text me-2"></i>좋아요
					      </a>
					    </div>
					    <div class="col">
					      <a href='${root}/chat/list' class="btn btn-outline-primary w-100 d-flex align-items-center justify-content-center">
					        <i class="bi bi-shield-x me-2"></i>채팅
					      </a>
					    </div>	
					    <div class="col">
					      <a href='${root}/board.co' class="btn btn-outline-primary w-100 d-flex align-items-center justify-content-center">
					        <i class="bi bi-file-text me-2"></i>게시글
					      </a>
					    </div>
					    <div class="col">
					      <a href='${root}/reply.co' class="btn btn-outline-primary w-100 d-flex align-items-center justify-content-center">
					        <i class="bi bi-chat-dots me-2"></i>댓글
					      </a>
					    </div>
					  </div>
					</div>
				</div>
				
				<!-- 위치 및 주소 카드 -->
				<div class="card shadow-sm">
					<div class="card-header bg-warning text-white">
						<h4 class="mb-0">
							<i class="bi bi-geo-alt me-2"></i>위치 및 주소
						</h4>
					</div>
					<div class="card-body">
						<div class="row g-3">
							<div class="col-md-6">
								<a href='${root}/dongne.me' class="btn btn-outline-warning w-100 d-flex align-items-center justify-content-center">
									<i class="bi bi-house-door me-2"></i>우리동네 설정
								</a>
							</div>
							<div class="col-md-6">
								<a href='${root}/deliveryAddress.me' class="btn btn-outline-warning w-100 d-flex align-items-center justify-content-center">
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

<script type="text/javascript">
//평점 조회
// 평점 조회 및 표시
$.ajax({
    url: `${root}/selectRatingScore.me`,
    method: 'POST',
    data: {},
    success: function(res) {
        const ratingArea = document.getElementById('ratingArea');
        let html = '';
        if (res == -1) {
            html = `<span class="text-danger"><i class="bi bi-x-octagon me-1"></i>평점 정보를 불러올 수 없습니다</span>`;
        } else if (res == 0) {
            html = `<span class="text-secondary"><i class="bi bi-question-circle me-1"></i>아직 평점이 충분하지 않아요</span>`;
        } else {
            const score = parseFloat(res).toFixed(1);
            let icon = '';
            let color = '';
            // 평점별 아이콘 및 색상 지정
            if (score < 2) {
                icon = '<i class="bi bi-emoji-frown-fill me-1"></i>';
                color = 'text-danger';
            } else if (score < 3) {
                icon = '<i class="bi bi-emoji-expressionless-fill me-1"></i>';
                color = 'text-warning';
            } else if (score < 4) {
                icon = '<i class="bi bi-emoji-smile-fill me-1"></i>';
                color = 'text-primary';
            } else {
                icon = '<i class="bi bi-emoji-heart-eyes-fill me-1"></i>';
                color = 'text-success';
            }
            html = `<span class="\${color}">\${icon}평점 \${score} / 5.0</span>`;
        }
        ratingArea.innerHTML = html;
    },
    error: function() {
        document.getElementById('ratingArea').innerHTML =
          `<span class="text-danger"><i class="bi bi-x-octagon me-1"></i>평점 정보를 불러올 수 없습니다</span>`;
    }
});

//전역 변수
let isPasswordValid = false;
const pwdRegex = /^[A-Za-z0-9]{4,30}$/;

// 수정하기 버튼 클릭 핸들러
document.getElementById('editTriggerBtn').addEventListener('click', function() {
    document.getElementById('passwordSection').classList.toggle('d-none');
});

// 실시간 비밀번호 검증 (0.3초 디바운스)
const debouncedCheckPassword = _.debounce(function() {
    const inputPwd = document.getElementById('inputPwd').value;
    const feedback = document.getElementById('passwordFeedback');

    if (!pwdRegex.test(inputPwd)) {
        showValidationError("특수문자 제외 4~30글자로 입력해주세요");
        return;
    }

    $.ajax({
        url: 'checkUserPwd.me',
        method: 'POST',
        data: { inputPwd: inputPwd },
        success: function(response) {
            if (response === 'pass') {
                window.location.href = '${root}/update.me';
            } else {
                showValidationError("비밀번호가 일치하지 않습니다");
            }
        },
        error: function() {
            showValidationError("서버 연결 오류");
        }
    });
}, 300);

// 이벤트 리스너 등록
document.getElementById('inputPwd').addEventListener('input', function() {
    debouncedCheckPassword();
});

// 유효성 오류 표시 함수
function showValidationError(message) {
    const feedback = document.getElementById('passwordFeedback');
    feedback.textContent = message;
    feedback.className = "invalid-feedback d-block";
    isPasswordValid = false;
}

</script>
</html>
