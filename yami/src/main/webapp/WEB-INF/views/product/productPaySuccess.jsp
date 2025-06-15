<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>구매확정 안내</title>
<style>
/* 기존 스타일 유지 */
body {
    font-family: 'Malgun Gothic', '맑은 고딕', Arial, sans-serif;
    background: #f9f9f9;
    margin: 0; padding: 0;
    color: #222;
}
.container {
    width: 60%;
    min-width: 380px;
    max-width: 700px;
    margin: 40px auto;
    background: #fff;
    padding: 32px 28px 34px 28px;
    border-radius: 14px;
    box-shadow: 0 0 10px rgba(0,0,0,0.09);
}
.section { margin-bottom: 30px; }
.section-title {
    font-size: 21px;
    font-weight: bold;
    color: #007BFF;
    margin-bottom: 12px;
    letter-spacing: -1px;
}
.highlight {
    font-size: 22px;
    color: #007BFF;
    font-weight: bold;
}
.info-box {
    background: #f2faff;
    border-radius:8px;
    padding:19px 23px;
    margin: 16px 0;
    font-size: 15px;
    color: #383838;
    line-height: 1.7;
}
.summary-table {
    width:100%;
    border-collapse: collapse;
    margin-top: 13px;
}
.summary-table td {
    padding: 8px 0;
    font-size: 16px;
    color: #2b2b2b;
}
.summary-table .label {
    font-weight:bold;
    color:#888;
    width:33%;
    padding-right: 16px;
}
.btn-main {
    background: #007BFF;
    color: #fff;
    border: none;
    padding: 12px 20px;
    font-size: 17px;
    border-radius: 6px;
    cursor: pointer;
    transition: background 0.2s;
    font-weight: 500;
}
.btn-main:hover { background: #0056b3; }
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<div class="container">
    <div class="section">
        <div class="section-title">구매확정 안내</div>
        <div class="info-box">
            <p>
                해당 상품의 구매를 확정하시겠습니까?<br>
                판매자가 <b>판매확정</b>을 하지 않더라도 <u>24시간 내 자동으로 판매확정</u>이 처리됩니다.<br><br>
                판매확정이 완료되면 <span class="highlight">차액 포인트 <fmt:formatNumber value="${order.usedPoint}" pattern="#\,###"/>P</span>가 적립됩니다.
            </p>
        </div>
    </div>

    <div class="section">
        <div class="section-title">상품 요약</div>
        <table class="summary-table">
            <tr>
                <td class="label">상품명</td>
                <td>${product.productTitle}</td>
            </tr>
            <tr>
                <td class="label">상품가</td>
                <td><fmt:formatNumber value="${order.price}" pattern="#\,###"/>원</td>
            </tr>
            <tr>
                <td class="label">현장 결제금액</td>
                <td><fmt:formatNumber value="${order.price - order.usedPoint}" pattern="#\,###"/>원</td>
            </tr>
            <tr>
                <td class="label">적립 예정 포인트</td>
                <td class="highlight"><fmt:formatNumber value="${order.usedPoint}" pattern="#\,###"/>P</td>
            </tr>
        </table>
    </div>

    <form action="${contextPath}/order/confirmOrder" method="post">
        <input type="hidden" name="orderNo" value="${order.orderNo}"/>
        <div class="section" style="text-align:center;">
            <button type="submit" class="btn-main">구매 확정하기</button>
        </div>
    </form>
</div>

</body>
</html>
