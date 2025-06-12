<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>찜 목록</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<style>
.card-blur-target {
  filter: blur(2px);
  pointer-events: none;
  user-select: none;
  opacity: 0.7;
}
.card-overlay {
  position: absolute;
  top: 0; left: 0; width: 100%; height: 100%;
  background: rgba(255,255,255,0.8);
  display: flex; justify-content: center; align-items: center;
  flex-direction: column;
  z-index: 10;
}
.card-delete-btn {
  margin-top: 10px;
}
.card-bottom-btns {
  position: absolute;
  bottom: 0;
  right: 0;
  z-index: 2;
  padding: 0.5rem 0.75rem;
}
.card-date-center {
  position: absolute;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
  z-index: 2;
  padding-bottom: 0.5rem;
  font-size: 0.95em;
  color: #6c757d;
  background: rgba(255,255,255,0.9);
  border-radius: 8px;
  min-width: 120px;
  text-align: center;
}
.card-status-message {
  position: absolute;
  top: 50%; left: 50%;
  transform: translate(-50%, -50%);
  font-size: 1.1rem;
  font-weight: bold;
  color: #fff;
  background: rgba(220,53,69,0.9);
  padding: 0.8em 1.2em;
  border-radius: 10px;
  z-index: 20;
  text-align: center;
  pointer-events: auto;
  cursor: pointer;
}
.position-relative { position: relative !important; }
</style>
</head>
<body>
<%@include file="/WEB-INF/views/common/header.jsp" %>

<div class="container py-5">
  <div class="row justify-content-center">
    <div class="col-md-11 col-lg-10">
      <div class="card shadow-lg mb-4">
        <div class="card-header bg-danger text-white">
          <h4 class="mb-0"><i class="bi bi-heart-fill me-2"></i>찜한 게시글</h4>
        </div>
      </div>

      <div class="mb-3 text-end text-secondary small">
        <span id="wishlistResultCount">검색결과 <span class="fw-bold">0</span>건</span>
      </div>

      <!-- 찜 게시글 카드 리스트 -->
      <div id="wishlistList" class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4 mb-4">
        <div class="col">
          <div class="alert alert-info mb-0">찜한 게시글이 이곳에 표시됩니다.</div>
        </div>
      </div>

      <!-- 페이지네이션 -->
      <nav id="paginationNav" class="mt-4 d-flex justify-content-center"></nav>
    </div>
  </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
$(function(){

  // 찜 카드 렌더링
  function renderWishlist(wishlist, totalCount){
    let $wishlistList = $('#wishlistList');
    $wishlistList.empty();

    if(!wishlist || wishlist.length === 0){
      $wishlistList.html('<div class="col"><div class="alert alert-warning mb-0">찜한 게시글이 없습니다.</div></div>');
      return;
    }

    $.each(wishlist, function(idx, board){
      let title = board.productTitle.length > 10 ? board.productTitle.substring(0,10) + '...' : board.productTitle;
      let content = board.productContent.length > 30 ? board.productContent.substring(0,30) + '...' : board.productContent;
      let isDeleted = board.status !== 'Y';

      let cardHtml = `
        <div class="col">
          <div class="card h-100 shadow-sm position-relative" data-product-no="\${board.productNo}">
            <div class="card-blur-target">
              <div class="card-body">
                <div class="d-flex justify-content-between align-items-center mb-2">
                  <h5 class="card-title mb-0 text-truncate" style="max-width: 70%;">\${title}</h5>
                  <span class="badge bg-secondary ms-2">\${board.price.toLocaleString()}원</span>
                </div>
                <p class="card-text text-truncate" style="max-width: 100%;">\${content}</p>
              </div>
              <div class="card-footer small text-muted d-flex justify-content-between align-items-center" style="visibility:hidden;height:0;padding:0;border:none;"></div>
            </div>
            <div class="card-bottom-btns">
              <button type="button" class="btn btn-outline-danger btn-sm wishlist-delete-btn" title="찜 삭제">
                <i class="bi bi-trash"></i>
              </button>
            </div>
            <div class="card-date-center">\${board.uploadDateStr}</div>
            <a href="${root}/productDetail.pro?productNo=\${board.productNo}" class="stretched-link"></a>
            \${isDeleted ? `<div class="card-status-message" data-product-no="\${board.productNo}">삭제된 게시글입니다</div>` : ''}
          </div>
        </div>
      `;
      $wishlistList.append(cardHtml);

      // 삭제된 게시글이면 카드 내용만 블러 처리
      if(isDeleted) {
        $wishlistList.find('.col:last .card-blur-target').addClass('card-blur-target');
      }
    });
  }

  //삭제 아이콘 누르기
  $('#wishlistList').on('click', '.wishlist-delete-btn', async function(e){
    e.preventDefault();
    e.stopPropagation();

    let $card = $(this).closest('.card');
    let productNo = $card.data('product-no');

    try {
      const result = await $.ajax({
        url: '${root}/deleteMyWishlist.co',
        method: 'POST',
        data: { 
          productNo: productNo,
          userNo : ${sessionScope.loginUser.userNo}
        },
        dataType: 'text'
      });

      if(result === 'pass'){
        // 성공 시 카드 자연스럽게 삭제
        $card.closest('.col').fadeOut(400, function(){ $(this).remove(); });
      }else{
        // 실패 시 안내
        alert('서버 오류로 삭제에 실패했습니다.');
      }
    } catch(err){
      alert('서버 오류로 삭제에 실패했습니다.');
    }
  });

  // "삭제된 게시글입니다" 메시지 클릭 시 상세페이지 이동
  $('#wishlistList').on('click', '.card-status-message', function(e){
    e.preventDefault();
    e.stopPropagation();
    var productNo = $(this).data('product-no');
    if(productNo) {
      window.location.href = '${root}/productDetail.pro?productNo=' + productNo;
    }
  });

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

  // 페이지네이션 클릭
  $('#paginationNav').on('click', '.page-link', function(e){
    e.preventDefault();
    const page = $(this).data('page');
    $('#page').val(page);
    searchWishlist();
  });

  // 찜 목록 조회 및 렌더링
  async function searchWishlist(){
    const params = $('#searchForm').serialize();

    try {
      const response = await $.ajax({
        url: '${root}/searchMyWishlist.co',
        method: 'POST',
        data: params,
        dataType: 'json'
      });
      const wishlist = response.result;
      const totalCount = response.totalCount;

      $('#wishlistResultCount .fw-bold').text(totalCount || 0);
      renderWishlist(wishlist, totalCount);

      const page = parseInt($('#page').val());
      const pageSize = parseInt($('#searchCount').val());
      renderPagination(totalCount, page, pageSize);

    } catch(error) {
      $('#wishlistList').html('<div class="col"><div class="alert alert-danger">데이터 조회 실패</div></div>');
    }
  }

  // 최초 진입시 전체 조회
  searchWishlist();
});
</script>
</body>
</html>
