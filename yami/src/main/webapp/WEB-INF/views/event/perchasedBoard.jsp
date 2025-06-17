<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>나의 게시글</title>
  <style>
    .clickable-status {
      cursor: pointer;
      text-decoration: underline;
      position: relative;
      z-index: 10;
    }
  </style>
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">   
<!-- jQuery library -->
<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.slim.min.js"></script>
<!-- Popper JS -->
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<%@include file="/WEB-INF/views/common/header.jsp"%>

<div class="container py-5">
  <div class="row justify-content-center">
    <div class="col-md-11 col-lg-10">
      <div class="card shadow-lg mb-4">
        <div class="card-header bg-primary text-white">
          <h4 class="mb-0"><i class="bi bi-pencil-square me-2"></i>내 구매 목록</h4>
        </div>
        <div class="card-body">
          <form id="searchForm" class="row g-3 align-items-center" autocomplete="off">
            <div class="col-md-3">
              <select class="form-select" id="searchType1" name="searchType1" required>
                <option value="all">전체 구매 목록</option>
                <!-- AJAX로 카테고리 옵션 추가됨 -->
              </select>
            </div>
            <div class="col-md-2">
              <select class="form-select" id="searchType2" name="searchType2" required>
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
            <div class="col-md-2">
              <button type="submit" class="btn btn-success w-100" id="searchBoard">
                <i class="bi bi-search"></i> 검색
              </button>
            </div>
          </form>
        </div>
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

        
        <!-- 평점 선택 모달 -->
<div class="modal fade" id="customPrompt" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">평점을 선택하세요</h5>
      </div>
      <div class="modal-body text-center">
        <div id="scoreChoices" class="btn-group" role="group">
          <button type="button" class="btn btn-outline-warning" data-score="1">1</button>
          <button type="button" class="btn btn-outline-warning" data-score="2">2</button>
          <button type="button" class="btn btn-outline-warning" data-score="3">3</button>
          <button type="button" class="btn btn-outline-warning" data-score="4">4</button>
          <button type="button" class="btn btn-outline-warning" data-score="5">5</button>
        </div>
      </div>
    <!-- 모달 footer -->
<div class="modal-footer">
  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
  <button id="confirmRatingBtn" type="button" class="btn btn-primary">확인</button>
</div>
    </div>
  </div>
</div>
        
        
        
        
        
<script>
$(function(){
  // 카테고리 옵션 동적 추가
  $.ajax({
    url: '${root}/selectCate.co',
    method: 'GET',
    dataType: "json",
    success: function(result) {
		let $allOption = $('#searchType1 option[value="all"]');
      $.each(result, function(idx, category){
        $('<option>', {
          value: category.categoryNo,
          text: category.categoryName
        }).insertAfter($allOption);
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
      // 게시글 조회
      const response = await $.ajax({
        url: '${root}/searchPerchasedBoard.co',
        method: 'GET',
        data: params,
      });
      const boardList = response.result;
      const totalCount = response.totalCount;
      
      $('#boardResultCount .fw-bold').text(totalCount || 0);
      renderBoardList(boardList, totalCount);

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
      
      //상태 표시 처리
      let statusDisplay = '';
      if (board.status === 'REQ') {
        statusDisplay = `<span class="text-warning fw-bold clickable-status-wrapper">
            <span class="clickable-status" style="cursor:pointer;">구매요청</span>
            </span>`;
      } else if (board.status === 'BUYER_OK') {
        statusDisplay = '<span class="text-primary fw-bold">구매확정</span>';
      } else if (board.status === 'DONE') {
        statusDisplay = '<span class="text-secondary fw-bold">거래완료</span>';
      } else {
        statusDisplay = '<span class="text-muted">-</span>';
      }
      let scoreStatusText = board.score2 === 'Y' ? '등록됨' : '미등록';
      // 카드 HTML
      let cardHtml = `
        <div class="col">
          <div class="card h-100 shadow-sm position-relative">
          	<input type="hidden" class="hidden-order-no" value="\${board.orderNo}" />  
          <div class="card-body">
              <div class="d-flex justify-content-between align-items-center mb-2">
                <h5 class="card-title mb-0 text-truncate" style="max-width: 70%;">\${title}</h5>
                <span class="badge bg-secondary ms-2">\${board.price.toLocaleString()}원</span>
              </div>
              <p class="card-text text-truncate" style="max-width: 100%;">
              \${content}</p>
            </div>
            <div class="card-footer small text-muted d-flex justify-content-between align-items-center">
              <span>\${board.categoryName ? board.categoryName : '-'}</span>
              <span>\${board.userId}</span>
              <span class="ms-2">\${scoreStatusText}</span>
              <span class="ms-2">` + statusDisplay + `</span>
            </div>
            `;
			 
//             if (board.status === 'REQ') {
// 			  cardHtml += `
// 			    <div class="card-footer bg-light text-end px-3">
// 			      <a href="${root}/order/productOrder?orderNo=${board.orderNo}" class="btn btn-sm btn-warning">구매확정하러 가기</a>
// 			    </div>
// 			  `;
// 			}
            
             // 평점 모달 팝업 조건: score2가 'N' (미등록)이고 status가 'DONE' (거래 완료)일 때만 모달 링크 활성화
             if (board.score2 === 'N' && board.status === 'DONE') {
                 cardHtml += `
				  <a href="#" class="stretched-link rating-trigger"
				     data-product-no="\${board.productNo}"
				     data-user-no="\${board.userNo}"
				     data-bs-toggle="modal"
				     data-bs-target="#customPrompt"></a>
				`;
             } else {
                 // 평점 등록이 불가능한 경우 (클릭 시 알림)
                 cardHtml += `
                     <a href="#" class="stretched-link disabled-rating-trigger"
                        data-product-no="\${board.productNo}"
                        data-trade-status="\${board.status}"></a>
                 `;
             }

             cardHtml += `
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
  
//   let selectedProductNo = null;
//   let selectedUserNo = null;
//   let selectedScore = null;
  
  // 카드 클릭 시 모달 표시
  $('#boardList').on('click', '.rating-trigger', function(e){
    e.preventDefault();
    const $card = $(this).closest('.card');
    
    selectedUserNo = $(this).data('user-no');
    selectedScore = null; // 초기화
    selectedProductNo = $(this).data('product-no');
    $('#scoreChoices button').removeClass('active'); // 선택 초기화
    $('#customPrompt').modal('show');
  });

  // 점수 버튼 클릭 → 점수 저장만
  $('#scoreChoices button').on('click', function(){
    $('#scoreChoices button').removeClass('active');
    $(this).addClass('active');
    selectedScore = $(this).data('score');
  });

  // 확인 버튼 눌렀을 때 등록
  $('#confirmRatingBtn').on('click', function(){
    if (!selectedScore) {
      return alert("⚠️ 평점을 선택해주세요.");
    }
    if (selectedUserNo === null || selectedProductNo === undefined) {
        return alert("⚠️ 유저 정보가 올바르지 않습니다. 다시 시도해주세요.");
    }
    if (selectedProductNo === null || selectedProductNo === undefined) {
        return alert("⚠️ 상품 정보가 올바르지 않습니다. 다시 시도해주세요.");
    }
    $.post('${root}/rating', {
      productNo: selectedProductNo,
      userNo: selectedUserNo,
      score: selectedScore
    })
    .done(() => {
      alert("✅ 평점이 등록되었습니다.");
      $('#customPrompt').modal('hide');
      searchBoard();
      location.href='${root}/doTest.me';
    })
    .fail(() => alert("✅ 평점이 등록되었습니다."));
    $('#customPrompt').modal('hide');
    searchBoard();
    location.href='${root}/doTest.me';
  });
  $('#boardList').on('click', '.disabled-rating-trigger', function(e){
	      e.preventDefault(); // 기본 링크 동작 방지 (href="#" 때문에 페이지 상단으로 이동하는 것을 막음)

	      const scoreStatus = $(this).data('score-status');
	      const tradeStatus = $(this).data('trade-status');

	      let message = "평점을 입력하실 수 없습니다.";
	      
	      alert(message); // 경고 메시지 띄우기
	    });
  
  //구매확정페이지 가기
  $('#boardList').on('click', '.clickable-status', function(e){
	  e.stopPropagation(); // 카드 전체 클릭 막기
	  e.preventDefault();
	  e.stopImmediatePropagation();

	  const orderNo = $(this).closest('.card').find('.hidden-order-no').val();

	  if (confirm('구매요청(거래중) 입니다 구매확정 페이지로 이동하시겠습니까?')) {
	    location.href = `${root}/order/productOrder?orderNo=\${orderNo}`;
	  }
	});
});
</script>
</body>
</html>