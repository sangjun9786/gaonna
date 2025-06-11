<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>상품 상세보기</title>
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
        cursor: pointer;
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
    #imageModal {
        display: none;
        position: fixed;
        top: 0; left: 0;
        width: 100%; height: 100%;
        background: rgba(0,0,0,0.8);
        z-index: 1000;
        justify-content: center;
        align-items: center;
    }
    #imageModalContent {
        background: white;
        padding: 20px;
        border-radius: 10px;
        max-width: 90%;
        max-height: 90%;
        overflow: auto;
        text-align: center;
    }
    #modal-images img {
        width: 300px;
        height: 250px;
        object-fit: cover;
        margin: 10px;
        border-radius: 5px;
        border: 1px solid #ccc;
        display: none;
    }
    #modal-controls {
        margin-top: 15px;
    }
</style>
</head>
<body>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="product" value="${product}" />

<div class="container">
    <div class="flex">
        <div class="image-area">
            <c:if test="${not empty product.atList}">
                <img src="${contextPath}${product.atList[0].filePath}${product.atList[0].changeName}" alt="대표이미지" id="main-image">
            </c:if>
        </div>
        <div class="info-area">
            <div class="meta" style="font-weight:bold; color:#888;">${product.categoryName}</div>
            <h2>${product.productTitle}</h2>
            <div class="meta">
                ${product.userId} · <fmt:formatDate value="${product.uploadDate}" pattern="yyyy-MM-dd" /> · 조회수: ${product.productCount}
            </div>
            <div class="price"><fmt:formatNumber value="${product.price}" pattern="#\,###" />원</div>
            <div class="desc">${product.productContent}</div>
            <div class="like-area">
                채팅 0 · 조회 ${product.productCount}
                <form id="wishForm" style="display:inline;">
                    <input type="hidden" id="productNo" value="${product.productNo}" />
                    <button type="button" onclick="wishProduct();" class="like-btn">❤️ 좋아요 (<span id="wishCount">${wishCount}</span>)</button>
                </form>
            </div>
            <button class="action-btn" style="width:100%;">채팅으로 거래하기</button>
            <c:if test="${loginUser.userId eq product.userId}">
                <form id="deleteForm" method="post" action="${contextPath}/delete.pro" style="display:none;">
                    <input type="hidden" name="productNo" value="${product.productNo}" />
                    <input type="hidden" name="filePath" value="/resources/uploadFiles/${product.atList[0].changeName}" />
                </form>
                <button type="button" id="deleteBtn" class="action-btn" style="width:auto; float:right;">삭제하기</button>
            </c:if>
        </div>
    </div>

    <div class="writer-box">
        <div class="writer-info">
            <strong>${product.userId}</strong><br>${product.coordAddress}
        </div>
        <div class="score">★ <fmt:formatNumber value="${product.score}" pattern="#.0" /> / 5.0<br><span style="font-size: 12px; color: #666;">판매자 평점</span></div>
    </div>

    <div class="comment-section">
        <h4>💬 댓글</h4>
        <div class="mb-3">
            <textarea id="replyContent" class="form-control" placeholder="댓글을 입력하세요" rows="3"></textarea>
            <button onclick="insertReply();" type="button" class="btn btn-primary mt-2">등록</button>
        </div>
        <div id="replyArea" class="mt-3"></div>
    </div>

    <div id="hidden-images" style="display:none;">
        <c:forEach var="img" items="${product.atList}">
            <c:if test="${img.fileLevel == 2}">
                <div class="detail-image-path" data-src="${contextPath}${img.filePath}${img.changeName}"></div>
            </c:if>
        </c:forEach>
    </div>

    <div id="imageModal" class="modal">
        <div id="imageModalContent">
            <h4>상세 이미지</h4>
            <div id="modal-images"></div>
            <div id="modal-controls">
                <button onclick="prevImage()" class="btn btn-outline-secondary">이전</button>
                <button onclick="nextImage()" class="btn btn-outline-secondary">다음</button>
                <button onclick="closeModal()" class="btn btn-secondary">닫기</button>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
let currentIndex = 0;
let imageElements = [];

$(function () {
    $("#deleteBtn").click(function () {
        if (confirm("정말로 삭제하시겠습니까?")) {
            $("#deleteForm").submit();
        }
    });

    $("#main-image").on("click", function () {
        imageElements = [];
        $(".detail-image-path").each(function () {
            imageElements.push($(this).data("src"));
        });

        const container = $("#modal-images");
        container.empty();

        imageElements.forEach((src, index) => {
            const img = $(`<img src="${src}" alt="상세이미지">`);
            if (index === 0) img.show();
            container.append(img);
        });

        currentIndex = 0;
        $("#imageModal").css("display", "flex");
    });
});

function closeModal() {
    $("#imageModal").hide();
}

function prevImage() {
    const images = $("#modal-images img");
    if (currentIndex > 0) {
        $(images[currentIndex]).hide();
        currentIndex--;
        $(images[currentIndex]).show();
    }
}

function nextImage() {
    const images = $("#modal-images img");
    if (currentIndex < images.length - 1) {
        $(images[currentIndex]).hide();
        currentIndex++;
        $(images[currentIndex]).show();
    }
}

function wishProduct() {
    const productNo = $("#productNo").val();
    $.post("${contextPath}/product/wish", { productNo }, function(result) {
        if (result === "not-login") {
            alert("로그인 후 이용하세요.");
        } else {
            const [state, count] = result.split(":");
            $("#wishCount").text(count);
            alert(state === "liked" ? "좋아요 완료!" : "좋아요 취소됨");
        }
    });
}

function insertReply() {
    $.ajax({
        url: "${contextPath}/insertReply",
        method: "post",
        data: {
            productNo: "${product.productNo}",
            replyText: $("#replyContent").val()
        },
        success: function(result) {
            if (result === "success") {
                selectReplyList();
                $("#replyContent").val("");
            } else {
                alert("이용하려면 로그인 필요");
            }
        },
        error: function(xhr) {
            alert("댓글 등록 오류: HTTP " + xhr.status);
        }
    });
}

function selectReplyList() {
    $.ajax({
        url: "${contextPath}/replyList",
        data: { productNo: "${product.productNo}" },
        success: function(list) {
            let str = "";
            if (!Array.isArray(list) || list.length === 0) {
                str = "<p>댓글이 없습니다.</p>";
            } else {
                for (let r of list) {
                    const dt = r.replyDate ? new Date(r.replyDate).toLocaleString('ko-KR') : "";
                    str += `<div class="comment-box"><b>${r.userId}</b>: ${r.replyText} <span style="color:gray;">[${dt}]</span></div>`;
                }
            }
            $("#replyArea").html(str);
        },
        error: function(xhr) {
            console.log("댓글 목록 호출 실패: HTTP " + xhr.status);
        }
    });
}

$(document).ready(function() {
    selectReplyList();
});
</script>
</body>
</html>