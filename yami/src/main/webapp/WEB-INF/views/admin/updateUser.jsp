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

<div class="modal fade" id="adminEditModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header bg-light">
        <h5 class="modal-title">
          <i class="bi bi-pencil-square me-2"></i>회원 정보 수정
        </h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <input type="hidden" id="editUserNo">
        <div class="mb-3">
          <label class="form-label">아이디</label>
          <input type="text" class="form-control" id="editUserId" required>
        </div>
        <div class="mb-3">
          <label class="form-label">이름</label>
          <input type="text" class="form-control" id="editUserName" required>
        </div>
        <div class="mb-3">
          <label class="form-label">전화번호</label>
          <input type="text" class="form-control" id="editPhone">
        </div>
        <div class="mb-3">
          <label class="form-label">포인트</label>
          <input type="number" class="form-control" id="editPoint">
        </div>
        <div class="mb-3">
          <label class="form-label">회원 상태</label>
          <select class="form-select" id="editStatus">
            <option value="Y">정상</option>
            <option value="N">탈퇴</option>
            <option value="E">휴면</option>
            <option value="U">이메일 미인증</option>
          </select>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
        <button id="confirmEdit" type="button" class="btn btn-primary">확인</button>
      </div>
    </div>
  </div>
</div>

<!-- 동네 정보 모달 -->
<div class="modal fade" id="coordModal">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header bg-primary text-white">
        <h5 class="modal-title"><i class="bi bi-geo-alt"></i> 등록된 동네</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body" id="coordModalBody">
        <div class="list-group"></div>
      </div>
    </div>
  </div>
</div>

<!-- 배송지 정보 모달 -->
<div class="modal fade" id="locationModal">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header bg-info text-white">
        <h5 class="modal-title"><i class="bi bi-truck"></i> 등록된 배송지</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body" id="locationModalBody">
        <div class="row g-3"></div>
      </div>
    </div>
  </div>
</div>

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

  // 회원 정보 검색 AJAX (totalCount 별도 요청, member 리스트만 반환)
  async function ajaxSearchMember(){
    const params = $('#searchForm').serialize();

    try {
      // 전체 회원 수 조회 (검색 조건 포함)
      const totalCount = await $.ajax({
        url: "${root}/countMember.ad",
        method: "GET",
        data: params,
        dataType: "json"
      });

      // 회원 목록 조회 (검색 조건 + 페이징)
      const members = await $.ajax({
        url: "${root}/searchMember.ad",
        method: "GET",
        data: params,
        dataType: "json"
      });

      const page = parseInt($('#page').val());
      const pageSize = parseInt($('#searchCount').val());

      renderSearchResult(members, totalCount);
      renderPagination(totalCount, page, pageSize);

    } catch(error) {
      console.error(error);
      $('#searchResult').html('<div class="alert alert-danger">데이터 조회 실패</div>');
    }
  }

  // 검색 결과 테이블 렌더링
  function renderSearchResult(members, totalCount){
    let $searchResult = $('#searchResult');
    $searchResult.empty();

    if(!members || members.length === 0){
      $searchResult.html('<div class="alert alert-warning mb-0">검색 결과가 없습니다.</div>');
      return;
    }

    let table = `
      <div class="mb-2 text-end text-secondary small">
        검색결과 <span class="fw-bold">\${totalCount}</span>건
      </div>
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
              <th>동네</th>
              <th>배송지</th>
              <th>수정</th>
            </tr>
          </thead>
          <tbody>
    `;

    members.forEach(function(m){
      table += `
        <tr>
          <td>\${m.userNo}</td>
          <td>\${m.userId}</td>
          <td>\${m.userName}</td>
          <td>\${m.phone ?? ''}</td>
          <td>\${m.point ?? 0}</td>
          <td>\${m.enrollDate ?? ''}</td>
          <td>\${m.modifyDate ?? ''}</td>
          <td>\${m.status ?? ''}</td>
          <td>
	          <button class="btn btn-outline-success btn-sm coord-btn" 
	        	  data-user-no="\${m.userNo}">동네</button>
          </td>
          <td>
	          <button class="btn btn-outline-info btn-sm location-btn" 
	        	  data-user-no="\${m.userNo}">배송지</button>
          </td>
          <td>
            <button type="button" class="btn btn-outline-primary btn-sm edit-btn" 
              data-member='\${JSON.stringify(m).replace(/'/g, "&apos;")}'>수정</button>
          </td>
        </tr>
      `;
    });

    table += `</tbody></table></div>`;
    $searchResult.html(table);
  }


  // 페이지네이션 렌더링
  function renderPagination(totalCount, currentPage, pageSize){
    const totalPage = Math.ceil(totalCount / pageSize);
    if(totalPage <= 1) {
      $('#paginationNav').empty();
      return;
    }
    let nav = `<ul class="pagination">`;
    for(let i=1; i<=totalPage; i++){
      nav += `
        <li class="page-item \${i === currentPage ? 'active' : ''}">
          <a class="page-link" href="#" data-page="\${i}">\${i}</a>
        </li>
      `;
    }
    nav += `</ul>`;
    $('#paginationNav').html(nav);
  }

  // 최초 진입시 전체 조회
  //ajaxSearchMember();
  
  //--------------------회원 정보 수정 모달---------------------------
  $('#searchResult').on('click', '.edit-btn', function() {
    const member = $(this).data('member');
    
    $('#editUserNo').val(member.userNo);
    $('#editUserId').val(member.userId);
    $('#editUserName').val(member.userName);
    $('#editPhone').val(member.phone);
    $('#editPoint').val(member.point);
    $('#editStatus').val(member.status);
    
    new bootstrap.Modal('#adminEditModal').show();
  });

  // 수정 확인 이벤트
  $('#confirmEdit').click(function() {
    const updateData = {
      userNo: $('#editUserNo').val(),
      userId: $('#editUserId').val(),
      userName: $('#editUserName').val(),
      phone: $('#editPhone').val(),
      point: $('#editPoint').val(),
      status: $('#editStatus').val()
    };

    $.ajax({
      url: '${root}/updateUser.ad',
      method: 'POST',
      contentType: 'application/json',
      data: JSON.stringify(updateData),
      success: function(response) {
        if(response === 'pass') {
          alert('수정 완료');
          $('#adminEditModal').modal('hide');
          ajaxSearchMember();
        }
      },
      error: function() {
        alert('수정 실패');
      }
    });
  });
  //--------------------동네 및 배송지----------------------------

	//동네 버튼 클릭 이벤트
	$('#searchResult').on('click', '.coord-btn', function() {
	  const userNo = $(this).data('user-no');
	  
	  $.ajax({
	    url: '${root}/userDongne.ad',
	    method: 'GET',
	    data: { userNo: userNo },
	    dataType: 'json',
	    success: function(response) {
	      console.log('서버 응답:', response); // 응답 데이터 구조 확인
	      if(response && Array.isArray(response)) {
	        renderCoordModal(response);
	      } else {
	        $('#coordModalBody').html('<div class="alert alert-danger">데이터 형식 오류</div>');
	      }
	    },
	    error: function(xhr) {
	      console.error('에러:', xhr.responseText);
	    }
	  });
	});

	// 배송지 버튼 클릭 이벤트
	$('#searchResult').on('click', '.location-btn', function() {
	  const userNo = $(this).data('user-no');
	  
	  $.ajax({
	      url: '${root}/userLocation.ad',
	      method: 'GET',
	      data: { userNo: userNo },
	      dataType: 'json',
	      success: function(response) {
	        if(response && Array.isArray(response)) {
	          renderLocationModal(response); // 함수명 변경
	        } else {
	          $('#locationModalBody').html('<div class="alert alert-danger">데이터 형식 오류</div>');
	        }
	      },
	      error: function(xhr) {
	        console.error('에러:', xhr.responseText);
	      }
	    });
	});


  // 동네 모달 렌더링
function renderCoordModal(coords) {
  const $body = $('#coordModalBody').empty();
  
  coords.forEach(coord => {
    $body.append(`
      <div class="list-group-item">
        <div class="row">
          <div class="col-md-8">
            <h6>\${coord.coordAddress}</h6>
            <small class="text-muted">
              위도: \${coord.latitude}<br>
              경도: \${coord.longitude}
            </small>
          </div>
          <div class="col-md-4 text-end">
            <small class="text-secondary">
              \${coord.coordDate}
            </small>
          </div>
        </div>
      </div>
    `);
  });
  new bootstrap.Modal(document.getElementById('coordModal')).show();
}

  // 배송지 모달 렌더링
function renderLocationModal(locations) {
  const $body = $('#locationModalBody').empty();
  
  locations.forEach(location => {
    $body.append(`
      <div class="mb-3">
        <div class="card h-100 border-primary">
          <div class="card-header bg-light">
            <i class="bi bi-geo-alt"></i> 
            NO.\${location.locationNo}
          </div>
          <div class="card-body">
            <h6 class="card-subtitle mb-2 text-muted">
              \${location.roadAddress}
            </h6>
            <ul class="list-unstyled small">
              <li>지번: \${location.jibunAddress}</li>
              <li>상세주소: \${location.detailAddress}</li>
              <li>우편번호: \${location.zipCode}</li>
            </ul>
          </div>
          <div class="card-footer text-end">
            <small class="text-secondary">
              \${location.locationDate}
            </small>
          </div>
        </div>
      </div>
    `);
  });
  new bootstrap.Modal(document.getElementById('locationModal')).show();
}
});
</script>
</body>
</html>
