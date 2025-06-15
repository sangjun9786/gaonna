<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/lodash@4.17.21/lodash.min.js"></script>
<meta charset="UTF-8">
<title>마이페이지</title>
</head>
<body>
<%@include file="/WEB-INF/views/common/header.jsp" %>
<%@include file="/WEB-INF/views/event/test.jsp" %>
<div class="container py-5">
  <!-- 생략된 사용자 설정 카드, 위치 카드 등 동일하게 유지 -->

  <!-- ✅ 구매한 상품 평점 등록 카드 -->
  <div class="card shadow-sm mb-4">
    <div class="card-header bg-warning text-white">
      <h4 class="mb-0"><i class="bi bi-star me-2"></i>구매한 상품 평점 등록</h4>
    </div>
    <div class="card-body">
      <div id="purchasedListContainer">
        <p class="text-muted">구매한 상품을 불러오는 중...</p>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">
// 구매 목록 불러와 평점 UI 생성
$(function(){
  $.getJSON('${root}/myPurchasedList.po')
    .done(function(data) {
      const list = data.result;
      const container = $('#purchasedListContainer').empty();

      if (!list || list.length === 0) {
        container.append('<div class="text-muted">구매한 상품이 없습니다.</div>');
        return;
      }

      list.forEach(function(p) {
        const html =
          '<div class="mb-4 border-bottom pb-3">' +
            '<strong>' + p.productTitle + '</strong><br>' +
            '<input type="number" min="1" max="5" class="form-control w-25 d-inline" ' +
                   'id="score_' + p.productNo + '" placeholder="평점(1~5)">' +
            '<input type="text" class="form-control mt-2" ' +
                   'placeholder="한줄평 입력 (옵션)"> ' +
            '<button class="btn btn-sm btn-warning mt-2" ' +
                    'onclick="submitRating(' + p.productNo + ', \'' + p.userNo + '\')">등록</button>' +
          '</div>';
        container.append(html);
      });
    })
    .fail(function(){
      $('#purchasedListContainer')
        .html('<div class="text-danger">불러오기 실패</div>');
    });
});

// 평점 등록 Ajax
function submitRating(prodNo, userNo) {
  const score = +$('#score_' + prodNo).val();

  if (!score || score < 1 || score > 5) {
    return alert("평점은 1~5 사이 숫자여야 합니다.");
  }

  $.post('${root}/insertRating.rt', {
    userNo: userNo,
    score: score
  })
  .done(function(){
    alert("평점이 등록되었습니다.");
  })
  .fail(function(){
    alert("평점 등록 실패");
  });
}
</script>

</body>
</html>
