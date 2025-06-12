<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<meta charset="UTF-8">
<title>댓글 조회 및 수정</title>
</head>
<body>
<%@include file="/WEB-INF/views/common/header.jsp"%>

<div class="container py-5">
  <div class="row justify-content-center">
    <div class="col-md-11 col-lg-10">
      <div class="card shadow-lg mb-4">
        <div class="card-header bg-primary text-white">
          <h4 class="mb-0"><i class="bi bi-pencil-square me-2"></i>댓글 조회</h4>
        </div>
        <div class="card-body">
          <form id="searchForm" class="row g-3 align-items-center" autocomplete="off">
            <div class="col-md-3">
              <select class="form-select" id="searchType1" name="searchType1" required>
                <option value="all">전체 판매 게시판</option>
                <!-- AJAX로 카테고리 옵션 추가됨 -->
                <option value="dongne">우리동네 빵집 게시판</option>
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
              <button type="submit" class="btn btn-success w-100" id="searchreply">
                <i class="bi bi-search"></i> 조회하기
              </button>
            </div>
          </form>
        </div>
      </div>

      <div class="mb-3 text-end text-secondary small">
        <span id="replyResultCount">검색결과 <span class="fw-bold">0</span>건</span>
      </div>

      <!-- 게시글 카드 리스트 -->
      <div id="replyList" class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4 mb-4">
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
    searchreply();
  });

  // 페이지네이션 클릭
  $('#paginationNav').on('click', '.page-link', function(e){
    e.preventDefault();
    const page = $(this).data('page');
    $('#page').val(page);
    searchreply();
  });

  // 댓글 검색 및 렌더링
  async function searchreply(){
	let params = $('#searchForm').serialize();
	let searchType1 = $('#searchType1').val();
	let response;
    try {
      // 댓글 조회
      if(searchType1 == 'dongne'){
    	  //우리동네 빵집 댓글조회
	      response = await $.ajax({
	        url: '${root}/searchReplyDongne.ad',
	        method: 'POST',
	        data: params,
	      });

	      const replyList = response.result;
	      const totalCount = response.totalCount;
	      
	      $('#replyResultCount .fw-bold').text(totalCount || 0);
	      renderBakeryReplyList(replyList, totalCount);

	      const page = parseInt($('#page').val());
	      const pageSize = parseInt($('#searchCount').val());

	      renderPagination(totalCount, page, pageSize);
    	  
      }else{
    	  //판매게새판 댓글조회
	      response = await $.ajax({
	        url: '${root}/searchReply.ad',
	        method: 'POST',
	        data: params,
	      });
	      const replyList = response.result;
	      const totalCount = response.totalCount;
	      
	      $('#replyResultCount .fw-bold').text(totalCount || 0);
	      renderReplyList(replyList, totalCount);
	
	      const page = parseInt($('#page').val());
	      const pageSize = parseInt($('#searchCount').val());
	
	      renderReplyList(replyList, totalCount);
	      renderPagination(totalCount, page, pageSize);
      }
      

    } catch(error) {
      $('#replyList').html('<div class="col"><div class="alert alert-danger">데이터 조회 실패</div></div>');
    }
  }

  // 댓글 카드 렌더링
  function renderReplyList(replyList, totalCount){
	    let $replyList = $('#replyList');
	    $replyList.empty();

	    if(!replyList || replyList.length === 0){
	        $replyList.html('<div class="col"><div class="alert alert-warning mb-0">검색 결과가 없습니다.</div></div>');
	        return;
	    }

	    $.each(replyList, function(idx, reply){
	    	let productTitle = reply.productTitle || '';
	        let titleDisplay = productTitle.length > 10 ? productTitle.substring(0, 10) + '...' : productTitle;
	        let cardHtml = `
	            <div class="col">
	                <div class="card h-100 shadow-sm position-relative" style="cursor:pointer;" onclick="location.href='${root}/productDetail.pro?productNo=\${reply.productNo}'">
	                    <div class="card-body">
	                        <div class="d-flex justify-content-between align-items-center mb-2">
	                        	<span class="text-truncate" style="max-width: 50%;">\${titleDisplay}</span>
	                        </div>
	                        <p class="card-text">\${reply.replyText || ''}</p>
	                    </div>
	                    <div class="card-footer small text-muted d-flex justify-content-between align-items-center">
                            <span class="fw-bold">NO.\${reply.replyNo}</span>
	                        <span>\${reply.replyDateStr}</span>
	                    </div>
	                </div>
	            </div>
	        `;
	        $replyList.append(cardHtml);
	    });
	}


  // 페이지네이션 렌더링
  function renderPagination(totalCount, currentPage, pageSize){
	const totalPage = Math.ceil(totalCount / pageSize) || 1;
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
  searchreply();
  
  //----------------우리동네빵집 댓글 로직----------------
  function renderBakeryReplyList(replyList, totalCount){
	  let $replyList = $('#replyList');
	  $replyList.empty();

	  if(!replyList || replyList.length === 0){
	    $replyList.html('<div class="col"><div class="alert alert-warning mb-0">검색 결과가 없습니다.</div></div>');
	    return;
	  }

	  $.each(replyList, function(idx, reply){
	    // 댓글/대댓글 구분
	    let typeLabel = reply.commentType === 'RECOMMENT' ? '대댓글' : '댓글';
	    let typeBadge = reply.commentType === 'RECOMMENT'
	      ? '<span class="badge bg-info ms-1">대댓글</span>'
	      : '<span class="badge bg-primary ms-1">댓글</span>';

	    // 추천/비추천 아이콘
	    let likeIcon = '';
	    if(reply.bakeryLike === 'L'){
	      likeIcon = '<i class="bi bi-hand-thumbs-up-fill text-success ms-2" title="추천"></i>';
	    } else if(reply.bakeryLike === 'D'){
	      likeIcon = '<i class="bi bi-hand-thumbs-down-fill text-danger ms-2" title="비추천"></i>';
	    }

	    // 상태 표시
	    let statusLabel = '';
	    if(reply.status === 'N'){
	      statusLabel = '<span class="fst-italic text-secondary ms-2">삭제됨</span>';
	    } else if(reply.status === 'M'){
	      statusLabel = '<span class="text-muted ms-2">수정됨</span>';
	    } else if(reply.status === 'P'){
	      statusLabel = '<span class="text-danger ms-2">신고되어 삭제됨</span>';
	    }

	    // 댓글 내용 (상태에 따라 스타일 다르게)
	    let commentContent = reply.commentContent.length > 10 
			  ? reply.commentContent.substring(0, 10) + '...' 
			  : reply.commentContent;

	    if(reply.status === 'N' || reply.status === 'P'){
	      commentContent = `<span class="text-decoration-line-through">\${commentContent}</span>`;
	    }

	    // 카드 HTML
	    let cardHtml = `
	      <div class="col">
	        <div class="card h-100 shadow-sm position-relative bakery-comment-card" 
	             style="cursor:pointer;" 
	             data-comment-no="\${reply.commentNo}" 
	             data-bakery-no="\${reply.bakeryNo}" 
	             data-user-no="\${reply.userNo}">
	          <div class="card-body">
	            <div class="d-flex justify-content-between align-items-center mb-2">
	              <span>
	                <strong>${reply.userName}</strong>
	                \${typeBadge}
	                \${likeIcon}
	              </span>
	              <span class="small text-muted">\${reply.commentDateStr}</span>
	            </div>
	            <p class="card-text mb-1">\${commentContent}\${statusLabel}</p>
	          </div>
	        </div>
	      </div>
	    `;
	    $replyList.append(cardHtml);
	  });

	  // 카드 클릭 이벤트 (동적 바인딩)
	  $('.bakery-comment-card').off('click').on('click', function(){
	    const commentNo = $(this).data('comment-no');
	    const bakeryNo = $(this).data('bakery-no');
	    const userNo = $(this).data('user-no');
	    // 상세페이지 이동
	    location.href = `${root}/myReplyDongneDetail.co?commentNo=\${commentNo}&bakeryNo=\${bakeryNo}`;
	  });
	}

});
</script>
</body>
</html>
