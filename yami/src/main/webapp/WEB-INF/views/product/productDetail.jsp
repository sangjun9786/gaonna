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
        width: 100%;
        margin-top: 20px;
        font-size: 16px;
        cursor: pointer;
        border-radius: 4px;
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
            <%-- 이미지 리스트는 현재 Product VO에 atList가 없어 주석처리
            <img src="${contextPath}${product.atList[0].filePath}${product.atList[0].changeName}" alt="대표이미지">
            --%>
        </div>

        <!-- 상품 정보 영역 -->
        <div class="info-area">
            <div class="meta" style="font-weight:bold; color:#888;">
                ${product.categoryNo}번 카테고리
            </div>

            <h2>${product.productTitle}</h2>
            <div class="meta">${product.userNo} · <fmt:formatDate value="${product.uploadDate}" pattern="yyyy-MM-dd" /></div>
            <div class="price">
                <fmt:formatNumber value="${product.price}" pattern="#,###" />원
            </div>
            <div class="desc">${product.productContent}</div>

            <!-- 찜(좋아요) 버튼 영역 -->
            <div class="like-area">
                채팅 0 · 조회 0
                <form id="wishForm" style="display:inline;">
                    <input type="hidden" id="productNo" value="${product.productNo}" />
                    <button type="button" onclick="wishProduct();" class="like-btn">
                        ❤️ 좋아요 (<span id="wishCount">0</span>)
                    </button>
                </form>
            </div>

            <button class="action-btn">채팅으로 거래하기</button>
        </div>
    </div>

    <!-- 작성자 정보 + 평점 -->
    <div class="writer-box">
        <div class="writer-info">
            <strong>${product.userNo}</strong><br>
            지역정보 없음
        </div>
        <div class="score">
            ★ <fmt:formatNumber value="${product.score}" pattern="#.0" /> / 5.0<br>
            <span style="font-size: 12px; color: #666;">판매자 평점</span>
        </div>
    </div>



        <!-- ▼ 댓글 영역 시작 ▼ -->
    <div class="comment-section">
        <h4>💬 댓글</h4>

        <!-- 댓글 입력란 -->
        <div class="mb-3">
            <textarea id="replyContent" class="form-control"
                      placeholder="댓글을 입력하세요" rows="3"
                      style="width:100%;"></textarea>
            <button onclick="insertReply();" type="button"
                    class="btn btn-primary mt-2">등록</button>
        </div>

        <!-- AJAX로 댓글 목록을 뿌려줄 컨테이너 (반드시 id="replyArea") -->
        <div id="replyArea" class="mt-3">
            <!-- selectReplyList()가 만들어 주는 댓글 HTML을 여기다 삽입 -->
        </div>
    </div>
    <!-- ▲ 댓글 영역 끝 ▲ -->
</div>

<!-- jQuery 라이브러리 (반드시 댓글 스크립트보다 먼저 로드) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- 🧠 찜(좋아요) 기능용 스크립트 -->
<script>
function wishProduct() {
    const productNo = $("#productNo").val();

    $.post("${contextPath}/product/wish", { productNo: productNo }, function(result) {
        if (result === "not-login") {
            alert("로그인 후 이용하세요.");
        } else {
            const [state, count] = result.split(":");
            $("#wishCount").text(count);
            alert(state === "liked" ? "찜 완료!" : "찜 취소됨");
        }
    });
}
</script>


<script>
    /**
     * 댓글 등록 함수 (등록 버튼 클릭 시 호출)
     */
    function insertReply() {
        $.ajax({
            url: "${contextPath}/insertReply",
            method: "post",
            data: {
                productNo: "${product.productNo}",   // JSP EL로 1회 치환 → 실제 값: “1”
                replyText: $("#replyContent").val()
                // userId는 JSP에서 보내지 말 것 (컨트롤러가 세션에서 꺼내도록 처리했으니까)
            },
            success: function(result) {
                console.log("▶ insertReply 결과:", result);
                if (result === "success") {
                    // 댓글 등록 성공 시, 댓글 리스트를 다시 불러오기
                    selectReplyList();
                    $("#replyContent").val("");  // 입력창 초기화
                } else {
                    alert("❌ 댓글 등록 실패 (로그인 상태인지 확인하세요)");
                }
            },
            error: function(xhr) {
                alert("⚠️ 댓글 등록 중 오류 발생: HTTP " + xhr.status);
            }
        });
    }

    /**
     * 댓글 목록을 Ajax로 가져와서 #replyArea에 렌더링
     * (페이지 첫 로드 및 댓글 등록 성공 후 호출)
     */
    function selectReplyList() {
        $.ajax({
            url: "${contextPath}/replyList",
            data: { productNo: "${product.productNo}" },
            success: function(list) {
                console.log("▶ selectReplyList()에 내려온 데이터:", list);

                // ① 서버가 비정상 응답하거나 빈 배열일 때
                if (!Array.isArray(list) || list.length === 0) {
                    $("#replyArea").html("<p>댓글이 없습니다.</p>");
                    return;
                }

                // ② 댓글 배열이 있으면 HTML 조각을 만들어 붙임
                let str = "";
                for (let r of list) {
                    // r.userId, r.replyText, r.replyDate 값이 undefined인 경우 공백 처리
                    const uid = r.userId    ? r.userId    : "";
                    const txt = r.replyText ? r.replyText : "";
                    const dt = r.replyDate 
                    ? new Date(r.replyDate).toLocaleString('ko-KR') 
                    : ""; 
                    str += 
                        '<div class="comment-box">'
                          + '<b>' + uid + '</b>: ' + txt
                          + ' <span style="color:gray;">[' + dt + ']</span>'
                        + '</div>';
                }
                $("#replyArea").html(str);
            },
            error: function(xhr) {
                console.log("댓글 목록 호출 실패. HTTP " + xhr.status);
            }
        });
    }

    // 페이지 로드 후 즉시 댓글 목록을 한 번 가져온다
    $(document).ready(function() {
        selectReplyList();
    });
</script>
</body>
</html>