<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>우리동네 설정</title>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.1/font/bootstrap-icons.css">
	<style>
	.title-orange { color: #ff6b35; }
	.dongne-card { transition: all 0.3s ease; }
	.dongne-card:hover { transform: translateY(-5px); }
	.main-dongne { border: 2px solid #ff6b35; background-color: #fff3e8; }
	.bi-trash:hover { color: #dc3545 !important; }
	</style>
</head>

<body class="bg-light">
<%@include file="/WEB-INF/views/common/header.jsp"%>
	
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-10 col-lg-8">
            <!-- 헤더 섹션 -->
            <div class="text-center mb-5">
                <h1 class="title-orange fw-bold mb-3">
                    <i class="bi bi-geo-alt-fill"></i> 우리동네 설정
                </h1>
                <p class="lead text-muted">우리동네를 설정하고 이웃 물건을 살펴봐요</p>
            </div>

            <!-- 동네 목록 카드 -->
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-warning text-white">
                    <h4 class="mb-0">
                        <i class="bi bi-house-door me-2"></i> 등록된 동네 목록
                    </h4>
                </div>
                
                <div class="card-body">
                    <c:choose>
                        <c:when test="${empty sessionScope.coords}">
                            <div class="alert alert-warning text-center">
                                <i class="bi bi-exclamation-circle me-2"></i>등록된 동네가 없습니다
                            </div>
                        </c:when>
                        
                        <c:otherwise>
                            <div class="row g-4">
                                <c:forEach var="coord" items="${sessionScope.coords}">
                                    <div class="col-12">
                                        <div class="card dongne-card ${coord.coordNo == loginUser.mainCoord ? 'main-dongne' : ''}">
                                            <div class="card-body">
                                                <div class="d-flex justify-content-between align-items-start">
                                                    <div>
                                                        <h5 class="card-title">
                                                            <i class="bi bi-geo me-1"></i>
                                                            ${coord.coordAddress}
                                                        </h5>
                                                        <p class="text-muted mb-0">
                                                            <small>
                                                                <i class="bi bi-calendar me-1"></i>
                                                                <fmt:formatDate value="${coord.coordDate}" pattern="yyyy.MM.dd 추가"/>
                                                            </small>
                                                        </p>
                                                    </div>
                                                    
                                                    <!-- 액션 버튼 그룹 -->
                                                    <div class="btn-group">
                                                        <c:if test="${coord.coordNo == loginUser.mainCoord}">
                                                            <span class="badge bg-warning me-2">
                                                                <i class="bi bi-star-fill"></i> 대표동네
                                                            </span>
                                                        </c:if>
                                                        
                                                        <!-- 삭제 버튼 클릭시 삭제요청 -->
                                                        <form id="deleteForm_${coord.coordNo}" action="deleteCoord.me" method="post">
														    <input type="hidden" name="coordNo" value="${coord.coordNo}">
														</form>
														<!-- 삭제 모달창 띄우기 -->
														<button type="button" class="btn btn-link text-danger p-0" 
														        data-bs-toggle="modal" 
														        data-bs-target="#deleteModal"
														        data-form-id="deleteForm_${coord.coordNo}">
														    <i class="bi bi-trash fs-5"></i>
														</button>
                                                        
                                                        <c:if test="${coord.coordNo != loginUser.mainCoord}">
                                                        	<!-- 변경 버튼 클릭시 변경요청 -->
                                                            <form id="updateForm_${coord.coordNo}" action="updateMainCoord.me" method="post">
															    <input type="hidden" name="coordNo" value="${coord.coordNo}">
															</form>
															<!-- 별 버튼 -->
															<button type="button" class="btn btn-link text-warning p-0" 
															        onclick="document.getElementById('updateForm_${coord.coordNo}').submit()">
															    <i class="bi bi-star fs-5"></i>
															</button>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- 동네 추가 섹션 -->
            <div class="text-center mt-4">
                <button class="btn btn-warning btn-lg px-5" 
                        id="insertDongne"
                        data-bs-toggle="collapse" 
                        data-bs-target="#addButtons">
                    <i class="bi bi-plus-circle me-2"></i>현재 위치를 우리동네 추가하기
                </button>
                
                <!-- 숨겨진 액션 버튼 -->
                <div class="collapse mt-3" id="addButtons">
                    <div id="addForm" class="d-flex justify-content-center gap-2">
                    
                    <!-- 대표 동네가 없으면 그냥 동네 추가하기 버튼은 보이지 않음 -->
	                    <c:if test="${not empty loginUser.mainCoord && loginUser.mainCoord != 0}">
	                        <button type="button"
	                        	id="addNormal"
	                        	class="btn btn-outline-warning">
	                            <i class="bi bi-check-circle me-1"></i>추가하기
	                        </button>
	                    </c:if>
                        <button type="button"
                        		id="addMain"
                        		class="btn btn-outline-warning" 
						        data-bs-toggle="collapse" 
						        data-bs-target="#addButtons">
						    <i class="bi bi-star me-1"></i>대표 동네 추가하기
						</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 삭제 확인 모달 -->
<div class="modal fade" id="deleteModal" tabindex="-1">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-body">
				동네를 삭제하시겠습니까?
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
				<button type="button" class="btn btn-danger" 
				        onclick="deleteForm()">
					삭제
				</button>
			</div>
		</div>
	</div>
</div>

<!-- 대표 동네 설정 모달 -->
<div class="modal fade" id="setMainModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-warning text-white">
                <h5 class="modal-title">
                    <i class="bi bi-star me-2"></i>대표 동네 설정
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                이 동네를 대표 동네로 설정하시겠습니까?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-warning" onclick="setMainFrom()">설정</button>
            </div>
        </div >
    </div>
</div>

<script>
console.log(${loginUser.mainCoord});
    document.getElementById('addForm').addEventListener('click', function(e) {
    	//버튼만 이벤트 작동되도록
    	if (e.target.tagName !== 'BUTTON' 
    			&& e.target.closest('button') == null) {
    		return;
    	}
        let btn = e.target.closest('button');
        
        //좌표 개수 구해서 5보다 크면 더 이상 넣을 수 없습니다
        let coordsLength = 
        	${empty sessionScope.coords ? 0 : sessionScope.coords.size()};
        
        if (!navigator.geolocation) {
            showAlert('이 브라우저는 위치 서비스를 지원하지 않습니다', 'danger');
            return;
        }else if(coordsLength>=5){
        	showAlert('더 이상 우리동네를 추가할 수 없습니다.', 'danger');
            return;
        }
        
		//네 위치 내놔
        navigator.geolocation.getCurrentPosition(
            function(position) {
            	let latitude = position.coords.latitude;
            	let longitude = position.coords.longitude;
            	
            	//젤다 만들기
            	let link = "${root}/insertDongne.me?isMain=";
                if(btn.id =="addMain"){
                	link += 'Y';
                }else if(btn.id =="addNormal"){
                	link += 'N';
                }
            	
		        //중복된 위치라면 못 넣는다.
		        //checkDongne.me로 ajax요청
            	$.ajax({
			      url: "checkDongne.me",
			      data: {latitude : latitude
			    	  , longitude : longitude},
			      success: function(result) {
					if(result == "pass"){
						//중복검사 통과하면 
						location.href = link;
					}else if(result == 'noPass'){
						showAlert('이미 등록된 동네입니다.', 'danger');
					}else{
						showAlert('500 err', 'danger');
					}
			      },
			      error: function(){
			    	  showAlert('서버와 통신할 수 없습니다.', 'danger');
			      }
		      });
            },
            function(error) {
                let message = '위치 권한을 허용해주세요';
                if(error.code === error.PERMISSION_DENIED) {
                    message = '위치 접근 권한이 거부되었습니다';
                }
                showAlert(message, 'warning');
            }
        );
    });

    // 취소 버튼
    document.querySelectorAll('.btn-outline-secondary[data-bs-toggle="collapse"]').forEach(function(btn){
        btn.addEventListener('click', function(){
            let target = document.querySelector(this.getAttribute('data-bs-target'));
            let bsCollapse = bootstrap.Collapse.getOrCreateInstance(target);
            bsCollapse.hide();
        });
    });

    //뭔가 이상하면 보여주는 버튼
    function showAlert(message, type) {
        const alert = document.createElement('div');
        alert.className = `alert alert-\${type} alert-dismissible fade show mt-3`;
        alert.innerHTML = `
            <i class="bi bi-exclamation-circle me-2"></i>
            \${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;
        document.querySelector('#addButtons').after(alert);
    }

    //동네 삭제
    $('#deleteModal').on('show.bs.modal', function(event) {
        const button = $(event.relatedTarget); // 클릭한 삭제 버튼
        const formId = button.data('form-id'); // data-form-id 값 추출
        $(this).data('form-id', formId); // 모달에 폼 ID 저장
    });
    function deleteForm() {
        const formId = $('#deleteModal').data('form-id');
        if (formId) {
            document.getElementById(formId).submit();
        }
    }
    
    //대표동네 설정
    function setMainFrom(){
    	let formId = $('#setMainModal').data('form-id');
    	if(formId) {
    	    document.getElementById(formId).submit();
    	}
    }
    
</script>
</body>
</html>
