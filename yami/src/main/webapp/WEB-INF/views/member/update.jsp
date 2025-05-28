<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>정보수정</title>
<style>
	.cursor-pointer {
	    cursor: pointer !important;
	}
</style>
<script src="https://cdn.jsdelivr.net/npm/lodash@4.17.21/lodash.min.js"></script>
</head>
<body>
<%@include file="/WEB-INF/views/common/header.jsp" %>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <!-- 사용자 정보 카드 -->
            <div class="card shadow-lg">
                <div class="card-header bg-primary text-white">
                    <h3 class="mb-0">
                        <i class="bi bi-person-gear me-2"></i>계정 정보 수정
                    </h3>
                </div>
                
                <div class="card-body" id="loading">
                    <!-- 동적 편집 테이블 -->
                    <table class="table table-borderless align-middle" id="infoTable">
                        <tbody>
                            <!-- 아이디-->
                            <tr data-bs-toggle="modal" data-bs-target="#emailModal" 
                                class="editable-row cursor-pointer">
                                <td class="fw-bold text-primary" style="width:35%">
                                    <i class="bi bi-person-badge me-2"></i>눌러서 아이디 수정
                                </td>
                                <td class="border-start ps-3">${loginUser.userId}</td>
                            </tr>
                            
                            <!-- 비밀번호 수정 -->
                            <tr data-bs-toggle="modal" data-bs-target="#passwordModal" 
							    class="editable-row cursor-pointer">
							    <td class="fw-bold text-primary">
							        <i class="bi bi-shield-lock me-2"></i>눌러서 비밀번호 변경
							    </td>
							    <td class="border-start ps-3">••••••••</td>
							</tr>
                            
                            <!-- 이름 수정 -->
                            <tr data-bs-toggle="modal" data-bs-target="#nameModal"
                                class="editable-row cursor-pointer">
                                <td class="fw-bold text-primary">
                                    <i class="bi bi-person me-2"></i>눌러서 이름 수정
                                </td>
                                <td class="border-start ps-3">${loginUser.userName}</td>
                            </tr>
                            
                            <!-- 전화번호 수정 -->
                            <tr data-bs-toggle="modal" data-bs-target="#phoneModal"
                                class="editable-row cursor-pointer">
                                <td class="fw-bold text-primary">
                                    <i class="bi bi-telephone me-2"></i>눌러서 전화번호 수정
                                </td>
                                <td class="border-start ps-3">
                                    <c:choose>
                                        <c:when test="${not empty loginUser.phone}">
                                            ${loginUser.phone}
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-danger">❌ 미등록</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    
                    <!-- 뒤로가기 -->
                    <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                        <button type="button" class="btn btn-primary" 
                            onclick="location.href='${root}/mypage.me'">
                            <i class="bi bi-save me-1"></i>확인
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 이메일 수정 모달 -->
<div class="modal fade" id="emailModal" tabindex="-1" 
  aria-labelledby="emailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <!-- 모달 헤더 -->
            <div class="modal-header bg-light">
                <h5 class="modal-title" id="emailModalLabel">
                    <i class="bi bi-envelope me-2"></i>이메일 주소 변경
                </h5>
                <button type="button" class="btn-close" 
                  data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            
            <!-- 모달 본문 -->
            <form id="emailUpdateForm" class="needs-validation" novalidate>
                <div class="modal-body">
                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <input type="text" class="form-control" id="userId"
                                placeholder="사용자 ID" required>
                        </div>
                        <div class="col-md-6">
                            <div class="input-group">
                                <span class="input-group-text">@</span>
                                <input list="domain" class="form-select" 
                                  id="domainList" required>
                                <datalist id="domain">
                                    <option value="naver.com">naver.com</option>
                                    <option value="gmail.com">gmail.com</option>
                                </datalist>
                            </div>
                        </div>
                    </div>
                    <div class="alert alert-warning mb-0" id="checkIdResult">
                        <i class="bi bi-exclamation-triangle me-2"></i>
                        변경 후 이메일로 인증 메일이 발송됩니다
                    </div>
                </div>
                
                <!-- 모달 푸터 -->
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" 
                      data-bs-dismiss="modal">닫기</button>
                    <button type="submit" class="btn btn-primary"
                     id="insertSubmit" disabled>이메일 변경</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- 비밀번호 모달 -->
<div class="modal fade" id="passwordModal" tabindex="-1" 
  aria-labelledby="passwordModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-light">
                <h5 class="modal-title" id="passwordModalLabel">
                    <i class="bi bi-shield-lock me-2"></i>비밀번호 변경
                </h5>
                <button type="button" class="btn-close" 
                  data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            
            <form id="passwordUpdateForm" action="${root}/updatePwd.me" method="post">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="newPwd" class="form-label">새 비밀번호</label>
                        <input type="password" class="form-control" 
                            id="newPwd" name="newPwd" required>
                        <div id="pwdValidation" class="form-text text-muted">
                            특수문자 제외 4~30자리
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="confirmPwd" class="form-label">비밀번호 확인</label>
                        <input type="password" class="form-control" 
                            id="confirmPwd" required>
                        <div id="pwdCheckResult" class="invalid-feedback"></div>
                    </div>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" 
                      data-bs-dismiss="modal">닫기</button>
                    <button type="submit" class="btn btn-primary" 
                      id="pwdSubmitBtn" disabled>
                        <span>비밀번호 변경</span>
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- 이름 수정 모달 -->
<div class="modal fade" id="nameModal" tabindex="-1" 
  aria-labelledby="nameModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-light">
                <h5 class="modal-title" id="nameModalLabel">
                    <i class="bi bi-person me-2"></i>이름 변경
                </h5>
                <button type="button" class="btn-close" 
                  data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form id="nameUpdateForm" action='${root}/updateName.me' method="post">
                <div class="modal-body">
				    <div class="mb-3">
				        <label for="userName" class="form-label">새로운 이름</label>
				        <input type="text" class="form-control" 
				              id="userName" name="userName" 
				              value="${loginUser.userName}" required>
				        <div id="checkNameResult" class="invalid-feedback"></div>
				    </div>
				</div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" 
                      data-bs-dismiss="modal">닫기</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check-circle me-1"></i>변경 적용
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- 전화번호 수정 모달 -->
<div class="modal fade" id="phoneModal" tabindex="-1" 
  aria-labelledby="phoneModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-light">
                <h5 class="modal-title" id="phoneModalLabel">
                    <i class="bi bi-phone me-2"></i>전화번호 변경
                </h5>
                <button type="button" class="btn-close" 
                  data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form id="phoneUpdateForm">
                <div class="modal-body">
                    <div class="mb-3">
					    <label for="phone" class="form-label">새로운 전화번호</label>
					    <div class="input-group">
					        <input type="text" class="form-control phone-part" id="phone1" 
					               maxlength="3" placeholder="010" required>
					        <span class="input-group-text">-</span>
					        <input type="text" class="form-control phone-part" id="phone2" 
					               maxlength="4" placeholder="1234" required>
					        <span class="input-group-text">-</span>
					        <input type="text" class="form-control phone-part" id="phone3" 
					               maxlength="4" placeholder="5678" required>
					    </div>
					    <div id="checkPhoneResult" class="invalid-feedback"></div>
					</div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" 
                      data-bs-dismiss="modal">닫기</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check-circle me-1"></i>변경 적용
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script type="text/javascript">
//-------------------아이디 변경-------------------//

//검증이 true여야 sumbmit버튼 활성화됨
let idPass = false;

//아이디 검증
document.getElementById("userId").addEventListener('input', function(){
	idPass = false;
	toggleSubmit();
	idConfirm();
});

//도메인이 바뀌면 idPass = false;
document.getElementById("domainList").addEventListener('change', function(){
	idPass = false;
	toggleSubmit();
	idConfirm();
});

//아이디 확인
function idConfirm(){
	const userId = document.getElementById("userId").value;
    const regex = /^[A-Za-z0-9]{1,30}$/;
    
    if (regex.test(userId)) {
    	if(document.getElementById("domainList").value !=""){
	    	debounce();
    	}else{
    		document.getElementById('checkIdResult').textContent = userId;
    		document.getElementById('checkIdResult').className = "form-text text-muted mt-1";
	    	idPass = false;
	    	toggleSubmit();
    	}
    } else {
    	document.getElementById('checkIdResult').textContent = "특수문자 제외 1 ~ 30글자로 입력해줘";
    	document.getElementById('checkIdResult').className = "invalid-feedback d-block";
    	idPass = false;
    	toggleSubmit();
    };
}

//_.debounce : 여러 번 호출되더라도 지정된 시간이 지나야 함수가 발동됨
//ajax로 아이디 중복확인
let debounce = _.debounce(function() {
	let userId = document.getElementById("userId").value;
	let domain = document.getElementById("domainList").value;
	$.ajax({
	      url: "checkUserId.me",
	      data: {userId : userId, domain : domain},
	      success: function(result) {
			if(result == "pass"){
				document.getElementById("checkIdResult").innerHTML = "'"+userId+"@"+domain+"'라는 기합찬 아이디는 통과해도 좋다";
				document.getElementById('checkIdResult').className = "valid-feedback d-block";
				idPass = true;
				toggleSubmit();
			}else if(result == 'noPass'){
				document.getElementById("checkIdResult").innerHTML = "'"+userId+"@"+domain+"'라는 기열찐빠 아이디는 이미 누군가가 쓰는군";
				document.getElementById('checkIdResult').className = "invalid-feedback d-block";
				idPass = false;
				toggleSubmit();
			}else{
				document.getElementById("checkIdResult").innerHTML = "서버 에러";
				document.getElementById('checkIdResult').className = "invalid-feedback d-block";
				idPass = false;
				toggleSubmit();
			}
	      },
	      error: function(){
			document.getElementById("checkIdResult").innerHTML = "통신 오류!";
			document.getElementById('checkIdResult').className = "invalid-feedback d-block";
			idPass = false;
			toggleSubmit();
	      }
      });
},300);

//검증 완료되면 submit버튼 활성화
let toggolePassed = false;
function toggleSubmit(){
	let insertSubmit = document.getElementById("insertSubmit");
	
	if(idPass){
		insertSubmit.disabled = false;
		insertSubmit.classList.remove("btn-secondary");
		insertSubmit.classList.add("btn-primary");
		toggolePassed = true;
	}else if(toggolePassed == true){
		//idPass조건을 통과해 함수가 종료되었는데
		//그 이후 toggleSubmit()함수가 다시 실행될 경우 건들인 값 초기화
		
		insertSubmit.disabled = true;
		insertSubmit.classList.remove("btn-primary");
		insertSubmit.classList.add("btn-secondary");
		toggolePassed = false;
	}
};

// 폼 제출 처리
document.getElementById('emailUpdateForm').addEventListener('submit', function(e) {
    e.preventDefault();
    const userId = document.getElementById('userId').value.trim();
    let domain = domainList.value;
    if(domain === '직접입력') {
        domain = customDomain.value.trim();
    }
    const newEmail = userId + '@' + domain;
    
    alert('이메일이 "' + newEmail + '"로 변경 요청되었습니다.');
    
    // 모달 닫기
    const modal = bootstrap.Modal.getInstance(document.getElementById('emailModal'));
    modal.hide();
    
   $('#loading').prop('disabled', true)
       .html(`<span class="spinner-border spinner-border-sm" role="status"></span> 처리 중...`);
    
    location.href = "${root}/updateEmail.me?userId="+userId+"&domain="+domain;
});

//-------------------비밀번호 변경-------------------//
let pwdPass = false;
const pwdRegex = /^[A-Za-z0-9]{4,30}$/;

//새 비밀번호 입력 검증
document.getElementById('newPwd').addEventListener('input', function() {
    validatePassword();
});

// 비밀번호 확인 입력 검증
document.getElementById('confirmPwd').addEventListener('input', function() {
    validatePassword();
});

function validatePassword() {
    const newPwd = document.getElementById('newPwd').value;
    const confirmPwd = document.getElementById('confirmPwd').value;
    const resultDiv = document.getElementById('pwdCheckResult');
    
    // 기본 조건 검사
    if (!pwdRegex.test(newPwd)) {
        resultDiv.textContent = "특수문자 제외 4~30자리로 입력해주세요";
        resultDiv.className = "invalid-feedback d-block";
        pwdPass = false;
    } else if (newPwd !== confirmPwd) {
        resultDiv.textContent = "비밀번호가 일치하지 않습니다";
        resultDiv.className = "invalid-feedback d-block";
        pwdPass = false;
    } else {
        resultDiv.textContent = "사용 가능한 비밀번호입니다";
        resultDiv.className = "valid-feedback d-block";
        pwdPass = true;
    }
    
    togglePwdSubmit();
}

function togglePwdSubmit() {
    const submitBtn = document.getElementById('pwdSubmitBtn');
    submitBtn.disabled = !pwdPass;
    submitBtn.classList.toggle('btn-secondary', !pwdPass);
    submitBtn.classList.toggle('btn-primary', pwdPass);
}

document.getElementById('passwordUpdateForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    if (pwdPass) {
        const submitBtn = document.getElementById('pwdSubmitBtn');
        
        // 로딩 상태 활성화
        submitBtn.innerHTML = `
            <span class="spinner-border spinner-border-sm" 
                  role="status" aria-hidden="true"></span>
            처리 중...
        `;
        submitBtn.disabled = true;
        
        // 서버 제출
        setTimeout(() => {
            this.submit();
        }, 1500);
    }
});

//모달 닫히면 초기화
document.getElementById('passwordModal').addEventListener('hidden.bs.modal', () => {
    document.getElementById('passwordUpdateForm').reset();
    document.getElementById('pwdCheckResult').className = "";
    document.getElementById('pwdSubmitBtn').innerHTML = `<span>비밀번호 변경</span>`;
    pwdPass = false;
    togglePwdSubmit();
});


//-------------------이름 변경-------------------//
let namePass = false;
document.getElementById('nameUpdateForm').addEventListener('submit', function(e){
    e.preventDefault();
    if(namePass) this.submit();
});

// 이름 검증 시 버튼 상태 업데이트
function toggleNameSubmit() {
    const submitBtn = document.querySelector('#nameUpdateForm button[type="submit"]');
    submitBtn.disabled = !namePass;
    submitBtn.classList.toggle('btn-secondary', !namePass);
    submitBtn.classList.toggle('btn-primary', namePass);
}

document.getElementById('userName').addEventListener('input', function() {
	let checkNameResult = document.getElementById("checkNameResult")
    if(this.value.length > 10){
    	checkNameResult.innerHTML = "이름이 너무 길어요";
    	checkNameResult.className = "invalid-feedback d-block";
    	namePass = false;
    }else if(this.value.length < 1){
    	checkNameResult.innerHTML = "이름을 입력해 주세요";
    	checkNameResult.className = "form-text text-muted mt-1";
    	namePass = false;
    }else{
    	checkNameResult.innerHTML = "좋아요!";
    	checkNameResult.className = "valid-feedback d-block";
    	namePass = true;
    }
	toggleNameSubmit();
});

//제출 버튼 이벤트 핸들러
document.getElementById('nameUpdateForm').addEventListener('submit', function(e) {
    e.preventDefault();
    if (namePass) {
        this.submit();
    }
});

//-------------------전화번호 변경-------------------//
let phonePass = false;
const phoneInputs = document.querySelectorAll('.phone-part');

phoneInputs.forEach((input, idx) => {
    input.addEventListener('input', function() {
        // 숫자만 입력 허용
        this.value = this.value.replace(/[^0-9]/g, '');

        // 자동 포커스 이동 (다음 .phone-part input을 찾아서 이동)
        if (this.value.length === this.maxLength) {
            // 다음 input 요소를 찾음
            let nextInput = null;
            let parent = this.parentElement;
            let found = false;
            // input-group 내에서 다음 .phone-part input을 찾음
            parent.querySelectorAll('.phone-part').forEach((el, i) => {
                if (found) return;
                if (el === input && i < parent.querySelectorAll('.phone-part').length - 1) {
                    nextInput = parent.querySelectorAll('.phone-part')[i + 1];
                    found = true;
                }
            });
            if (nextInput) nextInput.focus();
        }
        validatePhone();
    });
});

function validatePhone() {
    const phone1 = document.getElementById('phone1').value;
    const phone2 = document.getElementById('phone2').value;
    const phone3 = document.getElementById('phone3').value;
    const checkPhoneResult = document.getElementById("checkPhoneResult");

    if (!/^\d{3}$/.test(phone1) || !/^\d{3,4}$/.test(phone2) || !/^\d{4}$/.test(phone3)) {
        checkPhoneResult.textContent = "올바른 형식으로 입력해주세요 (예: 010-1234-5678)";
        checkPhoneResult.classList.remove('valid-feedback');
        checkPhoneResult.classList.add('invalid-feedback', 'd-block');
        phonePass = false;
    } else {
        checkPhoneResult.textContent = "변경 적용 버튼을 눌러 저장하세요";
        checkPhoneResult.classList.remove('invalid-feedback');
        checkPhoneResult.classList.add('valid-feedback', 'd-block');
        phonePass = true;
    }
    togglePhoneSubmit();
}

// 제출 버튼 상태 변경
function togglePhoneSubmit() {
    const submitBtn = document.querySelector('#phoneUpdateForm button[type="submit"]');
    submitBtn.disabled = !phonePass;
    submitBtn.classList.toggle('btn-secondary', !phonePass);
    submitBtn.classList.toggle('btn-primary', phonePass);
}

//전화번호 폼 제출 핸들러
document.getElementById('phoneUpdateForm').addEventListener('submit', function(e) {
    e.preventDefault();
    if (phonePass) {
        let phone = document.getElementById('phone1').value+"-"
       		+document.getElementById('phone2').value+"-"
       		+document.getElementById('phone3').value;
        location.href = '${root}/updatePhone.me?phone='+phone;
    }
});
</script>

</body>
</html>
