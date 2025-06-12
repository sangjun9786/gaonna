<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    .form-group input[type=text], .form-group select { width: 100%; padding: 8px; border-radius: 4px; border: 1px solid #ddd;}
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
            <input type="text" value="${loginUser.userName}" readonly>
        </div>
        <div class="form-group">
            <label>이메일</label>
            <input type="text" value="${loginUser.userId}" readonly>
        </div>
        <div class="form-group">
            <label>휴대폰</label>
            <input type="text" value="${loginUser.phone}" readonly>
        </div>
    </div>
    <!-- 결제 방식 선택 -->
    <form action="${contextPath}/payProduct" method="post" class="pay-form">
        <input type="hidden" name="productNo" value="${product.productNo}">
        <input type="hidden" name="price" value="${product.price}">
        <div class="section">
            <div class="section-title">결제수단 선택</div>
            <div class="form-group">
                <select name="payType" required>
                    <option value="">결제수단 선택</option>
                    <option value="card">신용카드</option>
                    <option value="bank">계좌이체</option>
                    <option value="kakaopay">카카오페이</option>
                    <option value="naverpay">네이버페이</option>
                </select>
            </div>
        </div>
        <button type="submit" class="pay-btn">결제하기</button>
    </form>
</div>

</body>
</html>