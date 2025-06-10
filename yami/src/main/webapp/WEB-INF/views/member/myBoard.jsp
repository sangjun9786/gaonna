<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>나의 게시글</title>
</head>
<body>
<%@include file="/WEB-INF/views/common/header.jsp"%>

<div class="container py-5">
  <div class="row justify-content-center">
    <div class="col-md-11 col-lg-10">
      <div class="card shadow-lg mb-4">
        <div class="card-header bg-primary text-white">
          <h4 class="mb-0"><i class="bi bi-pencil-square me-2"></i>나의 게시글</h4>
        </div>
        <div class="card-body">
          <form id="searchForm" class="row g-3 align-items-center" autocomplete="off">
            <div class="col-md-3">
              <select class="form-select" id="searchType1" name="searchType" required>
                <option value="boardAll">전체 판매 게시판</option>
                <!-- AJAX로 카테고리 옵션 추가 -->
                <option value="question">질문게시판</option>
                <option value="report">신고게시판</option>
              </select>
            </div>
            <div class="col-md-2">
              <select class="form-select" id="searchType2" name="searchType" required>
                <option value="all">전체</option>
                <option value="title">제목</option>
                <option value="content">내용</option>
              </select>
            </div>
            <div class="col-md-3">
              <input type="text" class="form-control" id="searchKeyword" name="searchKeyword" placeholder="검색어를 입력해주세요"/>
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
                <i class="bi bi-search"></i> 검색
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

  // 게시글 검색 및 렌더링
  async function searchBoard(){
    const params = $('#searchForm').serialize();

    try {
      // 게시글 수 조회
      const totalCount = await $.ajax({
        url: '${root}/countMyBoard.co',
        method: 'POST',
        data: params,
        dataType: 'json'
      });
      $('#resultCount').val(totalCount);
      $('#boardResultCount .fw-bold').text(totalCount);

      // 게시글 리스트 조회
      const boardList = await $.ajax({
        url: '${root}/searchMyBoard.co',
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

    $.each(boardList, function(idx, board){
      // 제목 10글자, 내용 30글자 제한
      let title = board.productTitle.length > 10 ? board.productTitle.substring(0,10) + '...' : board.productTitle;
      let content = board.productContent.length > 30 ? board.productContent.substring(0,30) + '...' : board.productContent;

      // 카드 HTML
      let cardHtml = `
        <div class="col">
          <div class="card h-100 shadow-sm position-relative">
            <div class="card-body">
              <div class="d-flex justify-content-between align-items-center mb-2">
                <h5 class="card-title mb-0 text-truncate" style="max-width: 70%;">${title}</h5>
                <span class="badge bg-secondary ms-2">${board.price.toLocaleString()}원</span>
              </div>
              <p class="card-text text-truncate" style="max-width: 100%;">${content}</p>
            </div>
            <div class="card-footer small text-muted d-flex justify-content-between align-items-center">
              <span>${board.categoryName}</span>
              <span>${board.uploadDate}</span>
              <span class="ms-2">${board.status}</span>
            </div>
            <a href="${root}/board.pro?productNo=${board.productNo}" class="stretched-link"></a>
          </div>
        </div>
      `;
      $boardList.append(cardHtml);
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
        <li class="page-item ${i === currentPage ? 'active' : ''}">
          <a class="page-link" href="#" data-page="${i}">${i}</a>
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
