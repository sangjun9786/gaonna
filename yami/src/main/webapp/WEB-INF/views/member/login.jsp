<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <script src="https://cdn.jsdelivr.net/npm/lodash@4.17.21/lodash.min.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>로그인</title>
    
    <style>
    /* 검증 메시지 스타일링 */
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
                        <h3 class="mb-0">로그인</h3>
                    </div>
                    <div class="card-body">
                        <form action="login.me" id="loginForm" method="post" class="needs-validation" novalidate>
                            <!-- 아이디 -->
                            <div class="mb-4">
                                <label for="userId" class="form-label fw-bold">* 아이디</label>
                                <div class="input-group has-validation">
                                    <input type="text" id="userId" class="form-control" placeholder="이메일 주소" name="userId" required>
                                    <span class="input-group-text">@</span>
                                    <input list="domain" name="domain" id="domainList" class="form-control">
                                    <datalist id="domain">
                                        <option value="naver.com">naver.com</option>
                                        <option value="gmail.com">gmail.com</option>
                                    </datalist>
                                </div>
                            </div>

                            <!-- 비밀번호 -->
                            <div class="mb-4">
                                <label for="userPwd" class="form-label fw-bold">* 비밀번호</label>
                                <input type="password" id="userPwd" class="form-control" placeholder="비밀번호" name="userPwd" required>
                            </div>

                            <!-- 제출 -->
                            <div class="d-grid">
                                <button type="submit" id="loginFormSubmit" class="btn btn-secondary" disabled>
                                    <span class="validation-message">모든 필수 항목을 입력하세요</span>
                                </button>
                            </div>
                            <div class="mt-3 d-flex flex-column flex-md-row align-items-md-center justify-content-between">
							    <div class="form-check mb-2 mb-md-0">
							        <input class="form-check-input" type="checkbox" value="Y" id="saveLoginInfo" name="saveLoginInfo">
							        <label class="form-check-label" for="saveLoginInfo">
							            로그인 정보 저장하기
							        </label>
							    </div>
							    <div class="form-check mb-2 mb-md-0 ms-md-3">
							        <input class="form-check-input" type="checkbox" value="Y" id="autoLogin" name="autoLogin">
							        <label class="form-check-label" for="autoLogin">
							            자동 로그인
							        </label>
							    </div>
							    <button type="button" class="btn btn-link p-0 ms-md-3" onclick="location.href='${root}/findPwd.me'">
							        비밀번호 찾기
							    </button>
							</div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
    // 검증 상태 변수
    let idPass = false;
    let pwdPass = false;

    // 아이디 검증
    document.getElementById("userId").addEventListener('input', function(){
        idConfirm();
    });

    // 도메인 변경 시 검증
    document.getElementById("domainList").addEventListener('change', function(){
        idPass = false;
        toggleSubmit();
        idConfirm();
    });

    // 아이디 확인 함수
    function idConfirm(){
        const userId = document.getElementById("userId").value;
        const regex = /^[A-Za-z0-9]{1,30}$/;
        
        if (regex.test(userId) && document.getElementById("domainList").value !== "") {
            idPass = true;
        } else {
            idPass = false;
        }
        toggleSubmit();
    }

    // 비밀번호 검증
    document.getElementById('userPwd').addEventListener('input', function() {
        const pwd = this.value;
        const regex = /^[A-Za-z0-9]{4,30}$/;
        pwdPass = regex.test(pwd);
        toggleSubmit();
    });

    // 제출 버튼 상태 관리
    function toggleSubmit(){
        let submitBtn = document.getElementById("loginFormSubmit");
        let messageSpan = submitBtn.querySelector('.validation-message');
		let userId = document.getElementById("userId").value
				+'@'+document.getElementById("domainList").value
		let userPwd = document.getElementById("userPwd");
        
        if(idPass && pwdPass) {
            submitBtn.className = 'btn btn-success';
            submitBtn.disabled = false;
            messageSpan.textContent = 'YAMI !';
            return;
            
        } else if(idPass) {
        	if(userPwd.value == ""){
        		messageSpan.textContent = "비밀번호를 입력해주세요";
        	}else{
	            messageSpan.textContent = "비밀번호는 특수문자 제외 4~30 글자입니다.";
        	}
        }else if(pwdPass){
        	if(userId == "@"){
        		messageSpan.textContent = "아이디를 입력해주세요";
        	}else{
	            messageSpan.textContent = "아이디는 특수문자 제외 1~30 글자 이메일 형식입니다.";
        	}
        }else{
        	messageSpan.textContent = "아이디와 비밀번호를 입력하세요";
        }
        submitBtn.className = 'btn btn-secondary';
        submitBtn.disabled = true;
    };

    //제출 버튼 이벤트 핸들러
	document.getElementById("loginForm").addEventListener("submit", function(event) {
	    event.preventDefault();
	    
	    $('#loginFormSubmit').prop('disabled', true)
           .html(`<span class="spinner-border spinner-border-sm" role="status"></span> 처리 중...`);
	    
		this.submit();
	});
    </script>

</body>
</html>