<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<style type="text/css">
@keyframes bg-pulse {
  0%, 100% { background-color: #198754; }   /* Bootstrap alert-success의 진한 녹색 */
  50%      { background-color: #71d88a; }   /* 밝은 녹색 */
}

.alert.alert-success.text-center.mb-4.loading {
  animation: bg-pulse 2.5s ease-in-out infinite;
}
</style>

<script src="https://cdn.jsdelivr.net/npm/lodash@4.17.21/lodash.min.js"></script>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>회원가입</title>
</head>
<body>
	<%@include file="/WEB-INF/views/common/header.jsp" %>

	<div class="container py-5">
		<div class="row justify-content-center">
			<div class="col-md-8 col-lg-6">
				<div class="card shadow-sm shadow-lg mx-auto">
					<div class="card-header bg-primary text-white">
						<h3 class="mb-0">회원가입</h3>
					</div>
					<div class="card-body">
						<form action="${pageScope.root }/insert.me" id="insertForm" method='post' class="needs-validation" novalidate>
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
								<div id="checkIdResult" class="form-text text-muted mt-1">아이디를 입력해주세요.</div>
							</div>
							
							<!-- 비밀번호 -->
							<div class="mb-3">
								<label for="userPwd" class="form-label fw-bold">* 비밀번호</label>
								<input type="password" id="userPwd" class="form-control" placeholder="비밀번호" name="userPwd" required>
							</div>
							
							<!-- 비밀번호 확인 -->
							<div class="mb-3">
								<label for="checkPwd" class="form-label fw-bold">* 비밀번호 확인</label>
								<input type="password" id="checkPwd" class="form-control" placeholder="비밀번호 재확인" required>
								<div id="checkPwdResult" class="form-text text-muted mt-1">비밀번호를 입력해주세요.</div>
							</div>
							
							<!-- 이름 -->
							<div class="mb-3">
								<label for="userName" class="form-label fw-bold">* 이름</label>
								<input type="text" id="userName" class="form-control" placeholder="이름" name="userName" required>
								<div id="checkNameResult" class="form-text text-muted mt-1">이름을 입력해주세요.</div>
							</div>
							
							<!-- 전화번호 -->
							<div class="mb-4">
							    <label for="phone" class="form-label">전화번호</label>
							    <div class="input-group">
							        <input type="text" class="form-control phone-part" id="phone1" 
							               maxlength="3" placeholder="010" required>
							        <span class="input-group-text">-</span>
							        <input type="text" class="form-control phone-part" id="phone2" 
							               maxlength="4" placeholder="1234" required>
							        <span class="input-group-text">-</span>
							        <input type="text" class="form-control phone-part" id="phone3" 
							               maxlength="4" placeholder="5678" required>
							        <input type="hidden" id="phone" name="phone">
							    </div>
							    <div id="checkPhoneResult" class="invalid-feedback"></div>
							</div>
							
							<!-- 최종 결과 메시지 -->
							<div id="finalResult" class="alert alert-light text-center mb-4" role="alert">모든 필수 항목을 입력하세요</div>
							
							<!-- 제출 및 초기화 -->
							<div class="d-grid gap-2 d-md-flex justify-content-md-end">
								<button type="submit" id="insertSubmit" class="btn btn-primary" disabled>
								    <span class="submit-text">가입하기</span>
								    <span class="spinner-border spinner-border-sm d-none" role="status"></span>
								</button>
								<button type="button" id="insertReset" class="btn btn-outline-secondary">초기화</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<script type="text/javascript">
	
		//모든 검증이 true여야 sumbmit버튼 활성화됨
		let idPass = false;
		let pwdPass = false;
		let namePass = false;
		//phone은 필수가 아니라서 ture가 초기값
		let phonePass = true;
		
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
			const domain = document.getElementById("domainList").value;
			const email = userId && domain ? userId + "@" + domain : "";
		    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
		    
		    if (emailRegex.test(email)) {
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
	
		//비밀번호가 4글자 이상, 특수문자 제외
		document.getElementById('userPwd').addEventListener('input', function() {
		    const pwd = this.value;
		    const regex = /^[A-Za-z0-9]{4,30}$/;
		    const checkPwdResult = document.getElementById('checkPwdResult');
		    
		    if (regex.test(pwd)) {
		    	confirmPwd();
		    } else {
		    	checkPwdResult.textContent = "특수문자 제외 4 ~ 30글자로 입력해줘";
		    	checkPwdResult.className = "invalid-feedback d-block";
		    	pwdPass = false;
		    	toggleSubmit();
		    }
		});
	
		//비밀번호와 비번확인이 동일한지 확인
		document.getElementById("checkPwd").addEventListener('input', confirmPwd);
		
		function confirmPwd(){
			let checkPwdResult = document.getElementById('checkPwdResult');
			let checkPwd = document.getElementById('checkPwd').value;
			let userPwd = document.getElementById('userPwd').value;
			
			if(checkPwd == ""){
				if(userPwd == ""){
					checkPwdResult.innerHTML = "비밀번호를 입력해주세요.";
					checkPwdResult.className = "form-text text-muted mt-1";
					pwdPass = false;
				}else{
					checkPwdResult.innerHTML = "사용 가능한 비밀번호입니다.";
					checkPwdResult.className = "valid-feedback d-block";
					pwdPass = false;
				}
			}else if(checkPwd == userPwd){
				checkPwdResult.innerHTML = "합격!";
				checkPwdResult.className = "valid-feedback d-block";
				pwdPass = true;
			}else{
				checkPwdResult.innerHTML = "비밀번호가 일치하지 않습니다";
				checkPwdResult.className = "invalid-feedback d-block";
				pwdPass = false;
			}
			toggleSubmit();
		};
		
		//닉네임 검증
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
			toggleSubmit();
		});
		
		//전화번호 검증 - 숫자제한 및 자동넘어가기
		document.querySelectorAll('.phone-part').forEach((input, idx) => {
		    input.addEventListener('input', function() {
		        this.value = this.value.replace(/[^0-9]/g, '');
		        if (this.value.length === this.maxLength) {
		        	let next = this.parentElement.querySelectorAll('.phone-part')[idx + 1];
		            if (next) next.focus();
		        }
		        validatePhone();
		    });
		});
		
		//전화번호 검증 - 숫자 개수 검사
		function validatePhone() {
			let phone1 = document.getElementById('phone1').value;
			let phone2 = document.getElementById('phone2').value;
			let phone3 = document.getElementById('phone3').value;
			let checkPhoneResult = document.getElementById("checkPhoneResult");
		
			if(phone1=="" && phone2=="" && phone3==""){
				checkPhoneResult.textContent = "";
		        checkPhoneResult.classList.remove('d-block');
		        phonePass = true;
		        toggleSubmit();
			}else if (!/^\d{3}$/.test(phone1) || !/^\d{3,4}$/.test(phone2) || !/^\d{4}$/.test(phone3)) {
		        checkPhoneResult.textContent = "올바른 형식으로 입력해주세요 (예: 010-1234-5678)";
		        checkPhoneResult.classList.add('d-block');
		        phonePass = false;
		    } else {
		        checkPhoneResult.textContent = "";
		        checkPhoneResult.classList.remove('d-block');
		        phonePass = true;
		    }
		    toggleSubmit();
		}
		
		//리셋 버튼과 확인을 누르면 리셋됨
		document.getElementById("insertReset").addEventListener('click', function(){
			if(confirm("진짜?")){
				document.getElementById("insertForm").reset();
				idPass = false;
				pwdPass = false;
				namePass = false;
				phonePass = true;
				
				document.getElementById('checkIdResult').className = "form-text text-muted mt-1";
				document.getElementById('checkIdResult').textContent = "아이디를 입력해주세요.";
				document.getElementById('checkPwdResult').className = "form-text text-muted mt-1";
				document.getElementById('checkPwdResult').textContent = "비밀번호를 입력해주세요.";
				document.getElementById('checkNameResult').className = "form-text text-muted mt-1";
				document.getElementById('checkNameResult').textContent = "이름을 입력해주세요.";
				document.getElementById('checkPhoneResult').className = "form-text text-muted mt-1";
				document.getElementById('checkPhoneResult').textContent = "번호를 입력해주세요.";
				document.getElementById("finalResult").className = "alert alert-light text-center mb-4";
				document.getElementById("finalResult").innerHTML = "모든 필수 항목을 입력하세요";
				toggleSubmit();
			}
		});
		
		
		//가입하기 버튼 누르면 로딩표시 및 전화번호 합치기
		$(document).ready(function() {
		    $('#insertForm').submit(function(e) {
		        e.preventDefault();
		        if ($(this).data('submitting')) return;
		        $(this).data('submitting', true);
		        
		        let phone = document.getElementById('phone1').value+"-"
	       			+document.getElementById('phone2').value+"-"
	       			+document.getElementById('phone3').value;
		        
		        document.getElementById('phone').value=phone;
		        
		        setButtonState('loading');
		        this.submit();
		    });
		});
		
		
		let toggolePassed = false;
		function toggleSubmit(){
			
			if(idPass && pwdPass && namePass && phonePass){
				setButtonState('active');
				toggolePassed = true;
				
			}else if(toggolePassed == true){
				//idPass && pwdPass && namePass조건을 통과해 함수가 종료되었는데
				//그 이후 toggleSubmit()함수가 다시 실행될 경우 건들인 값 초기화
				setButtonState('disabled');
				toggolePassed = false;
			}
		};
		
		//가입하기 버튼 핸들러
		function setButtonState(state) {
			let insertSubmit = document.getElementById("insertSubmit");
			let checkfinalResult = document.getElementById("finalResult");
		    let $btn = $('#insertSubmit');
		    
		    switch(state) {
		        case 'loading':
					insertSubmit.classList.remove("btn-secondary");
					insertSubmit.classList.add("btn-primary");
					
					checkfinalResult.innerHTML = "잠시 기다려 주세요";
					checkfinalResult.className = "alert alert-success text-center mb-4 loading";
					$btn.prop('disabled', true)
		               .html(`<span class="spinner-border spinner-border-sm" role="status"></span> 처리 중...`);
		            break;
		        case 'disabled':
					insertSubmit.classList.remove("btn-primary");
					insertSubmit.classList.add("btn-secondary");
					
					checkfinalResult.innerHTML = "모든 필수 항목을 확인해 주세요";
					checkfinalResult.className = "alert alert-warning text-center mb-4";
		        	
		            $btn.prop('disabled', true).text('가입하기');
		            
		            break;
		        case 'active':
					insertSubmit.classList.remove("btn-secondary");
					insertSubmit.classList.add("btn-primary");
					
					checkfinalResult.innerHTML = "좋아요!";
					checkfinalResult.className = "alert alert-success text-center mb-4";
					
		            $btn.prop('disabled', false).text('가입하기');
		    }
		}
		
		
	</script>
</body>
</html>