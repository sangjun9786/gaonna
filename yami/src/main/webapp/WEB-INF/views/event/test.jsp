<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 필요한 경우 JQuery CDN 또는 로컬 경로 추가 --%>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<button type="button" id="openRatingModalBtn" class="btn btn-primary">판매자 평점 남기기</button>

<div id="ratingModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2>평점 입력</h2>
            <span class="close">&times;</span>
        </div>
        <div class="modal-body">
            <p>판매자에게 평점을 남겨주세요 (1~5)</p>
            <input type="number" id="sellerScoreInput" min="1" max="5" value="3" class="form-control">
            <input type="hidden" id="modalUserNo" value="">
        </div>
        <div class="modal-footer">
            <button type="button" id="submitRatingBtn" class="btn btn-success">확인</button>
            <button type="button" id="closeRatingModalBtn" class="btn btn-secondary">닫기</button>
        </div>
    </div>
</div>

<style>
/* 모달 CSS */
.modal {
    display: none; /* 초기에는 숨김 */
    position: fixed; /* 뷰포트에 고정 */
    z-index: 1000; /* 다른 요소 위에 표시 */
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto; /* 내용이 넘칠 경우 스크롤 */
    background-color: rgba(0,0,0,0.4); /* 반투명 검정 배경 */
    display: flex; /* Flexbox를 사용하여 중앙 정렬 */
    justify-content: center; /* 수평 중앙 정렬 */
    align-items: center; /* 수직 중앙 정렬 */
}

.modal-content {
    background-color: #fefefe;
    margin: auto; /* display:flex와 함께 사용 시 중앙 정렬에 영향 */
    padding: 20px;
    border: 1px solid #888;
    width: 80%; /* 모달 너비 */
    max-width: 500px; /* 최대 너비 설정 */
    border-radius: 8px; /* 둥근 모서리 */
    box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2), 0 6px 20px 0 rgba(0,0,0,0.19);
    animation-name: animatetop;
    animation-duration: 0.4s
}

/* 모달 등장 애니메이션 */
@keyframes animatetop {
    from {top: -300px; opacity: 0}
    to {top: 0; opacity: 1}
}

.modal-header {
    padding: 10px 0;
    border-bottom: 1px solid #eee;
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 15px;
}

.modal-header h2 {
    margin: 0;
    font-size: 1.5em;
    color: #333;
}

.modal-body {
    padding: 10px 0;
    text-align: center;
}

.modal-body p {
    margin-bottom: 15px;
    font-size: 1.1em;
    color: #555;
}

.modal-body input[type="number"] {
    width: 80px; /* 입력 필드 너비 조정 */
    padding: 8px 12px;
    margin: 0 auto; /* 중앙 정렬 */
    display: block; /* 블록 요소로 만들어 중앙 정렬 가능하게 */
    border: 1px solid #ccc;
    border-radius: 4px;
    font-size: 1.2em;
    text-align: center;
    -moz-appearance: textfield; /* Firefox에서 숫자 입력 화살표 제거 */
}

/* Chrome, Safari, Edge에서 숫자 입력 화살표 제거 */
input[type="number"]::-webkit-outer-spin-button,
input[type="number"]::-webkit-inner-spin-button {
    -webkit-appearance: none;
    margin: 0;
}


.modal-footer {
    padding: 15px 0 0;
    border-top: 1px solid #eee;
    text-align: right;
    margin-top: 20px;
}

.modal-footer button {
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    font-size: 1em;
    margin-left: 10px;
    transition: background-color 0.3s ease;
}

.modal-footer .btn-success {
    background-color: #28a745;
    color: white;
}

.modal-footer .btn-success:hover {
    background-color: #218838;
}

.modal-footer .btn-secondary {
    background-color: #6c757d;
    color: white;
}

.modal-footer .btn-secondary:hover {
    background-color: #5a6268;
}

.close {
    color: #aaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
    cursor: pointer;
}

.close:hover,
.close:focus {
    color: black;
    text-decoration: none;
}
</style>

<script>
// JavaScript for Modal
$(document).ready(function() {
    // DOM 요소 가져오기 (jQuery 사용)
    const modal = $('#ratingModal');
    const openBtn = $('#openRatingModalBtn');
    const closeSpan = $('.close');
    const closeBtn = $('#closeRatingModalBtn');
    const submitBtn = $('#submitRatingBtn');
    const scoreInput = $('#sellerScoreInput');
    const modalUserNoInput = $('#modalUserNo');

    // 모달 열기 버튼 클릭 시
    openBtn.on('click', function() {
        // userNo를 동적으로 설정해야 한다면, 여기에 userNo 값을 설정
        // 예시: const sellerUserNo = '판매자의 userNo 값';
        // modalUserNoInput.val(sellerUserNo);
        // 실제 userNo를 받아오는 로직을 여기에 추가해야 합니다.
        // 예를 들어, 버튼 클릭 시 데이터를 전달하거나, 페이지 로드 시 어딘가에 저장된 값을 가져오는 방식
        // 지금은 임시로 '123'을 넣어두겠습니다.
        modalUserNoInput.val('123'); // TODO: 실제 userNo 값으로 변경 필요
        modal.css('display', 'flex'); // flex로 설정하여 중앙 정렬
    });

    // 닫기 버튼 (X 버튼) 클릭 시 모달 닫기
    closeSpan.on('click', function() {
        modal.css('display', 'none');
        // 모달 닫을 때 input 값 초기화
        scoreInput.val(3);
    });

    // 닫기 버튼 클릭 시 모달 닫기
    closeBtn.on('click', function() {
        modal.css('display', 'none');
        // 모달 닫을 때 input 값 초기화
        scoreInput.val(3);
    });

    // 모달 외부 클릭 시 모달 닫기
    $(window).on('click', function(event) {
        if ($(event.target).is(modal)) {
            modal.css('display', 'none');
            // 모달 닫을 때 input 값 초기화
            scoreInput.val(3);
        }
    });

    // 확인 버튼 클릭 시 평점 제출
    submitBtn.on('click', function() {
        const userNo = modalUserNoInput.val(); // Hidden 필드에서 userNo 가져오기
        const score = +scoreInput.val(); // 점수 가져오기 (+를 사용하여 숫자로 변환)

        // 유효성 검사 (1~5 정수)
        if (isNaN(score) || score < 1 || score > 5 || !Number.isInteger(score)) {
            alert("평점은 1~5 사이의 정수여야 합니다.");
            return;
        }

        // Ajax 요청 (제공해주신 submitRating 함수 로직 활용)
        $.post('${pageContext.request.contextPath}/insertRating.rt', {
            userNo: userNo,
            score: score
        })
        .done(function(response) {
            alert("평점이 등록되었습니다.");
            modal.css('display', 'none'); // 성공 시 모달 닫기
            scoreInput.val(3); // input 값 초기화
            // 필요하다면, 평점 등록 후 페이지 내용 업데이트 등의 추가 작업 수행
        })
        .fail(function(jqXHR, textStatus, errorThrown) {
            alert("평점 등록 실패: " + textStatus);
            console.error("평점 등록 실패:", jqXHR.responseText);
        });
    });
});
</script>