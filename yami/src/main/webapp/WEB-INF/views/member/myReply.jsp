<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>나의 리플</title>
</head>
<body>
<%@include file="/WEB-INF/views/common/header.jsp"%>

<div class="container py-5">
  <div class="row justify-content-center">
    <div class="col-md-11 col-lg-10">
      <div class="card shadow-lg mb-4">
        <div class="card-header bg-primary text-white">
          <h4 class="mb-0"><i class="bi bi-pencil-square me-2"></i>나의 댓글</h4>
        </div>
        <div class="card-body">
          <form id="searchForm" class="row g-3 align-items-center" autocomplete="off">
            <div class="col-md-3">
              <select class="form-select" id="searchType1" name="searchType" required>
                <option value="boardAll">전체 판매 게시판</option>
                <!-- AJAX로 카테고리 옵션 추가됨 -->
              </select>
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
            <input type="hidden" id="resultCount" name="resultCount">
            <div class="col-md-2">
              <button type="submit" class="btn btn-success w-100" id="searchBoard">
                <i class="bi bi-search"></i> 조회하기
              </button>
            </div>
          </form>
        </div>
      </div>

      <div class="mb-3 text-end text-secondary small">
        <span id="boardResultCount">검색결과 <span class="fw-bold">0</span>건</span>
      </div>

      <!-- 게시글 카드 리스트 -->
      <div id="boardList" class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4 mb-4">
        <!-- JS로 카드 동적 생성 -->
        <div class="col">
          <div class="alert alert-info mb-0">검색 결과가 이곳에 표시됩니다.</div>
        </div>
      </div>

      <!-- 페이지네이션 -->
      <nav id="paginationNav" class="mt-4 d-flex justify-content-center"></nav>
    </div>
  </div>
</div>

<script>
$(function(){
  // 카테고리 옵션 동적 추가
  $.ajax({
    url: '${root}/selectCategory.co',
    method: 'POST',
    dataType: "json",
    success: function(result) {
      let $questionOption = $('#searchType1 option[value="question"]');
      $.each(result, function(idx, category){
        $('<option>', {
          value: category.categoryNo,
          text: category.categoryName
        }).insertBefore($questionOption);
      });
    },
    error: function() {
      alert('카테고리 정보를 불러오지 못했습니다.');
    }
  });

  // 검색 폼 제출
  $('#searchForm').on('submit', function(e){
    e.preventDefault();
    $('#page').val(1); // 검색시 항상 첫페이지
    searchBoard();
  });

  // 페이지네이션 클릭
  $('#paginationNav').on('click', '.page-link', function(e){
    e.preventDefault();
    const page = $(this).data('page');
    $('#page').val(page);
    searchBoard();
  });

  // 댓글 검색 및 렌더링
  async function searchBoard(){
    const params = $('#searchForm').serialize();

    try {
      // 댓글 수 조회
      const totalCount = await $.ajax({
        url: '${root}/countMyReply.co',
        method: 'POST',
        data: params,
        dataType: 'json'
      });
      $('#resultCount').val(totalCount);
      $('#boardResultCount .fw-bold').text(totalCount);

      // 댓글 리스트 조회
      const boardList = await $.ajax({
        url: '${root}/searchMyReply.co',
        method: 'POST',
        data: params,
        dataType: "json"
      });

      const page = parseInt($('#page').val());
      const pageSize = parseInt($('#searchCount').val());

      renderBoardList(boardList, totalCount);
      renderPagination(totalCount, page, pageSize);

    } catch(error) {
      $('#boardList').html('<div class="col"><div class="alert alert-danger">데이터 조회 실패</div></div>');
    }
  }

  // 게시글 카드 렌더링
  function renderBoardList(boardList, totalCount){
    let $boardList = $('#boardList');
    $boardList.empty();

    if(!boardList || boardList.length === 0){
      $boardList.html('<div class="col"><div class="alert alert-warning mb-0">검색 결과가 없습니다.</div></div>');
      return;
    }

    $.each(boardList, function(idx, reply){
      <%-- 동적으로 댓글 카드 생성하기 --%>
    });
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
  searchBoard();
});
</script>
</body>
</html>
