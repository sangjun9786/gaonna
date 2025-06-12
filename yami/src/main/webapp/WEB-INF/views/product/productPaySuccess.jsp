<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>결제 완료</title>
<style>
    body { font-family: '마르아고딕', sans-serif; background: #f9f9f9; margin: 0; padding: 0; }
    .container { width: 60%; margin: 60px auto; background: #fff; padding: 40px 30px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.07);}
    .success-title { font-size: 28px; color: #ff6600; font-weight: bold; text-align: center; margin-bottom: 30px; }
    .info-box { margin: 0 auto 30px auto; background: #f8f8f8; padding: 20px 25px; border-radius: 8px; max-width: 600px; }
    .info-box p { margin: 6px 0; font-size: 17px; }
    .btn-area { text-align: center; margin-top: 30px; }
    .btn { background: #ff6600; color: #fff; padding: 12px 38px; font-size: 18px; border: none; border-radius: 7px; margin-right: 10px; cursor: pointer; }
    .btn.gray { background: #aaa; }
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<div class="container">
    <div class="success-title">
        결제가 정상적으로 완료되었습니다!
    </div>
    <div class="info-box">
        <p>상품명: <b>${order.productTitle}</b></p>
        <p>결제 금액: <b><fmt:formatNumber value="${order.finalPrice}" pattern="#,###"/>원</b></p>
        <p>사용 포인트: <b><fmt:formatNumber value="${order.usePoint}" pattern="#,###"/>P</b></p>
        <p>주문번호: <b>${order.orderNo}</b></p>
        <p>구매자: <b>${order.buyerName}</b></p>
        <p>결제일시: <b><fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd HH:mm:ss"/></b></p>
    </div>
    <div class="btn-area">
        <button class="btn" onclick="location.href='${contextPath}/myOrders'">나의 구매내역</button>
        <button class="btn gray" onclick="location.href='${contextPath}/'">메인으로</button>
    </div>
</div>
</body>
</html>