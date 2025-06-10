<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>상품 상세보기</title>
<style>
    body {
        font-family: '맑은 고딕', sans-serif;
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
    .flex {
        display: flex;
        flex-wrap: wrap;
    }
    .image-area {
        width: 50%;
        padding: 10px;
    }
    .image-area img {
        width: 100%;
        border-radius: 10px;
        border: 1px solid #ddd;
    }
    .info-area {
        width: 50%;
        padding: 10px;
    }
    .info-area h2 {
        margin-top: 0;
        font-size: 24px;
    }
    .price {
        color: #ff6600;
        font-size: 22px;
        font-weight: bold;
        margin: 10px 0;
    }
    .desc {
        margin: 20px 0;
        line-height: 1.6;
    }
    .meta {
        font-size: 13px;
        color: gray;
        margin-bottom: 10px;
    }
    .writer-box {
        margin-top: 30px;
        padding-top: 15px;
        border-top: 1px solid #eee;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .writer-info {
        font-size: 14px;
    }
    .score {
        text-align: right;
        color: #ff6600;
        font-weight: bold;
    }
    .action-btn {
        background-color: #ff6600;
        color: white;
        border: none;
        padding: 12px;
        font-size: 16px;
        cursor: pointer;
        border-radius: 4px;
        margin-top: 10px;
    }
    .comment-section {
        margin-top: 40px;
    }
    .comment-box {
        margin-top: 10px;
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 6px;
    }
    .like-area {
        text-align: right;
        margin-top: 10px;
    }
    .like-btn {
        background: none;
        border: none;
        color: #ff6600;
        cursor: pointer;
        font-weight: bold;
    }
</style>
</head>
<body>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="product" value="${product}" />

<div class="container">
    <div class="flex">
        <!-- 상품 이미지 영역 -->
        <div class="image-area">
            <c:if test="${not empty product.atList}">
                <img src="/resources/uploadFiles/${product.atList[0].changeName}" alt="대표이미지">
            </c:if>
        </div>

        <!-- 상품 정보 영역 -->
        <div class="info-area">
            <div class="meta" style="font-weight:bold; color:#888;">
                ${product.categoryName}
            </div>

            <h2>${product.productTitle}</h2>
            <div class="meta">
                ${product.userId} · 
                <fmt:formatDate value="${product.uploadDate}" pattern="yyyy-MM-dd" /> · 
                조회수: ${product.productCount}
            </div>

            <div class="price">
                <fmt:formatNumber value="${product.price}" pattern="#,###" />원
            </div>
            <div class="desc">${product.productContent}</div>

            <div class="like-area">
                채팅 0 · 조회 ${product.productCount}
                <form action="${contextPath}/like.do" method="post" style="display:inline;">
                    <input type="hidden" name="productNo" value="${product.productNo}">
                    <button type="submit" class="like-btn">❤️ 좋아요 (0)</button>
                </form>
            </div>

            <button class="action-btn" style="width:100%;">채팅으로 거래하기</button>

            <!-- 삭제 버튼 (작성자 본인일 경우에만 노출) -->
		<c:if test="${loginUser.userId eq product.userId}">
		   <form id="deleteForm" method="post" action="${contextPath}/delete.pro" style="display:none;">
		       <input type="hidden" name="productNo" value="${product.productNo}" />
		       <input type="hidden" name="filePath" value="/resources/uploadFiles/${product.atList[0].changeName}" />
		   </form>
		   <button type="button" id="deleteBtn" class="action-btn" style="width:auto; float:right;">삭제하기</button>
		</c:if>
        </div>
    </div>

    <!-- 작성자 정보 + 평점 -->
    <div class="writer-box">
        <div class="writer-info">
            <strong>${product.userId}</strong><br>
            ${product.coordAddress}
        </div>
        <div class="score">
            ★ <fmt:formatNumber value="${product.score}" pattern="#.0" /> / 5.0<br>
            <span style="font-size: 12px; color: #666;">판매자 평점</span>
        </div>
    </div>

    <!-- 댓글 영역 -->
    <div class="comment-section">
        <h4>댓글</h4>

        <%-- <c:forEach var="c" items="${product.commentList}">
            <div class="comment-box">${c.content}</div>
        </c:forEach> --%>

        <form action="${contextPath}/insertComment.co" method="post" style="margin-top:20px;">
            <input type="hidden" name="productNo" value="${product.productNo}">
            <textarea name="content" rows="3" style="width:100%;" placeholder="댓글을 입력하세요"></textarea><br>
            <button type="submit" class="action-btn" style="width:auto;">등록</button>
        </form>
    </div>
</div>

<!-- 삭제 스크립트 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(function () {
        $("#deleteBtn").click(function () {
            if (confirm("정말로 삭제하시겠습니까?")) {
                $("#deleteForm").submit();
            }
        });
    });
</script>

</body>
</html>
