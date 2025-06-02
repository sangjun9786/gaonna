<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 추가하기</title>
</head>
<body>
<%@include file="/WEB-INF/views/common/header.jsp" %>

<div class="container py-5">
  <div class="row justify-content-center">
    <div class="col-md-8 col-lg-6">
      <div class="card shadow-sm shadow-lg mx-auto">
        <div class="card-header bg-success text-white">
          <h3 class="mb-0">관리자 추가하기</h3>
        </div>
        <div class="card-body">
          <form id="adminForm" action="${pageScope.root}/insertAdmin.ad" method="post" novalidate>
            <!-- 아이디 -->
            <div class="mb-3">
              <label for="userId" class="form-label fw-bold">아이디</label>
              <input type="text" class="form-control" id="userId" name="userId" placeholder="영문/숫자 1~30자" required>
              <div id="userIdFeedback" class="form-text text-muted mt-1">영문/숫자 1~30자</div>
            </div>
            <!-- 비밀번호 -->
            <div class="mb-3">
              <label for="userPwd" class="form-label fw-bold">비밀번호</label>
              <input type="text" class="form-control" id="userPwd" name="userPwd" placeholder="영문/숫자 4~30자" required>
              <div id="userPwdFeedback" class="form-text text-muted mt-1">영문/숫자 4~30자</div>
            </div>
            <!-- 전화번호 -->
            <div class="mb-3">
              <label for="phone" class="form-label fw-bold">전화번호</label>
              <input type="text" class="form-control" id="phone" name="phone" placeholder="010-1234-5678" required>
              <div id="phoneFeedback" class="form-text text-muted mt-1">예: 010-1234-5678</div>
            </div>
            <!-- 이름 -->
            <div class="mb-3">
              <label for="userName" class="form-label fw-bold">이름</label>
              <input type="text" class="form-control" id="userName" name="userName" placeholder="홍길동" required>
              <div id="nameFeedback" class="form-text text-muted mt-1">10글자 이하</div>
            </div>
            <!-- 포인트 -->
            <div class="mb-3">
              <label for="point" class="form-label fw-bold">포인트</label>
              <input type="number" class="form-control" id="point" name="point" min="0" value="0" required>
              <div class="form-text text-muted mt-1">0 이상의 숫자</div>
            </div>
            <!-- 권한 -->
            <div class="mb-4">
              <label for="roleType" class="form-label fw-bold">관리자 권한</label>
              <select class="form-select" id="roleType" name="roleType" required>
                <option value="viewer">뷰어</option>
                <option value="admin">일반 관리자</option>
                <option value="superAdmin">최고 관리자</option>
              </select>
            </div>
            <!-- 최종 결과 메시지 -->
            <div id="finalResult" class="alert alert-light text-center mb-4" role="alert">모든 항목을 입력하세요</div>
            <!-- 버튼 -->
            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
              <button type="submit" id="addAdminBtn" class="btn btn-success" disabled>추가하기</button>
              <button type="button" id="resetBtn" class="btn btn-outline-secondary">초기화</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
// 유효성 상태
let idPass = false, pwdPass = false, phonePass = true, namePass = false, pointPass = true;

// 아이디 유효성
document.getElementById('userId').addEventListener('input', function() {
  const val = this.value;
  const regex = /^[A-Za-z0-9@.]{1,30}$/;
  const feedback = document.getElementById('userIdFeedback');
  if (regex.test(val)) {
    feedback.textContent = "사용 가능한 아이디입니다.";
    feedback.className = "valid-feedback d-block";
    idPass = true;
  } else {
    feedback.textContent = "영문/숫자 1~30자 (특수문자 불가)";
    feedback.className = "invalid-feedback d-block";
    idPass = false;
  }
  toggleSubmit();
});

// 비밀번호 유효성
document.getElementById('userPwd').addEventListener('input', function() {
  const val = this.value;
  const regex = /^[A-Za-z0-9]{4,30}$/;
  const feedback = document.getElementById('userPwdFeedback');
  if (regex.test(val)) {
    feedback.textContent = "사용 가능한 비밀번호입니다.";
    feedback.className = "valid-feedback d-block";
    pwdPass = true;
  } else {
    feedback.textContent = "영문/숫자 4~30자 (특수문자 불가)";
    feedback.className = "invalid-feedback d-block";
    pwdPass = false;
  }
  toggleSubmit();
});

// 전화번호 유효성
document.getElementById('phone').addEventListener('input', function() {
  const val = this.value;
  const regex = /^\d{3}-\d{3,4}-\d{4}$/;
  const feedback = document.getElementById('phoneFeedback');
  if (regex.test(val) || val=="") {
    feedback.textContent = "올바른 형식입니다.";
    feedback.className = "valid-feedback d-block";
    phonePass = true;
  } else {
    feedback.textContent = "예: 010-1234-5678";
    feedback.className = "invalid-feedback d-block";
    phonePass = false;
  }
  toggleSubmit();
});

//이름 유효성
document.getElementById('userName').addEventListener('input', function() {
  const val = this.value.trim();
  const regex = /^.{1,10}$/; // 모든 문자 1~10글자 (한글 포함)
  const feedback = document.getElementById('nameFeedback');
  
  if (regex.test(val)) {
    feedback.textContent = "올바른 이름입니다.";
    feedback.className = "valid-feedback d-block";
    namePass = true;
  } else {
    feedback.textContent = "1~10글자로 입력해주세요";
    feedback.className = "invalid-feedback d-block";
    namePass = false;
  }
  toggleSubmit();
});

// 포인트 유효성 (0 이상 20억 이하 숫자)
document.getElementById('point').addEventListener('input', function() {
  pointPass = (this.value !== "" && !isNaN(this.value) 
		  && Number(this.value) >= 0
		  && Number(this.value) <= 2000000000);
  toggleSubmit();
});

// 버튼 상태 제어
function toggleSubmit() {
  const btn = document.getElementById('addAdminBtn');
  const result = document.getElementById('finalResult');
  if (idPass && pwdPass && phonePass && pointPass && namePass) {
    btn.disabled = false;
    result.textContent = "모든 항목이 올바르게 입력되었습니다.";
    result.className = "alert alert-success text-center mb-4";
  } else {
    btn.disabled = true;
    result.textContent = "모든 항목을 입력하세요";
    result.className = "alert alert-light text-center mb-4";
  }
}

// 폼 제출시 로딩 및 최종 검증
document.getElementById('adminForm').addEventListener('submit', function(e) {
  if (!(idPass && pwdPass && phonePass && pointPass)) {
    e.preventDefault();
    document.getElementById('finalResult').textContent = "입력값을 다시 확인하세요.";
    document.getElementById('finalResult').className = "alert alert-warning text-center mb-4";
    return false;
  }
  document.getElementById('addAdminBtn').innerHTML = '<span class="spinner-border spinner-border-sm" role="status"></span> 처리 중...';
  document.getElementById('addAdminBtn').disabled = true;
});

// 초기화
document.getElementById('resetBtn').addEventListener('click', function() {
  if (confirm("정말 초기화할까요?")) {
    document.getElementById('adminForm').reset();
    document.getElementById('userIdFeedback').className = "form-text text-muted mt-1";
    document.getElementById('userIdFeedback').textContent = "영문/숫자 1~30자";
    document.getElementById('userPwdFeedback').className = "form-text text-muted mt-1";
    document.getElementById('userPwdFeedback').textContent = "영문/숫자 4~30자";
    document.getElementById('phoneFeedback').className = "form-text text-muted mt-1";
    document.getElementById('phoneFeedback').textContent = "예: 010-1234-5678";
    document.getElementById('finalResult').className = "alert alert-light text-center mb-4";
    document.getElementById('finalResult').textContent = "모든 항목을 입력하세요";
    document.getElementById('nameFeedback').className = "form-text text-muted mt-1";
    document.getElementById('nameFeedback').textContent = "10글자 이하";
    idPass = pwdPass = namePass = false;
    pointPass = phonePass = true;
    toggleSubmit();
  }
});
</script>
</body>
</html>
