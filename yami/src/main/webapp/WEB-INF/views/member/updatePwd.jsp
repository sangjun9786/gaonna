<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 변경</title>
</head>
<body>
<%@include file="/WEB-INF/views/common/header.jsp" %>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <div class="card shadow-sm shadow-lg mx-auto">
                <div class="card-header bg-primary text-white">
                    <h3 class="mb-0">비밀번호 재설정</h3>
                </div>
                <div class="card-body">
                    <div class="mb-3 fw-bold">
                        ${sessionScope.findPwdUser.userName}님, 사용하실 비밀번호를 작성해주세요.
                    </div>
                    <form action="${root}/updatePwd.email" id="resetPwdForm" method="post" class="needs-validation" novalidate>
                        <!-- 아이디 -->
                        <div class="mb-4">
                            <label for="userId" class="form-label fw-bold">아이디</label>
                            <input type="text" id="userId" class="form-control" value="${sessionScope.findPwdUser.userId}" disabled>
                        </div>
                        <!-- 비밀번호 -->
                        <div class="mb-4">
                            <label for="newPwd" class="form-label fw-bold">* 비밀번호</label>
                            <input type="password" id="newPwd" name="newPwd" class="form-control" placeholder="새 비밀번호" required autocomplete="off">
                            <div class="invalid-feedback">
                                비밀번호는 특수문자 제외 4~30글자입니다.
                            </div>
                        </div>
                        <!-- 비밀번호 확인 -->
                        <div class="mb-4">
                            <label for="confirmPwd" class="form-label fw-bold">* 비밀번호 확인</label>
                            <input type="password" id="confirmPwd" class="form-control" placeholder="비밀번호 재입력" required autocomplete="off">
                            <div class="invalid-feedback" id="confirmPwdFeedback">
                                비밀번호가 일치하지 않습니다.
                            </div>
                        </div>
                        <!-- 제출 -->
                        <div class="d-grid">
                            <button type="submit" id="resetPwdSubmit" class="btn btn-secondary" disabled>
                                <span class="validation-message">비밀번호를 입력하세요</span>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// 유효성 상태 변수
let pwdPass = false;
let confirmPass = false;

// 비밀번호 유효성 검사
document.getElementById('newPwd').addEventListener('input', function() {
    const pwd = this.value;
    const regex = /^[A-Za-z0-9]{4,30}$/;
    pwdPass = regex.test(pwd);
    checkConfirmPwd();
    toggleSubmit();
});

// 비밀번호 확인 검사
document.getElementById('confirmPwd').addEventListener('input', function() {
    checkConfirmPwd();
    toggleSubmit();
});

function checkConfirmPwd() {
    const pwd = document.getElementById('newPwd').value;
    const confirm = document.getElementById('confirmPwd').value;
    const feedback = document.getElementById('confirmPwdFeedback');
    if (confirm === "") {
        confirmPass = false;
        feedback.textContent = "비밀번호를 다시 입력해주세요.";
        document.getElementById('confirmPwd').classList.remove('is-valid', 'is-invalid');
        return;
    }
    if (pwd === confirm && pwdPass) {
        confirmPass = true;
        document.getElementById('confirmPwd').classList.add('is-valid');
        document.getElementById('confirmPwd').classList.remove('is-invalid');
        feedback.textContent = "";
    } else {
        confirmPass = false;
        document.getElementById('confirmPwd').classList.remove('is-valid');
        document.getElementById('confirmPwd').classList.add('is-invalid');
        feedback.textContent = "비밀번호가 일치하지 않습니다.";
    }
}

// 제출 버튼 상태 관리
function toggleSubmit() {
    let submitBtn = document.getElementById("resetPwdSubmit");
    let messageSpan = submitBtn.querySelector('.validation-message');
    if(pwdPass && confirmPass) {
        submitBtn.className = 'btn btn-success';
        submitBtn.disabled = false;
        messageSpan.textContent = "비밀번호 변경이 가능합니다!";
    } else if(pwdPass) {
        submitBtn.className = 'btn btn-secondary';
        submitBtn.disabled = true;
        messageSpan.textContent = "비밀번호를 다시 확인해주세요.";
    } else {
        submitBtn.className = 'btn btn-secondary';
        submitBtn.disabled = true;
        messageSpan.textContent = "비밀번호를 입력하세요";
    }
}

// 부트스트랩 검증 활성화 및 중복 제출 방지
document.getElementById("resetPwdForm").addEventListener("submit", function(event) {
    event.preventDefault();
    if (!(pwdPass && confirmPass)) {
        this.classList.add('was-validated');
        return;
    }
    // 중복 제출 방지
    let submitBtn = document.getElementById("resetPwdSubmit");
    submitBtn.disabled = true;
    submitBtn.innerHTML = `<span class="spinner-border spinner-border-sm" role="status"></span> 처리 중...`;
    this.submit();
});
</script>
</body>
</html>
