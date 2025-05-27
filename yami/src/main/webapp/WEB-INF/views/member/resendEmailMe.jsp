<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이메일 재발송</title>
<!-- lodash CDN만 추가 -->
<script src="https://cdn.jsdelivr.net/npm/lodash@4.17.21/lodash.min.js"></script>
</head>
<body class="bg-light">
    <%@include file="/WEB-INF/views/common/header.jsp" %>

    <div class="container mt-5">
        <div class="card shadow-lg mx-auto" style="max-width: 600px;">
            <div class="card-body text-center p-5">
                <h2 class="card-title mb-4">이메일 재발송 요청</h2>
                <div class="alert alert-info">
                    <strong>${sessionScope.resendEmailUser.userName}</strong>님,<br>
                    접속하신 링크는 만료되었습니다.<br>
                    <span class="text-primary">${sessionScope.resendEmailUser.userId}</span>로 다시 이메일을 보내시겠습니까?
                </div>
                
                <div class="d-grid gap-3">
                    <button id="resendEmail" class="btn btn-primary btn-lg">네!</button>
                    <button id="userIdFix" class="btn btn-outline-secondary btn-lg" data-bs-toggle="modal" data-bs-target="#emailModal">
                        이메일 주소 수정하기
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- 이메일 수정 모달 -->
    <div class="modal fade" id="emailModal" tabindex="-1" aria-labelledby="emailModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="emailModalLabel">이메일 주소 수정</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="emailUpdateForm">
                    <div class="modal-body">
                        <div class="row g-3">
                            <div class="col-6">
                                <input type="text" class="form-control" id="userId" 
                                    placeholder="아이디" required>
                            </div>
                            <div class="col-6">
                            	<input list="domain" name="domain" id="domainList" class="form-select" placeholder="도메인">
								<datalist id="domain">
									<option value="naver.com">naver.com</option>
									<option value="goole.com">google.com</option>
								</datalist>
                            </div>
                        </div>
                        <div id="checkIdResult" class="mt-2"></div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                        <button type="submit" class="btn btn-primary" id="insertSubmit" disabled>변경 저장</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // 이메일 재발송 처리
        document.getElementById('resendEmail').addEventListener('click', function() {
        	if(confirm("진짜??")){
	        	location.href = '${root}/resendEmail';
        	}
        });

		//검증이 true여야 sumbmit버튼 활성화됨
		let idPass = false;
		
		//아이디 검증
		document.getElementById("userId").addEventListener('input', function(){
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
            
            location.href("${root}/updateEmail?userId="+userId+"&domain"+domain);
        });
    </script>
</body>
</html>
