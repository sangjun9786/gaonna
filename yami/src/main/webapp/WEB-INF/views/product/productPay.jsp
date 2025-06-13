<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>결제 페이지</title>
<style>
    body { font-family: '마르아고딕', sans-serif; background: #f9f9f9; margin: 0; padding: 0; }
    .container { width: 60%; margin: 40px auto; background: #fff; padding: 30px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1);}
    .flex { display: flex; flex-wrap: wrap;}
    .image-area { width: 40%; padding: 10px;}
    .image-area img { width: 100%; border-radius: 10px; border: 1px solid #ddd;}
    .info-area { width: 60%; padding: 10px;}
    .info-area h2 { margin-top: 0; font-size: 22px;}
    .price { color: #ff6600; font-size: 22px; font-weight: bold; margin: 10px 0;}
    .meta { font-size: 13px; color: gray; margin-bottom: 10px;}
    .section { margin-top: 25px; }
    .section-title { font-weight: bold; font-size: 18px; margin-bottom: 10px;}
    .pay-form { margin-top: 25px; }
    .pay-btn { background-color: #ff6600; color: white; border: none; padding: 14px 0; font-size: 18px; width: 100%; border-radius: 6px; cursor: pointer; margin-top: 15px;}
    .form-group { margin-bottom: 16px;}
    .form-group label { display: block; font-weight: bold; margin-bottom: 5px;}
    .form-group input[type=text], .form-group input[type=number] { width: 100%; padding: 8px; border-radius: 4px; border: 1px solid #ddd;}
    .point-guide { color: #ff6600; font-size: 14px; margin-bottom: 5px;}
    .final-amount { font-size: 20px; color: #333; margin-top: 20px; font-weight: bold;}
</style>
</head>
<body>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<div class="container">
    <h2 style="margin-bottom:18px;">구매 결제</h2>
    <div class="flex">
        <!-- 상품 이미지 -->
        <div class="image-area">
            <c:if test="${not empty product.atList}">
                <img src="${contextPath}${product.atList[0].filePath}${product.atList[0].changeName}" alt="대표이미지">
            </c:if>
        </div>
        <!-- 상품 정보 -->
        <div class="info-area">
            <h2>${product.productTitle}</h2>
            <div class="meta">${product.categoryName}</div>
            <div class="desc" style="margin-bottom:10px;">${product.productContent}</div>
            <div class="price">
                <fmt:formatNumber value="${product.price}" pattern="#,###"/>원
            </div>
            <div class="meta">
                판매자: <b>${product.userId}</b>
            </div>
        </div>
    </div>
    <!-- 구매자 정보 표시 (로그인 정보) -->
    <div class="section">
        <div class="section-title">구매자 정보</div>
        <div class="form-group">
            <label>이름</label>
            <input type="text" value="${loginUser.userName}" name="buyerName" readonly>
        </div>
        <div class="form-group">
            <label>이메일</label>
            <input type="text" value="${loginUser.userId}" readonly>
        </div>
        <div class="form-group">
            <label>휴대폰</label>
            <input type="text" value="${loginUser.phone}" name="buyerPhone" readonly>
        </div>
        <div class="form-group">
            <label>사용 가능한 포인트</label>
            <input type="text" value="<fmt:formatNumber value='${loginUser.point}' pattern='#,###'/> P" readonly style="color:#ff6600;font-weight:bold;">
        </div>
    </div>

    <!-- 포인트 입력/차감 및 결제 -->
    <form action="${contextPath}/productOrder" method="post" class="pay-form" id="payForm">
        <input type="hidden" name="productNo" value="${product.productNo}">
        <input type="hidden" name="price" id="originPrice" value="${product.price}">
        <!-- 구매자/판매자 정보 히든으로 추가! -->
	    <input type="hidden" name="buyerId" value="${loginUser.userNo}">
	    <input type="hidden" name="buyerName" value="${loginUser.userName}">
	    <input type="hidden" name="buyerPhone" value="${loginUser.phone}">
	    <input type="hidden" name="sellerId" value="${product.userNo}">
	    <input type="hidden" name="sellerName" value="${product.userName}">
	    <input type="hidden" name="sellerPhone" value="${product.userPhone}">
	    <input type="hidden" name="meetLocation" value="${product.coordAddress}">
        <div class="section">
            <div class="section-title">포인트 사용</div>
            <div class="form-group">
                <span class="point-guide">
                    사용 가능한 포인트: <fmt:formatNumber value="${loginUser.point}" pattern="#,###"/>P
                </span>
                <input type="number" name="usedPoint" id="usedPoint" class="form-control"
                       min="0"
                       max="${loginUser.point}"
                       value="0"
                       placeholder="포인트를 입력하세요">
                <div class="section-title">판매자에게 메시지</div>
	        <textarea name="message" class="form-control" rows="3" placeholder="거래 요청 메시지를 입력하세요."></textarea>
            </div>
        	<!-- 메시지(선택) -->
            <div class="final-amount">
                현장 결제 금액: <span id="finalPrice"><fmt:formatNumber value="${product.price}" pattern="#,###"/></span> 원
            </div>
        </div>
        <button type="submit" class="pay-btn">만나서 거래하기</button>
    </form>
</div>

<script>
$(function() {
    // 포인트 입력할 때마다 결제 금액 자동 계산
    $("#usedPoint").on("input", function() {
        let originPrice = parseInt($("#originPrice").val()) || 0;
        let usePoint = parseInt($("#usedPoint").val()) || 0;
        // 입력값 제한: 0 이상, 보유포인트 이하, 상품금액 이하
        const maxPoint = Math.min(
            parseInt("${loginUser.point}"),
            originPrice
        );
        if(usePoint < 0) usePoint = 0;
        if(usePoint > maxPoint) usePoint = maxPoint;
        $("#usedPoint").val(usePoint);

        let finalPrice = originPrice - usePoint;
        $("#finalPrice").text(finalPrice.toLocaleString());
    });
});
</script>
</body>
</html>