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
          <td>\${m.userNo}</td>
          <td>\${m.userId}</td>
          <td>\${m.userName}</td>
          <td>\${m.phone ?? ''}</td>
          <td>\${m.point ?? 0}</td>
          <td>\${m.enrollDate ?? ''}</td>
          <td>\${m.modifyDate ?? ''}</td>
          <td>\${m.status ?? ''}</td>
          <td>\${m.roleType}</td>
          <td>
            <button type="button" class="btn btn-outline-success btn-sm coord-btn" 
              data-user-no="\${m.userNo}" data-main-coord="\${m.mainCoord}">동네</button>
          </td>
          <td>
            <button type="button" class="btn btn-outline-info btn-sm location-btn" 
              data-user-no="\${m.userNo}" data-main-location="\${m.mainLocation}">배송지</button>
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
});
</script>
</body>
</html>
