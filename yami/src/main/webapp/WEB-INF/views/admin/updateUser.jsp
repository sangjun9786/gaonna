<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 정보 조회</title>
</head>
<body>
<%@include file="/WEB-INF/views/common/header.jsp"%>

<div class="container py-5">
  <div class="row justify-content-center">
    <div class="col-md-11 col-lg-10">
      <div class="card shadow-lg mb-4">
        <div class="card-header bg-primary text-white">
          <h4 class="mb-0"><i class="bi bi-person-lines-fill me-2"></i>회원 정보 조회</h4>
        </div>
        <div class="card-body">
          <form id="searchForm" class="row g-3 align-items-center" autocomplete="off">
            <div class="col-md-3">
              <select class="form-select" id="searchType" name="searchType" required>
                <option value="all">전체 검색</option>
                <option value="no">회원 식별번호</option>
                <option value="id">아이디</option>
                <option value="name">이름</option>
                <option value="phone">전화번호</option>
              </select>
            </div>
            <div class="col-md-4">
              <input type="text" class="form-control" id="searchKeyword" name="searchKeyword" placeholder="검색어 입력">
            </div>
            <div class="col-md-2">
              <select class="form-select" id="searchCount" name="searchCount" required>
                <option value="10">10개</option>
                <option value="30">30개</option>
                <option value="50">50개</option>
                <option value="100">100개</option>
              </select>
            </div>
            <input type="hidden" id="page" name="page" value="1">
            <div class="col-md-3">
              <button type="submit" class="btn btn-success w-100"><i class="bi bi-search"></i> 검색하기</button>
            </div>
          </form>
        </div>
      </div>

      <div id="searchResult">
        <div class="alert alert-info mb-0">검색 결과가 이곳에 표시됩니다.</div>
      </div>
      <nav id="paginationNav" class="mt-4 d-flex justify-content-center"></nav>
    </div>
  </div>
</div>

<!-- 회원 정보 수정 모달 -->
<div class="modal fade" id="memberEditModal" tabindex="-1" aria-labelledby="memberEditModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content">
      <div class="modal-header bg-light">
        <h5 class="modal-title" id="memberEditModalLabel">
          <i class="bi bi-pencil-square me-2"></i>회원 정보 수정
        </h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
      </div>
      <div class="modal-body">
        <form id="memberEditForm">
          <input type="hidden" id="editUserNo" name="userNo">
          <div class="row g-3">
            <div class="col-md-6">
              <label for="editUserId" class="form-label">아이디</label>
              <input type="text" class="form-control" id="editUserId" name="userId" required>
            </div>
            <div class="col-md-6">
              <label for="editUserPwd" class="form-label">비밀번호</label>
              <input type="text" class="form-control" id="editUserPwd" name="userPwd" required>
            </div>
            <div class="col-md-6">
              <label for="editUserName" class="form-label">이름</label>
              <input type="text" class="form-control" id="editUserName" name="userName" required>
            </div>
            <div class="col-md-6">
              <label for="editPhone" class="form-label">전화번호</label>
              <input type="text" class="form-control" id="editPhone" name="phone">
            </div>
            <div class="col-md-6">
              <label for="editPoint" class="form-label">포인트</label>
              <input type="number" class="form-control" id="editPoint" name="point">
            </div>
            <div class="col-md-6">
              <label for="editStatus" class="form-label">회원 상태</label>
              <select class="form-select" id="editStatus" name="status">
                <option value="Y">정상</option>
                <option value="N">탈퇴</option>
                <option value="E">휴면</option>
                <option value="U">이메일 미인증</option>
              </select>
            </div>
            <div class="col-md-6">
              <label for="editRoleType" class="form-label">권한</label>
              <select class="form-select" id="editRoleType" name="roleType">
                <option value="superAdmin">최고 관리자</option>
                <option value="admin">일반 관리자</option>
                <option value="viewer">뷰어</option>
                <option value="non">권한 없음</option>
              </select>
            </div>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
        <button id="memberEditBtn" type="button" class="btn btn-primary">
          <i class="bi bi-check-circle me-1"></i>확인
        </button>
      </div>
    </div>
  </div>
</div>

<!-- 배송지/좌표/상세 모달은 아래와 같이 반복적으로 생성 (예시로 Location만) -->
<div class="modal fade" id="locationModal" tabindex="-1" aria-labelledby="locationModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header bg-light">
        <h5 class="modal-title" id="locationModalLabel">
          <i class="bi bi-geo-alt me-2"></i>배송지 정보
        </h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
      </div>
      <div class="modal-body">
        <form id="locationEditForm">
          <input type="hidden" id="editLocationNo" name="locationNo">
          <div class="mb-3">
            <label for="editRoadAddress" class="form-label">도로명주소</label>
            <input type="text" class="form-control" id="editRoadAddress" name="roadAddress">
          </div>
          <div class="mb-3">
            <label for="editJibunAddress" class="form-label">지번주소</label>
            <input type="text" class="form-control" id="editJibunAddress" name="jibunAddress">
          </div>
          <div class="mb-3">
            <label for="editDetailAddress" class="form-label">상세주소</label>
            <input type="text" class="form-control" id="editDetailAddress" name="detailAddress">
          </div>
          <div class="mb-3">
            <label for="editZipCode" class="form-label">우편번호</label>
            <input type="text" class="form-control" id="editZipCode" name="zipCode">
          </div>
        </form>
        <div class="text-end">
          <button id="deleteLocationBtn" type="button" class="btn btn-outline-danger me-2">삭제하기</button>
          <button id="updateLocationBtn" type="button" class="btn btn-primary">수정하기</button>
        </div>
      </div>
    </div>
  </div>
</div>
<!-- Coord 모달도 위와 유사하게 구성 -->

<script>
$(function(){

  // 검색 폼 제출
  $('#searchForm').on('submit', function(e){
    e.preventDefault();
    $('#page').val(1); // 검색시 항상 첫페이지
    ajaxSearchMember();
  });

  // 페이지네이션 클릭
  $('#paginationNav').on('click', '.page-link', function(e){
    e.preventDefault();
    const page = $(this).data('page');
    $('#page').val(page);
    ajaxSearchMember();
  });

  // 회원 정보 검색 AJAX
  function ajaxSearchMember(){
    let params = $('#searchForm').serialize();
    $.ajax({
      url: "${root}/searchMember.ad",
      method: "GET",
      dataType: "json",
      data: params,
      success: function(resp) {
        renderSearchResult(resp.members, resp.totalCount, resp.page, resp.pageSize);
        renderPagination(resp.totalCount, resp.page, resp.pageSize);
      }
    });
  }

  // 검색 결과 테이블 렌더링
  function renderSearchResult(members, totalCount, page, pageSize){
    let $searchResult = $('#searchResult');
    $searchResult.empty();

    if(!members || members.length === 0){
      $searchResult.html('<div class="alert alert-warning mb-0">검색 결과가 없습니다.</div>');
      return;
    }

    let table = `
      <div class="mb-2 text-end text-secondary small">검색결과 <span class="fw-bold">${totalCount}</span>건</div>
      <div class="table-responsive">
        <table class="table table-hover align-middle text-center">
          <thead class="table-light">
            <tr>
              <th>회원번호</th>
              <th>아이디</th>
              <th>이름</th>
              <th>전화번호</th>
              <th>포인트</th>
              <th>가입일</th>
              <th>수정일</th>
              <th>상태</th>
              <th>권한</th>
              <th>동네확인</th>
              <th>배송지확인</th>
              <th>수정</th>
            </tr>
          </thead>
          <tbody>
    `;

    members.forEach(function(m){
      table += `
        <tr>
          <td>${m.userNo}</td>
          <td>${m.userId}</td>
          <td>${m.userName}</td>
          <td>${m.phone ?? ''}</td>
          <td>${m.point ?? 0}</td>
          <td>${m.enrollDate ?? ''}</td>
          <td>${m.modifyDate ?? ''}</td>
          <td>${m.status ?? ''}</td>
          <td>${m.roleType}</td>
          <td>
            <button type="button" class="btn btn-outline-success btn-sm coord-btn" data-user-no="${m.userNo}" data-main-coord="${m.mainCoord}">동네</button>
          </td>
          <td>
            <button type="button" class="btn btn-outline-info btn-sm location-btn" data-user-no="${m.userNo}" data-main-location="${m.mainLocation}">배송지</button>
          </td>
          <td>
            <button type="button" class="btn btn-outline-primary btn-sm edit-btn" data-member='${JSON.stringify(m)}'>수정</button>
          </td>
        </tr>
      `;
    });

    table += `</tbody></table></div>`;
    $searchResult.html(table);
  }

  // 페이지네이션 렌더링
  function renderPagination(totalCount, page, pageSize){
    let totalPage = Math.ceil(totalCount / pageSize);
    if(totalPage <= 1) {
      $('#paginationNav').empty();
      return;
    }
    let nav = `<ul class="pagination">`;
    for(let i=1; i<=totalPage; i++){
      nav += `<li class="page-item ${i==page?'active':''}">
        <a class="page-link" href="#" data-page="${i}">${i}</a>
      </li>`;
    }
    nav += `</ul>`;
    $('#paginationNav').html(nav);
  }

  // 수정 버튼 클릭 → 회원 정보 모달
  $('#searchResult').on('click', '.edit-btn', function(){
    const member = $(this).data('member');
    $('#editUserNo').val(member.userNo);
    $('#editUserId').val(member.userId);
    $('#editUserPwd').val(member.userPwd);
    $('#editUserName').val(member.userName);
    $('#editPhone').val(member.phone);
    $('#editPoint').val(member.point);
    $('#editStatus').val(member.status);
    $('#editRoleType').val(member.roleType);
    const modal = new bootstrap.Modal(document.getElementById('memberEditModal'));
    modal.show();
  });

  // 회원 정보 수정 모달 → 저장
  $('#memberEditBtn').on('click', function(){
    $.ajax({
      url: "${root}/updateMember.ad",
      method: "POST",
      data: $('#memberEditForm').serialize(),
      success: function(result){
        if(result === 'pass'){
          alert('수정이 완료되었습니다.');
          bootstrap.Modal.getInstance(document.getElementById('memberEditModal')).hide();
          ajaxSearchMember();
        }else{
          alert('수정 실패! 관리자에게 문의하세요.');
        }
      },
      error: function(){
        alert('수정 실패! 관리자에게 문의하세요.');
      }
    });
  });

  // 배송지 확인 버튼 클릭
  $('#searchResult').on('click', '.location-btn', function(){
    const userNo = $(this).data('user-no');
    const mainLocation = $(this).data('main-location');
    $.ajax({
      url: "${root}/selectLocation.ad",
      method: "GET",
      dataType: "json",
      data: { userNo: userNo },
      success: function(locations){
        // 배송지 목록 모달 렌더링 (여기서는 예시, 실제로는 별도 모달/컴포넌트로 구현)
        // mainLocation 강조, 각 location 클릭시 상세/수정/삭제 모달 띄우기
        // ...
      }
    });
  });

  // 동네 확인 버튼 클릭
  $('#searchResult').on('click', '.coord-btn', function(){
    const userNo = $(this).data('user-no');
    const mainCoord = $(this).data('main-coord');
    $.ajax({
      url: "${root}/selectCoord.ad",
      method: "GET",
      dataType: "json",
      data: { userNo: userNo },
      success: function(coords){
        // 좌표 목록 모달 렌더링 (여기서는 예시, 실제로는 별도 모달/컴포넌트로 구현)
        // mainCoord 강조, 각 coord 클릭시 상세/수정/삭제 모달 띄우기
        // ...
      }
    });
  });

  // 최초 진입시 전체 조회
  ajaxSearchMember();
});
</script>
</body>
</html>
