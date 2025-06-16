<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>상세페이지</title>
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
    .flex { display: flex; flex-wrap: wrap; }
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
    .info-area h2 { margin-top: 0; font-size: 24px; }
    .price {
        color: #ff6600;
        font-size: 22px;
        font-weight: bold;
        margin: 10px 0;
    }
    .desc { margin: 20px 0; line-height: 1.6; }
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
    .writer-info { font-size: 14px; }
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
    .comment-section { margin-top: 40px; }
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
        background: rgba(0, 0, 0, 0.9);
        z-index: 1000;
        justify-content: center;
        align-items: center;
        cursor: pointer;
    }
    #imageModalContent {
        background: none;
        padding: 0;
        text-align: center;
        position: relative;
    }
    #modalImage {
        max-width: 90%;
        max-height: 90%;
        object-fit: contain;
    }
    .arrow {
        position: absolute;
        top: 50%;
        transform: translateY(-50%);
        color: white;
        font-size: 50px;
        font-weight: bold;
        cursor: pointer;
        user-select: none;
        z-index: 1001;
        padding: 0 15px;
    }
    #leftArrow { left: 0; }
    #rightArrow { right: 0; }
    .close-btn {
        position: absolute;
        top: 25px;
        right: 40px;
        font-size: 40px;
        color: white;
        font-weight: bold;
        cursor: pointer;
        z-index: 2001;
        user-select: none;
        background: transparent;
        border: none;
        padding: 0;
        line-height: 1;
    }
</style>
</head>
<body>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="product" value="${product}" />

<div class="container">
    <div class="flex">
        <!-- 이미지 -->
        <div class="image-area">
            <c:if test="${not empty product.atList}">
                <img id="main-image" src="${contextPath}${product.atList[0].filePath}${product.atList[0].changeName}" alt="대표이미지">
            </c:if>
        </div>

        <!-- 정보 -->
        <div class="info-area">
            <div class="meta" style="font-weight:bold; color:#888;">
                ${product.categoryName}
            </div>
            <h2>${product.productTitle}</h2>
            <div class="meta">
                ${product.userName} · 
                <fmt:formatDate value="${product.uploadDate}" pattern="yyyy-MM-dd" /> 
            </div>
            <div class="price">
                <fmt:formatNumber value="${product.price}" pattern="#,###" />원
            </div>
            <div class="desc"><pre>${product.productContent}</pre>
			</div>

            <!-- 좋아요 -->
            <div class="like-area">
                채팅 0 · 조회 ${product.productCount}
                <form id="wishForm" style="display:inline;">
                    <input type="hidden" id="productNo" value="${product.productNo}" />
                    <button type="button" onclick="wishProduct();" class="like-btn">
                        ❤️ 좋아요 (<span id="wishCount">${wishCount}</span>)
                    </button>
                </form>
            </div>

            <!-- 일반 유저만 -->
            <c:if test="${not empty loginUser and loginUser.roleType != 'superAdmin' and loginUser.roleType != 'admin' and loginUser.roleType != 'viewer'}">
	           <c:if test="${loginUser.userNo ne product.userNo and not alreadyChatted}">
	                <form action="${pageContext.request.contextPath}/chat/room" method="get" style="margin-bottom: 10px;">
					    <input type="hidden" name="productNo" value="${product.productNo}" />
					    <input type="hidden" name="sellerNo" value="${product.userNo}" />
					    <button type="submit" class="action-btn" style="width:100%;">💬 채팅으로 거래하기</button>
					</form>
			  	</c:if>
	
	                <!-- 구매하기 -->
	            <c:if test="${loginUser.userNo ne product.userNo}">   
                <form action="${contextPath}/buyProduct" method="get">
                    <input type="hidden" name="productNo" value="${product.productNo}" />
                    <input type="hidden" name="buyerId" value="${loginUser.userNo}" />
                    <button type="submit" class="action-btn" style="width:100%;">💳 이 상품 구매하기</button>
                </form>
                </c:if>
            </c:if>


            <!-- 수정  삭제 버튼 -->
            <c:if test="${loginUser.userId eq product.userId}">
                <div style="margin-top: 15px; display: flex; justify-content: flex-end; gap: 10px;">
           	   <form method="get" action="${contextPath}/update.pro" style="display:inline;">
			        <input type="hidden" name="productNo" value="${product.productNo}" />
			        <button type="submit" class="action-btn" style="width:auto;">수정하기</button>
			    </form>
                <form id="deleteForm" method="post" action="${contextPath}/delete.pro">
                    <input type="hidden" name="productNo" value="${product.productNo}" />
                    <input type="hidden" name="filePath" value="/resources/uploadFiles/${product.atList[0].changeName}" />
                <button type="button" id="deleteBtn" class="action-btn" style="width:auto;">삭제하기</button>
                </form>
             </div>   
            </c:if>

        </div>
    </div>

    <!-- 작성자 -->
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

    <!-- 댓글 -->
    <div class="comment-section">
        <h4>💬 댓글</h4>
        <div class="mb-3">
            <textarea id="replyContent" class="form-control" placeholder="댓글을 입력하세요" rows="3" style="width:100%;"></textarea>
            <button onclick="insertReply();" type="button" class="btn btn-primary mt-2">등록</button>
        </div>
        <div id="replyArea" class="mt-3"></div>
    </div>
</div>

<!-- 상세 이미지 리스트 -->
<c:set var="count" value="0" />
<c:forEach var="img" items="${product.atList}">
    <c:if test="${img.fileLevel == 2 and count lt 3}">
        <div class="slide-image" data-src="${contextPath}${img.filePath}${img.changeName}"></div>
        <c:set var="count" value="${count + 1}" />
    </c:if>
</c:forEach>

<!-- 모달 -->
<div id="imageModal">
    <span id="closeModalBtn" class="close-btn">&times;</span>
    <div id="leftArrow" class="arrow">&#10094;</div>
    <div id="imageModalContent">
        <h4>상세 이미지</h4>
        <img id="modalImage" src="" alt="상세 이미지">
    </div>
    <div id="rightArrow" class="arrow">&#10095;</div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
let detailImages = [];
let currentIndex = 0;

let isManager = ${loginUser.roleType != "N"};
let currUserId = "${loginUser.userId}";

$(function () {
    $("#deleteBtn").click(function () {
        if (confirm("정말로 삭제하시겠습니까?")) {
            $("#deleteForm").submit();
        }
    });

    $("#main-image").on("click", function () {
        detailImages = $(".slide-image").map(function () {
            return $(this).data("src");
        }).get();

        if (detailImages.length === 0) {
            alert("상세 이미지가 없습니다.");
            return;
        }

        currentIndex = 0;
        $("#modalImage").attr("src", detailImages[currentIndex]);
        $("#imageModal").css("display", "flex");
    });

    $("#leftArrow").on("click", function (e) {
        e.stopPropagation();
        if (detailImages.length > 0) {
            currentIndex = (currentIndex - 1 + detailImages.length) % detailImages.length;
            $("#modalImage").attr("src", detailImages[currentIndex]);
        }
    });

    $("#rightArrow").on("click", function (e) {
        e.stopPropagation();
        if (detailImages.length > 0) {
            currentIndex = (currentIndex + 1) % detailImages.length;
            $("#modalImage").attr("src", detailImages[currentIndex]);
        }
    });

    $("#closeModalBtn").on("click", function (e) {
        e.stopPropagation();
        closeModal();
    });
});

function closeModal() {
    $("#imageModal").hide();
}

function wishProduct() {
	if(currUserId == "${product.userId}"){
		alert("자신의 물품에 좋아요를 누를 수 없습니다.");
		return;
	}
	
    const productNo = $("#productNo").val();
    $.post("${contextPath}/product/wish", { productNo: productNo }, function(result) {
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
            if (!Array.isArray(list) || list.length === 0) {
                $("#replyArea").html("<p>댓글이 없습니다.</p>");
                return;
            }
            let str = "";
            for (let r of list) {
                const uid = r.userId || "";
                const txt = r.replyText || "";
                const dt = r.replyDate ? new Date(r.replyDate).toLocaleString('ko-KR') : "";
                str += '<div class="comment-box">';
                
                if(uid==currUserId){
                    str += '<b style="color: #ff6600;">나</b>: <span class="reply-text">' + txt + '</span>';
                }else if(uid =="${product.userId}"){
                    str += '<b style="color: #ff6600;">작성자</b>: <span class="reply-text">' + txt + '</span>';
                }else{
	                str += '<b>' + uid + '</b>: <span class="reply-text">' + txt + '</span>';
                }
                
                str += ' <span style="color:gray;">[' + dt + ']</span>';
                if (isManager || currUserId == r.userId) {
                    str += '<div class="btn-group ms-2">';
                    str += '<button class="edit-btn btn btn-outline-primary btn-sm" data-id="' + r.replyNo + '">수정</button>';
                    str += '<button class="delete-btn btn btn-outline-danger btn-sm" data-id="' + r.replyNo + '">삭제</button>';
                    str += '</div>';
                }
                str += '</div>';
            }
            $("#replyArea").html(str);
        },
        error: function(xhr) {
            console.log("댓글 목록 호출 실패: HTTP " + xhr.status);
        }
    });
}

// 수정 버튼 핸들러
$('#replyArea').on('click', '.edit-btn', function() {
    const commentBox = $(this).closest('.comment-box');
    const replyNo = $(this).data('id');
    const replyTextElem = commentBox.find('.reply-text');
    const originalText = replyTextElem.text().trim();

    let editForm = commentBox.find('.edit-form');
    if (editForm.length > 0) {
        // 이미 폼이 있으면 show만!
        editForm.show();
        // textarea 값도 원본으로 복구
        editForm.find('textarea').val(originalText);
        return;
    }

    // 폼이 없으면 새로 생성
    const formHtml = `
        <div class="edit-form mt-2">
            <textarea class="form-control mb-2" rows="3">\${originalText}</textarea>
            <button class="btn btn-sm btn-primary edit-confirm me-1">확인</button>
            <button class="btn btn-sm btn-secondary edit-cancel">취소</button>
        </div>
    `;
    commentBox.append(formHtml);
});


//수정 확인 버튼 핸들러
$('#replyArea').on('click', '.edit-confirm', function() {
    const replyNo = $(this).closest('.comment-box').find('.edit-btn').data('id');
    const newText = $(this).siblings('textarea').val().trim();
    const editForm = $(this).closest('.edit-form');
    
    if(newText === "") {
        alert("댓글 내용을 입력하세요.");
        return;
    }
    
    $.ajax({
        url: '${root}/updateReply',
        method: 'POST',
        data: { 
            userId: '${loginUser.userId}',
            replyNo: replyNo,
            replyText: newText  // 수정된 내용 추가
        },
        success: function(result) {
            if(result === 'success') {
                selectReplyList(); // 목록 재갱신
            }
            editForm.remove();  // 수정 폼 제거
        }
    });
});

//수정 취소 버튼 핸들러
$('#replyArea').on('click', '.edit-cancel', function() {
    $(this).closest('.edit-form').hide();
});

//삭제 버튼 핸들러
$('#replyArea').on('click', '.delete-btn', function() {
    const replyNo = $(this).data('id');
    if(confirm('정말 삭제하시겠습니까?')) {
        $.ajax({
            url: '${root}/deleteReply',
            method: 'POST',
            data: { 
                userId: '${loginUser.userId}',
                replyNo: replyNo
            },
            success: function(result) {
                if(result === 'success') {
                    selectReplyList(); // 목록 재갱신
                    alert('삭제 완료');
                }
            }
        });
    }
});

$(document).ready(function() {
    selectReplyList();
});
</script>
</body>
</html>