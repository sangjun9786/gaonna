<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>거래 안내/만남 안내</title>
<style>
    body {
        font-family: 'Malgun Gothic', '맑은 고딕', Arial, sans-serif;
        background: #f9f9f9;
        margin: 0; padding: 0;
        color: #222;
        letter-spacing: 0;
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
    .section { margin-bottom: 30px;}
    .section-title {
        font-size: 21px;
        font-weight: bold;
        color: #ff6600;
        margin-bottom: 12px;
        letter-spacing: -1px;
    }
    .summary-table {
	    width:100%;
	    border-collapse: collapse;
	    margin-top: 13px;
	}
	.summary-table tr { vertical-align: top; }
	.summary-table td {
	    padding: 7px 0 7px 0;
	    font-size: 16px;
	    color: #2b2b2b;
	    text-align: left;
	    word-break: break-all;
	    vertical-align: top;
	}
	.summary-table .label {
	    font-weight:bold;
	    color:#888;
	    width:32%;         /* 라벨 넓이 통일 */
	    min-width: 105px;  /* 모바일 대응 */
	    padding-right: 16px; /* 라벨-값 간격 통일 */
	    box-sizing: border-box;
	}
    .highlight {
        font-size: 23px;
        color: #ff6600;
        font-weight: bold;
        letter-spacing: 0.5px;
    }
    .info-box {
        background: #faf7f2;
        border-radius:8px;
        padding:19px 23px;
        margin: 16px 0 0 0;
        font-size: 15px;
        color: #383838;
        line-height: 1.7;
    }
    .btn-main {
        background: #ff6600;
        color: #fff;
        border: none;
        padding: 12px 0;
        font-size: 18px;
        width: 140px;
        border-radius: 6px;
        cursor: pointer;
        transition: background 0.16s;
        font-family: 'Malgun Gothic', '맑은 고딕', Arial, sans-serif;
        margin-top: 2px;
        font-weight: 500;
        letter-spacing: -1px;
    }
    .btn-main:hover, .btn-cancel:hover { background: #e95c00; }
    .btn-cancel { /* 같은 스타일, 색상만 다르게 쓰지 않음 */
        background: #ff6600;
        color: #fff;
        border: none;
        padding: 12px 0;
        font-size: 18px;
        width: 140px;
        border-radius: 6px;
        cursor: pointer;
        transition: background 0.16s;
        font-family: 'Malgun Gothic', '맑은 고딕', Arial, sans-serif;
        margin-top: 2px;
        font-weight: 500;
        letter-spacing: -1px;
    }
    .btn-group {
        display: flex;
        gap: 15px;
        margin-top: 16px;
    }
    .product-row {
        display: flex;
        gap: 28px;
    }
    .product-info { flex: 2; }
    .image-area {
        flex: 1;
        text-align: left;
        display: flex;
        align-items: center;
        justify-content: flex-start;
        min-width: 140px;
    }
    .image-area img {
        max-width: 160px;
        max-height: 160px;
        border-radius: 10px;
        box-shadow:0 1px 5px rgba(0,0,0,0.09);
        background: #eee;
        margin-left: 5px;
    }
    @media (max-width: 650px) {
        .container { width: 95%; padding: 10px 3vw 16px 3vw; }
        .product-row { flex-direction: column; gap:10px;}
        .image-area { margin-bottom: 7px; }
    }
</style>
</head>
<body>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<div class="container">
    <div class="section">
        <div class="section-title">거래 진행 안내</div>
        <div class="info-box">
            <p>
               <b>아래 정보로 판매자와 만나 직거래를 진행해주세요.</b><br>
				<span class="highlight">
				거래 장소: ${mainLocation.roadAddress} ${mainLocation.detailAddress}
				</span><br>
				현장에서 <span class="highlight">
				    <fmt:formatNumber value="${order.price - order.usedPoint}" pattern="#,###"/>원
				</span>
				을 직접 결제해야 합니다.<br>
                <span style="color:#888; font-size:14px;">※ 포인트 사용분 <fmt:formatNumber value="${order.usedPoint}" pattern="#,###"/>P는 이미 차감되었습니다.</span>
            </p>
        </div>
    </div>

    <div class="section">
        <div class="section-title">상품 정보</div>
        <div class="product-row">
            <div class="product-info">
                <table class="summary-table">
                    <tr>
                        <td class="label">상품명</td>
                        <td>${product.productTitle}</td>
                    </tr>
                    <tr>
                        <td class="label">상품 설명</td>
                        <td>${product.productContent}</td>
                    </tr>
                    <tr>
                        <td class="label">상품가</td>
                        <td><fmt:formatNumber value="${order.price}" pattern="#,###"/>원</td>
                    </tr>
                    <tr>
                        <td class="label">사용 포인트</td>
                        <td><fmt:formatNumber value="${order.usedPoint}" pattern="#,###"/>P</td>
                    </tr>
                    <tr>
                        <td class="label">현장 결제금액</td>
                        <td class="highlight"><fmt:formatNumber value="${order.price - order.usedPoint}" pattern="#,###"/>원</td>
                    </tr>
                </table>
            </div>
            <div class="image-area">
                <c:if test="${not empty product.atList}">
                    <img src="${contextPath}${product.atList[0].filePath}${product.atList[0].changeName}" alt="대표이미지">
                </c:if>
            </div>
        </div>
    </div>

    <div class="section">
        <div class="section-title">거래 정보</div>
        <table class="summary-table">
            <tr>
                <td class="label">구매자명</td>
                <td>${order.buyerName}</td>
            </tr>
            <tr>
                <td class="label">구매자 연락처</td>
                <td>${order.buyerPhone}</td>
            </tr>
            <tr>
                <td class="label">판매자명</td>
                <td>${product.userName}</td>
            </tr>
            <tr>
                <td class="label">판매자 연락처</td>
                <td>${product.userPhone}</td>
            </tr>
			    <tr>
			        <td class="label">만날 장소</td>
			        <td><b>${mainLocation.roadAddress} ${mainLocation.detailAddress}</b></td>
			    </tr>
			    
            <tr>
                <td class="label">거래 요청 메시지</td>
                <td>${order.message}</td>
            </tr>
        </table>
    </div>

    <div class="section">
        <div class="info-box" style="background:#eef5f8; color:#185175;">
            <c:choose>
                <c:when test="${order.status eq 'REQ'}">
                    거래 완료 후 <b>구매확정</b> 버튼을 눌러주시면 포인트와 거래 내역이 최종 확정됩니다.<br>
                    거래 중 불편사항이나 문의는 고객센터로 연락주세요.
                </c:when>
                <c:when test="${order.status eq 'BUYER_OK'}">
                    구매자가 거래확정을 완료했습니다.<br>
                    판매자께서는 <b>판매확정</b> 버튼을 눌러주세요.<br> 
                    버튼 누르지 않을시에 24시간 뒤에 자동으로 판매확정 처리됨을 알려드립니다.
                </c:when>
                <c:when test="${order.status eq 'DONE'}">
                    거래가 최종 완료되었습니다!<br>
                    평점 작성 및 거래내역은 구매페이지에서 확인하세요.
                </c:when>
                <c:when test="${order.status eq 'CANCEL'}">
                    거래가 취소되었습니다.<br>
                    기타 문의사항은 고객센터로 연락주세요.
                </c:when>
            </c:choose>
        </div>
    </div>

    <!-- 버튼 영역 -->
    <div class="btn-group">
        <!-- ✅ 구매자: 거래중(REQ)일 때 -->
        <c:if test="${loginUser.userNo == order.buyerId && order.status eq 'REQ'}">
            <form action="${contextPath}/order/confirmOrder" method="post" style="display:inline;">
                    <input type="hidden" name="orderNo" value="${order.orderNo}">
    				<input type="hidden" name="buyerId" value="${order.buyerId}">
                <button type="submit" class="btn-main">구매확정</button>
            </form>
            <form action="${contextPath}/cancelOrder" method="post" style="display:inline;">
                <input type="hidden" name="orderNo" value="${order.orderNo}">
                <button type="submit" class="btn-cancel">취소하기</button>
            </form>
        </c:if>

        <!-- ✅ 판매자: BUYER_OK일 때 -->
        <c:if test="${loginUser.userNo == order.sellerId && order.status eq 'BUYER_OK'}">
            <form action="${contextPath}/finalizeOrder" method="post" style="display:inline;">
                <input type="hidden" name="orderNo" value="${order.orderNo}">
                <button type="submit" class="btn-main">판매확정</button>
            </form>
            <form action="${contextPath}/cancelOrder" method="post" style="display:inline;">
                <input type="hidden" name="orderNo" value="${order.orderNo}">
                <button type="submit" class="btn-cancel">취소하기</button>
            </form>
        </c:if>

        <!-- ✅ 판매자: REQ 상태일 때 안내 메시지 -->
        <c:if test="${loginUser.userNo == order.sellerId && order.status eq 'REQ'}">
            <div class="info-box" style="background:#fff3cd; color:#856404;">
                구매자의 거래 확정을 기다리는 중입니다.<br>
                구매자가 확정 후, 판매 확정을 진행할 수 있습니다.
            </div>
        </c:if>
        <!-- ✅ 구매자: 구매확정 후(BUYER_OK 상태)일 때 안내 -->
		<c:if test="${loginUser.userNo == order.buyerId && order.status eq 'BUYER_OK'}">
		    <div class="info-box" style="background:#fff3cd; color:#856404;">
		        판매자의 판매 확정을 기다리는 중입니다.<br>
		        거래가 완료되면 구매 페이지에서 평점 작성 및 내역을 확인할 수 있습니다.
		    </div>
		</c:if>
    </div>
</div>
</body>
</html>