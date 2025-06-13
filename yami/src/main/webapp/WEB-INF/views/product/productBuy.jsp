<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>구매하기</title>
<style>
    body {
        font-family: '마르아고딕', sans-serif;
        background-color: #f9f9f9;
        margin: 0;
        padding: 0;
    }
    .container {
        width: 80%;
        margin: 40px auto;
        background-color: white;
        padding: 30px;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }
    .buy-flex {
        display: flex;
        flex-wrap: wrap;
    }
    .image-area {
        width: 40%;
        padding: 10px;
        text-align: center;
    }
    .image-area img {
        width: 80%;
        border-radius: 10px;
        border: 1px solid #ddd;
        margin-top: 15px;
    }
    .buy-info-area {
        width: 60%;
        padding: 10px 30px;
    }
    .buy-title {
        font-size: 26px;
        font-weight: bold;
        margin-bottom: 10px;
    }
    .price {
        color: #ff6600;
        font-size: 22px;
        font-weight: bold;
        margin: 15px 0;
    }
    .meta {
        font-size: 14px;
        color: #888;
        margin-bottom: 20px;
    }
    .desc {
        font-size: 16px;
        margin-bottom: 18px;
        color: #444;
    }
    .form-label {
        margin: 10px 0 5px 0;
        font-weight: bold;
    }
    .form-control {
        width: 100%;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 5px;
        margin-bottom: 15px;
        font-size: 16px;
        background: #f4f4f4;
    }
    .action-btn {
        background-color: #ff6600;
        color: white;
        border: none;
        padding: 15px;
        font-size: 18px;
        cursor: pointer;
        border-radius: 6px;
        width: 100%;
        margin-top: 10px;
        margin-bottom: 5px;
        font-weight: bold;
        letter-spacing: 2px;
        transition: background 0.15s;
    }
    .action-btn:hover {
        background-color: #ff8844;
    }
    .cancel-btn {
        background: #eee;
        color: #666;
        border: none;
        padding: 12px;
        border-radius: 6px;
        font-size: 15px;
        margin-left: 8px;
        cursor: pointer;
        transition: background 0.15s;
    }
    .buy-summary {
        border-top: 1px solid #eee;
        margin-top: 20px;
        padding-top: 15px;
        font-size: 15px;
        color: #777;
    }
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<div class="container">
    <div class="buy-flex">
        <!-- 상품 이미지 -->
        <div class="image-area">
            <c:if test="${not empty product.atList}">
                <img src="${contextPath}${product.atList[0].filePath}${product.atList[0].changeName}" alt="대표이미지">
            </c:if>
        </div>
        <!-- 구매 정보/입력 영역 -->
        <div class="buy-info-area">
            <div class="buy-title">${product.productTitle}</div>
            <div class="meta">
                판매자: <b>${product.userName}</b> |
                <fmt:formatDate value="${product.uploadDate}" pattern="yyyy-MM-dd" /> |
                조회수: ${product.productCount}
            </div>
            <div class="price">
                <fmt:formatNumber value="${product.price}" pattern="#,###" />원
            </div>
            <div class="desc">${product.productContent}</div>

            <!-- 거래 희망 정보 (자동 셋팅, 수정불가) -->
            <form id="buyForm" method="post" action="${contextPath}/productPay">
                <input type="hidden" name="productNo" value="${product.productNo}" />
				<input type="hidden" name="sellerId" value="${product.userNo}" />
				<input type="hidden" name="buyerId" value="${loginUser.userNo}" />
                <div class="form-label">판매자 이름</div>
                <input type="text" name="sellerName" class="form-control" value="${product.userName}" readonly />

                <div class="form-label">판매자 연락처</div>
                <input type="text" name="sellerPhone" class="form-control" value="${product.userPhone}" readonly />

                <div class="form-label">판매자의 거래 동네</div>
                <input type="text" name="meetLocation" class="form-control" value="${product.coordAddress}" readonly />

                <div class="buy-summary">
                    <b>※ 구매 요청시 판매자에게 알림이 전송됩니다.<br>
                    거래 완료 후에는 마이페이지에서 내역 확인 및 리뷰 작성이 가능합니다.</b>
                </div>

                <button type="submit" class="action-btn">구매 요청하기</button>
                <button type="button" class="cancel-btn" onclick="history.back();">취소</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>