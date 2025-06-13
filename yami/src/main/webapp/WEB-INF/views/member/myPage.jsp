<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://cdn.jsdelivr.net/npm/lodash@4.17.21/lodash.min.js"></script>
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
									<tr>
										<td class="fw-bold text-primary">
											<i class="bi bi-point me-2"></i>포인트
										</td>
										<td class="border-start ps-3">${pageScope.loginUser.point}</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="text-end mt-3">
						    <button type="button" class="btn btn-outline-primary" 
						      id="editTriggerBtn">
						        <i class="bi bi-pencil-square me-1"></i>수정하기
						    </button>
					    
						    <!-- 숨겨진 비밀번호 확인 영역 -->
						    <div id="passwordSection" class="mt-3 d-none">
						        <div class="card border-primary">
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
					<div class="card-header bg-success text-white">
						<h4 class="mb-0">
							<i class="bi bi-activity me-2"></i>나의 활동
						</h4>
					</div>
					<div class="card-body">
					  <div class="row row-cols-2 g-3">
					    <div class="col">
					      <a href='${root}/wishlist.co' class="btn btn-outline-success w-100 d-flex align-items-center justify-content-center">
					        <i class="bi bi-file-text me-2"></i>찜
					      </a>
					    </div>
					    <div class="col">
					      <a href='${root}/chat.co' class="btn btn-outline-success w-100 d-flex align-items-center justify-content-center">
					        <i class="bi bi-shield-x me-2"></i>채팅
					      </a>
					    </div>
					    <div class="col">
					      <a href='${root}/board.co' class="btn btn-outline-success w-100 d-flex align-items-center justify-content-center">
					        <i class="bi bi-file-text me-2"></i>게시글
					      </a>
					    </div>
					    <div class="col">
					      <a href='${root}/reply.co' class="btn btn-outline-success w-100 d-flex align-items-center justify-content-center">
					        <i class="bi bi-chat-dots me-2"></i>댓글
					      </a>
					    </div>
					  </div>
					</div>
				</div>
				
				   <!-- 구매한 상품 평점 등록 카드 -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-warning text-white">
                        <h4 class="mb-0"><i class="bi bi-star me-2"></i>구매한 상품 평점 등록</h4>
                    </div>
                    <div class="card-body">
                        <div id="purchasedListContainer">
                            <p class="text-muted">구매한 상품을 불러오는 중...</p>
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

<script type="text/javascript">
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
	
	
	
	
	
	// 구매 목록 불러와 평점 UI 생성
	$(function(){
	  $.getJSON('${root}/myPurchasedList.po')
	    .done(function(data) {
	      var list = data.result;
	      var container = $('#purchasedListContainer').empty();
	      
	      if (!list || list.length === 0) {
	        container.append('<div class="text-muted">구매한 상품이 없습니다.</div>');
	        return;
	      }
	      
	      // forEach 대신 jQuery $.each 써도 OK
	      list.forEach(function(p) {
	        var html =
	          '<div class="mb-4 border-bottom pb-3">' +
	            '<strong>' + p.productTitle + '</strong><br>' +
	            '<input type="number" min="1" max="5" class="form-control w-25 d-inline" ' +
	                   'id="score_' + p.productNo + '" placeholder="평점(1~5)">' +
	            '<input type="text" class="form-control mt-2" ' +
	                   'id="comment_' + p.productNo + '" placeholder="한줄평">' +
	            '<button class="btn btn-sm btn-warning mt-2" ' +
	                    'onclick="submitRating(' + p.productNo + ')">등록</button>' +
	          '</div>';
	        container.append(html);
	      });
	    })
	    .fail(function(){
	      $('#purchasedListContainer')
	        .html('<div class="text-danger">불러오기 실패</div>');
	    });
	});

	// 평점 등록 Ajax
	function submitRating(prodNo) {
	  var score   = +$('#score_' + prodNo).val();
	  var comment = $('#comment_' + prodNo).val();

	  if (!score || score < 1 || score > 5) {
	    return alert("평점은 1~5 사이 숫자여야 합니다.");
	  }

	  $.post('${root}/insertRating.rt', {
	    productNo:  prodNo,
	    score:      score,
	    userComment: comment
	  })
	  .done(function(){
	    alert("평점이 등록되었습니다.");
	  })
	  .fail(function(){
	    alert("평점 등록 실패");
	  });
	}
    
    
    
	
	
	
	
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
