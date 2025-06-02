<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>배송지 설정</title>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.1/font/bootstrap-icons.css">
	<style>
	.title-orange { color: #ff6b35; }
	.dongne-card:hover { transform: translateY(-5px); }
	.main-dongne { border: 2px solid #ff6b35; background-color: #fff3e8; }
	.bi-trash:hover { color: #dc3545 !important; }
	  .dongne-card {
    margin-bottom: 0 !important;
  }
  .card-body {
    padding: 0.75rem !important;
  }
  .row.g-2 {
    --bs-gutter-x: 0.5rem;
    --bs-gutter-y: 0.5rem;
  }
	</style>
</head>

<%@include file="/WEB-INF/views/common/header.jsp"%>
<body>

<div class="container py-3">

  <!-- 상단 타이틀 & 버튼 -->
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h4 class="mb-0 fw-bold">
      <i class="bi bi-geo-alt-fill me-2 text-primary"></i>배송지 설정
    </h4>
    <a href="insertLocationForm.me" class="btn btn-primary">
      <i class="bi bi-plus-lg me-1"></i>배송지 추가하기
    </a>
  </div>

  <!-- 주소 카드 2열 배치 -->
  <div class="row row-cols-1 row-cols-md-2 g-2">
    <c:forEach var="location" items="${sessionScope.location}" varStatus="status">
      <c:if test="${status.index < 5}">
        <div class="col">
          <div class="card dongne-card ${location.locationNo == loginUser.mainLocation ? 'main-dongne' : ''} h-100">
            <div class="card-body p-2">
              <div class="fw-semibold text-secondary mb-1">
                <i class="bi bi-geo-alt-fill me-1 text-primary"></i>
                배송지 정보
                <span class="badge bg-light text-dark border border-primary ms-2">
                  우편번호 ${location.zipCode}
                </span>
              </div>
              <div class="small text-body mb-2">
                <div><span class="fw-semibold text-dark">도로명</span> : ${location.roadAddress}</div>
                <div><span class="fw-semibold text-dark">지번</span> : ${location.jibunAddress}</div>
                <div><span class="fw-semibold text-dark">상세</span> : ${location.detailAddress}</div>
              </div>
              <div class="d-flex justify-content-between align-items-center mt-2">
                <small class="text-muted">
                  <i class="bi bi-calendar me-1"></i>
                  <fmt:formatDate value="${location.locationDate}" pattern="yyyy.MM.dd 추가"/>
                </small>
                <div>
                  <!-- 삭제 버튼 -->
                  <form id="deleteForm_${location.locationNo}" action="deleteLocation.me" method="post" class="d-inline">
                    <input type="hidden" name="locationNo" value="${location.locationNo}">
                  </form>
                  <button type="button" class="btn btn-link text-danger p-0 me-1"
                          data-bs-toggle="modal"
                          data-bs-target="#deleteModal"
                          data-form-id="deleteForm_${location.locationNo}">
                    <i class="bi bi-trash fs-5"></i>
                  </button>
                  <!-- 별(대표) 버튼 -->
                  <c:choose>
                    <c:when test="${location.locationNo == loginUser.mainLocation}">
                      <span class="text-warning"><i class="bi bi-star-fill fs-5"></i></span>
                    </c:when>
                    <c:otherwise>
                      <form id="updateForm_${location.locationNo}" action="updateMainlocation.me" method="post" class="d-inline">
                        <input type="hidden" name="locationNo" value="${location.locationNo}">
                      </form>
                      <button type="button" class="btn btn-link text-warning p-0"
                              onclick="document.getElementById('updateForm_${location.locationNo}').submit()">
                        <i class="bi bi-star fs-5"></i>
                      </button>
                    </c:otherwise>
                  </c:choose>
                </div>
              </div>
            </div>
          </div>
        </div>
      </c:if>
    </c:forEach>
  </div>
</div>

<!-- 삭제 모달 예시 (필요시) -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="deleteModalLabel">주소 삭제</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
      </div>
      <div class="modal-body">
        정말 이 주소를 삭제하시겠습니까?
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
        <button type="button" class="btn btn-danger" id="confirmDeleteBtn">삭제</button>
      </div>
    </div>
  </div>
</div>

<script>
// 삭제 모달에서 폼 제출
let formIdToDelete = null;
	document.querySelectorAll('button[data-form-id]').forEach(btn => {
	btn.addEventListener('click', function() {
		formIdToDelete = this.getAttribute('data-form-id');
	});
});
document.getElementById('confirmDeleteBtn')?.addEventListener('click', function() {
	if (formIdToDelete) {
		document.getElementById(formIdToDelete).submit();
	}
});
</script>
</body>


</html>
