<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <script src="https://cdn.jsdelivr.net/npm/lodash@4.17.21/lodash.min.js"></script>
    <meta charset="UTF-8">
    <title>비밀번호 찾기</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        .validation-message {
            font-size: 0.9em;
            display: block;
            margin-top: 2px;
        }
        .btn-success .validation-message {
            color: #fff !important;
        }
    </style>
</head>
<body>
<%@include file="/WEB-INF/views/common/header.jsp" %>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <div class="card shadow-sm shadow-lg mx-auto">
                <div class="card-header bg-primary text-white">
                    <h3 class="mb-0">비밀번호 찾기</h3>
                </div>
                <div class="card-body">
                    <form action="${root}/findPwd.me" id="findPwdForm" method="post" class="needs-validation" novalidate>
                        <!-- 안내문구 -->
                        <div class="mb-3">
                            <div class="alert alert-info py-2 mb-0" role="alert" style="font-size:1em;">
                                확인 버튼을 누르면 해당 주소로 확인 이메일이 발송됩니다.
                            </div>
                        </div>
                        <!-- 아이디 -->
                        <div class="mb-4">
                            <label for="userId" class="form-label fw-bold">* 아이디</label>
                            <div class="input-group has-validation">
                                <input type="text" id="userId" class="form-control" placeholder="이메일 아이디" name="userId" required>
                                <span class="input-group-text">@</span>
                                <input list="domain" name="domain" id="domainList" class="form-control" required>
                                <datalist id="domain">
                                    <option value="naver.com">naver.com</option>
                                    <option value="gmail.com">gmail.com</option>
                                </datalist>
                            </div>
                            <div id="checkIdResult" class="validation-message"></div>
                        </div>
                        <!-- 확인 버튼 -->
                        <div class="d-grid">
                            <button type="submit" id="findPwdSubmit" class="btn btn-secondary" disabled>
                                <span class="validation-message">아이디를 입력하세요</span>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
let idPass = false; // 아이디 존재 여부
let lengthPass = false; // 길이 유효성

// 아이디, 도메인 입력 시마다 유효성 및 중복확인
document.getElementById("userId").addEventListener('input', checkAll);
document.getElementById("domainList").addEventListener('input', checkAll);

function checkAll() {
    let userId = document.getElementById("userId").value.trim();
    let domain = document.getElementById("domainList").value.trim();
    let fullEmail = userId;
    let regex = /^[A-Za-z0-9]{1,30}$/;

    // 길이 체크
    if(userId && domain && fullEmail.length <= 30) {
        lengthPass = true;
        // 아이디 형식 체크
        if(regex.test(userId)) {
            debounceCheck();
        } else {
            idPass = false;
            showMessage("아이디는 특수문자 제외 1~30글자입니다.", false);
            toggleSubmit();
        }
    } else if(fullEmail.length > 30) {
        idPass = false;
        lengthPass = false;
        showMessage("아이디는 30글자를 넘을 수 없습니다.", false);
        toggleSubmit();
    } else {
        idPass = false;
        lengthPass = false;
        showMessage("아이디와 도메인을 모두 입력하세요.", false);
        toggleSubmit();
    }
}

// AJAX 중복확인 (lodash debounce)
let debounceCheck = _.debounce(function() {
    let userId = document.getElementById("userId").value.trim();
    let domain = document.getElementById("domainList").value.trim();
    if(!userId || !domain) return;

    $.ajax({
        url: "checkUserId.me",
        data: {userId: userId, domain: domain},
        success: function(result) {
            if(result == "noPass") {
                showMessage("'"+userId+"@"+domain+"'는 존재하는 아이디입니다.", true);
                idPass = true;
                toggleSubmit();
            } else if(result == "pass") {
                showMessage("'"+userId+"@"+domain+"'는 존재하지 않는 아이디입니다.", false);
                idPass = false;
                toggleSubmit();
            } else {
                showMessage("서버 에러", false);
                idPass = false;
                toggleSubmit();
            }
        },
        error: function() {
            showMessage("통신 오류!", false);
            idPass = false;
            toggleSubmit();
        }
    });
}, 300);

// 메시지 표시 함수
function showMessage(msg, valid) {
    let el = document.getElementById('checkIdResult');
    el.textContent = msg;
    el.className = valid ? "valid-feedback d-block" : "invalid-feedback d-block";
}

// 제출 버튼 상태 관리
function toggleSubmit() {
    let submitBtn = document.getElementById("findPwdSubmit");
    let messageSpan = submitBtn.querySelector('.validation-message');
    if(idPass && lengthPass) {
        submitBtn.className = 'btn btn-success';
        submitBtn.disabled = false;
        messageSpan.textContent = "눌러서 확인 이메일을 보내요!";
    } else if(lengthPass) {
        submitBtn.className = 'btn btn-secondary';
        submitBtn.disabled = true;
        messageSpan.textContent = "존재하지 않는 아이디입니다.";
    } else {
        submitBtn.className = 'btn btn-secondary';
        submitBtn.disabled = true;
        messageSpan.textContent = "아이디를 입력하세요";
    }
}

// 중복 제출 방지
document.getElementById("findPwdForm").addEventListener("submit", function(event) {
    event.preventDefault();
    $('#findPwdSubmit').prop('disabled', true)
        .html(`<span class="spinner-border spinner-border-sm" role="status"></span> 처리 중...`);
    this.submit();
});
</script>
</body>
</html>
