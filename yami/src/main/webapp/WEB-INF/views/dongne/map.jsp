<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=85oq183idp"></script>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<meta charset="UTF-8">
<title>동네 한바퀴</title>
<style>
    #map { margin: 30px auto; border-radius: 20px; }
    .bakery-marker { cursor: pointer; }
    .modal-dialog-scrollable { max-height: 90vh; }
    .comment-card { margin-bottom: 0.5rem;  position: relative; z-index: 1;
    	transition: transform 0.2s, box-shadow 0.2s; cursor: pointer; background: #ffffff;}
    .comment-card:hover {transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); background: #fff9e6;}
    .recomment-card { margin-left: 2rem; background: #fff8e1; cursor: pointer; transition: background 0.2s;}
    .recomment-card:hover { background: #fff3cd;}
    .comment-content { font-size: 1.05rem; }
    .comment-meta { font-size: 0.85rem; color: #888; }
    .comment-actions { margin-top: 0.3rem; }
    .loading-spinner { display: inline-block; width: 1.2em; height: 1.2em; }
    .modal-header .btn-close { margin: -0.5rem -0.5rem -0.5rem auto; }
    .modal-backdrop { opacity: 0.4 !important; }
    
	.modal-dialog-scrollable .modal-body {
	    overflow-y: visible; /* 기존 auto → visible로 변경 */
	}
	#commentArea {
	    max-height: none !important; /* 고정 높이 제거 */
	    overflow-y: visible;
	}
    
</style>
</head>
<body>
<%@include file="/WEB-INF/views/common/header.jsp"%>

<div class="container mt-5">
    <!-- 제목 섹션 -->
    <div class="text-center mb-4 p-4 bg-warning bg-opacity-10 rounded-3 shadow-sm">
        <h2 class="display-3 fw-bold text-warning">
            <i class="bi bi-geo-alt-fill me-2"></i>
            우리 동네 빵집
        </h2>
        <p class="lead text-muted mt-2">우리동네 빵집 정보를 공유해요</p>
    </div>

    <!-- 지도 컨테이너 -->
        <div class="card-body p-0">
            <div id="map" style="width: 100%; height: 600px;"></div>
        </div>
</div>


<!-- 빵집 정보 및 댓글 모달 -->
<div class="modal fade" id="bakeryModal" tabindex="-1" aria-labelledby="bakeryModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
        <div class="w-100 d-flex align-items-center">
          <h5 class="modal-title flex-grow-1" id="bakeryModalLabel"></h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
      </div>
      <div class="modal-body">
        <!-- 빵집 정보 -->
        <div id="bakeryInfo" class="mb-3"></div>
        <!-- 댓글/대댓글 영역 -->
        <div id="commentArea" style="max-height: 350px; overflow-y: auto;"></div>
        <div id="commentLoadMore" class="text-center my-2" style="display:none;">
          <button class="btn btn-outline-secondary btn-sm" id="btnLoadMoreComments">댓글 불러오기</button>
        </div>
      </div>
      <div class="modal-footer flex-column align-items-stretch">
        <div id="commentWriteArea" class="w-100"></div>
      </div>
    </div>
  </div>
</div>

<script>
const loginUser = {
    userNo: '${sessionScope.loginUser.userNo}',
    mainCoord: '${sessionScope.loginUser.mainCoord}',
    roleType: '${sessionScope.loginUser.roleType}',
    userName: '${sessionScope.loginUser.userName}'
};
const coords = [
    <c:forEach items="${sessionScope.coords}" var="coord" varStatus="vs">
    {
        coordNo: ${coord.coordNo},
        latitude: '${fn:escapeXml(coord.latitude)}',
        longitude: '${fn:escapeXml(coord.longitude)}',
        coordAddress: '${fn:escapeXml(coord.coordAddress)}'
    }<c:if test="${!vs.last}">,</c:if>
    </c:forEach>
];

const bakeries = JSON.parse('${bakeriesJson}');
const root = '${pageScope.root}';

/* ====== 지도 및 마커 표시 ====== */
window.onload = function() {
    // 센터 좌표 설정
    const mainCoordNo = loginUser.mainCoord;
    const centerCoord = coords.find(c => c.coordNo == mainCoordNo);
    const centerLat = parseFloat(centerCoord.latitude);
    const centerLng = parseFloat(centerCoord.longitude);

    // 지도 생성
    const map = new naver.maps.Map('map', {
        center: new naver.maps.LatLng(centerLat, centerLng),
        zoom: 15
    });

    // 1km 반경 원 (옅은 주황색)
    const circle = new naver.maps.Circle({
        map: map,
        center: new naver.maps.LatLng(centerLat, centerLng),
        radius: 1000,
        strokeColor: '#ff9800',
        strokeOpacity: 0.7,
        strokeWeight: 2,
        fillColor: '#ffe0b2',
        fillOpacity: 0.3
    });

    // 빵집 마커 표시
    bakeries.forEach(bakery => {
        const lat = parseFloat(bakery.latitude);
        const lng = parseFloat(bakery.longitude);
        const marker = new naver.maps.Marker({
            position: new naver.maps.LatLng(lat, lng),
            map: map,
            icon: {
                url: '${root}/resources/icon/bakery-icon.png',
                size: new naver.maps.Size(36, 36),
                scaledSize: new naver.maps.Size(36, 36),
                origin: new naver.maps.Point(0, 0),
                anchor: new naver.maps.Point(18, 36)
            },
            title: bakery.bakeryName,
            clickable: true
        });
        naver.maps.Event.addListener(marker, 'click', function() {
            showBakeryModal(bakery.bakeryNo, 1);
        });
    });
};

/* ====== 빵집 모달 표시 및 댓글 로딩 ====== */
let currentBakeryNo = null;
let currentPage = 1;
let isLoadingComments = false;
let isCommentEditing = false;

function showBakeryModal(bakeryNo, page) {
    currentBakeryNo = bakeryNo;
    currentPage = page;
    isCommentEditing = false;
    
    //모달이 이미 존재할 경우 닫기
    const existingModal = bootstrap.Modal.getInstance(document.getElementById('bakeryModal'));
    if (existingModal) existingModal.hide();

    // 댓글 영역 초기화 및 로딩 표시
    document.getElementById('commentArea').innerHTML = `
        <div class="text-center py-4">
            <div class="spinner-border text-warning loading-spinner" role="status"></div>
            <div>댓글을 불러오는 중...</div>
        </div>
    `;
    
    // 빵집 정보 표시
    const bakery = bakeries.find(b => b.bakeryNo == bakeryNo);
    const infoHtml = `
        <div class="d-flex align-items-center mb-2">
            <span class="badge bg-secondary me-2">
                <i class="bi bi-telephone"></i> \${bakery.phone || '-'}
            </span>
            \${bakery.openDateStr ? `
                <span class="badge bg-light text-dark me-2">
                    <i class="bi bi-calendar"></i> \${bakery.openDateStr}
                </span>` : ''
            }
        </div>
        <div class="mb-1">
            <i class="bi bi-geo-alt"></i> \${escapeXml(bakery.roadAddress) || '-'}
            <br>
            <i class="bi bi-geo"></i> \${escapeXml(bakery.jibunAddress) || '-'}
        </div>
    `;

    document.getElementById('bakeryModalLabel').innerHTML = `
    <div class="d-flex align-items-center gap-3">
        <span>\${bakery.bakeryName}</span>
        <div class="d-flex gap-2">
            <span class="text-primary">
                <i class="bi bi-hand-thumbs-up"></i> \${bakery.likeCount || 0}
            </span>
            <span class="text-danger">
                <i class="bi bi-hand-thumbs-down"></i> \${bakery.dislikeCount || 0}
            </span>
        </div>
    </div>`;
    document.getElementById('bakeryInfo').innerHTML = infoHtml;

    
    
	// Null 체크 추가
	const commentLoadMore = document.getElementById('commentLoadMore');
	const commentEnd = document.getElementById('commentEnd');
	if (commentLoadMore) commentLoadMore.style.display = 'none';
	if (commentEnd) commentEnd.style.display = 'none';
    renderCommentWriteArea();

    // 모달 표시
    const modal = new bootstrap.Modal(document.getElementById('bakeryModal'), {
        backdrop: 'static',
        keyboard: false
    });
    modal.show();

    // 댓글 불러오기
    loadBakeryComments(bakeryNo, page, true);

    // ESC, 외부 클릭 시 닫기
    document.body.addEventListener('keydown', handleModalEscClose);
    document.getElementById('bakeryModal').addEventListener('click', handleModalOutsideClick);
}

function handleModalEscClose(e) {
    if (e.key === 'Escape') tryCloseModal();
}
function handleModalOutsideClick(e) {
    if (e.target.classList.contains('modal')) tryCloseModal();
}
function tryCloseModal() {
    if (isCommentEditing) {
        if (confirm('작성하신 댓글은 저장되지 않습니다. 창을 닫으시겠습니까?')) {
            closeBakeryModal();
        }
    } else {
        closeBakeryModal();
    }
}

function closeBakeryModal() {
    const modalElement = document.getElementById('bakeryModal');
    const modal = bootstrap.Modal.getInstance(modalElement);
    
    if (modal) {
        // 모달 닫기 이벤트 리스너 등록 (백드롭 제거 보장)
        $(modalElement).one('hidden.bs.modal', function() {
            $('body').removeClass('modal-open');
            $('.modal-backdrop').remove();
            
            
            const commentEnd = document.getElementById('commentEnd');
            if (commentEnd) commentEnd.style.display = 'none';

            // 댓글 영역 초기화
            document.getElementById('commentArea').innerHTML = '';
            document.getElementById('commentLoadMore').style.display = 'none';
            document.getElementById('commentWriteArea').innerHTML = '';
        });
        modal.hide();
    }
    
    // 기존 이벤트 리스너 제거
    document.body.removeEventListener('keydown', handleModalEscClose);
    document.getElementById('bakeryModal').removeEventListener('click', handleModalOutsideClick);
}




/* ====== 댓글 불러오기 ====== */
function loadBakeryComments(bakeryNo, page, isFirst) {
    if (isLoadingComments) return;
    isLoadingComments = true;
    $.ajax({
        url: `${pageScope.root}/selectBakeryComment.dn`,
        method: 'POST',
        data: { bakeryNo, page },
        dataType: 'json',
        success: function(res) {
            if (res.status === 'pass') {
                renderBakeryComments(res.comments, isFirst, res.hasNext);
            } else {
                document.getElementById('commentArea').innerHTML = '<div class="text-danger text-center">댓글을 불러오지 못했습니다.</div>';
            }
        },
        error: function() {
            document.getElementById('commentArea').innerHTML = '<div class="text-danger text-center">서버 오류로 댓글을 불러오지 못했습니다.</div>';
        },
        complete: function() {
            isLoadingComments = false;
        }
    });
}

function renderBakeryComments(comments, isFirst, hasNext) {
    let html = '';
    const commentList = comments.filter(c => c.commentType === 'COMMENT');

    // 댓글이 하나도 없을 때
    if (isFirst && commentList.length === 0) {
        document.getElementById('commentArea').innerHTML = `
            <div class="text-center py-4 text-muted">
                아직 댓글이 없습니다.
            </div>
        `;
        return;
    }
    
    commentList.forEach(comment => {
        html += renderCommentCard(comment, comments);
    });

    // 댓글이 있을 때, '마지막 댓글입니다' 문구를 항상 마지막에 추가 (스타일은 아래에서 제어)
    if (!hasNext) {
        html += `
            <div id="commentEnd" class="text-center py-3 text-muted" style="opacity: 0; transition: opacity 0.3s ease;">
                마지막 댓글입니다
            </div>
        `;
    } else {
        // 더 불러올 댓글이 있으면 문구 제거
        document.getElementById('commentEnd')?.remove();
    }

    if (isFirst) {
        document.getElementById('commentArea').innerHTML = html;
    } else {
        document.getElementById('commentArea').insertAdjacentHTML('beforeend', html);
    }
    
    // 스크롤 이벤트
    const area = document.getElementById('commentArea');
    area.onscroll = function() {
        // 스크롤이 맨 아래로 내려갔을 때 '마지막 댓글입니다' 문구를 보이게 함
        const commentEnd = document.getElementById('commentEnd');
        if (commentEnd) {
            if (area.scrollTop + area.clientHeight >= area.scrollHeight - 10) {
                commentEnd.style.opacity = '1';
            } else {
                commentEnd.style.opacity = '0';
            }
        }
        
        const scrollThreshold = 100; // 조기 로딩을 위한 임계값
        if (!isLoadingComments && 
            area.scrollTop + area.clientHeight >= area.scrollHeight - scrollThreshold && 
            hasNext) 
        {
            currentPage++;
            loadBakeryComments(currentBakeryNo, currentPage, false);
        }
    };

    // 댓글 불러오기 버튼
    document.getElementById('btnLoadMoreComments')?.addEventListener('click', function() {
        if (!isLoadingComments && hasNext) {
            currentPage++;
            loadBakeryComments(currentBakeryNo, currentPage, false);
        }
    });

    // 초기 로딩 시 마지막 문구 숨김
    if (!hasNext && document.getElementById('commentEnd')) {
        document.getElementById('commentEnd').style.opacity = '0';
    }
    
    // 이벤트 재바인딩 추가
    $('#commentArea').off('click', '.comment-card').on('click', '.comment-card', function() {
        const commentNo = $(this).data('comment-no');
        onCommentClick(commentNo);
    });
    
    setTimeout(() => {
        const event = new Event('scroll');
        document.getElementById('commentArea').dispatchEvent(event);
    }, 50);
}



function renderCommentCard(comment, allComments) {
    // 상태별 처리
    if (comment.status === 'N') {
        return `<div class="card comment-card bg-light text-muted"><div class="card-body">삭제된 댓글입니다.</div></div>`;
    }
    if (comment.status === 'P') {
        return `<div class="card comment-card bg-light text-muted"><div class="card-body">
            <i class="bi bi-exclamation-triangle-fill text-danger"></i> 신고되어 블라인드된 댓글입니다.
        </div></div>`;
    }
    // 일반/수정됨 댓글
	let html = `<div class="card comment-card" data-comment-no="\${comment.commentNo}">
	    <div class="card-body d-flex flex-column">
	        <div class="d-flex align-items-center mb-1">
	            <span class="comment-content flex-grow-1">
	                \${escapeXml(comment.commentContent)}
	                \${comment.status === 'M' ? '<span class="ms-2 text-muted" style="font-size:0.85em;">수정됨</span>' : ''}
	            </span>
	            <span class="ms-2">\${renderLikeDislike(comment.bakeryLike)}</span>
	        </div>
	        <div class="d-flex justify-content-between comment-meta">
	            <span>\${comment.userName}</span>
	            <span>\${comment.commentDateStr}</span>
	        </div>
	        <div class="comment-actions mt-1" id="comment-actions-\${comment.commentNo}" style="display:none;">
	            \${renderCommentActions(comment)}
	        </div>
	    </div>
	</div>`;

    // 대댓글
    const recomments = allComments.filter(rc => rc.commentType === 'RECOMMENT' && rc.parentCommentNo === comment.commentNo);
    recomments.forEach(rc => {
        html += renderRecommentCard(rc);
    });
    return html;
}

//댓글 카드 클릭 이벤트 핸들러
$('#commentArea').on('click', '.comment-card', function() {
    const commentNo = $(this).data('comment-no');
    onCommentClick(commentNo);
});

let lastOpenedCommentNo = null;

function onCommentClick(commentNo) {
	if (isCommentEditing) return; // 수정 중일 때는 무시
	
    // 대댓글 액션이 열려있으면 먼저 닫기
    if (lastOpenedRecommentNo) {
        $(`#recomment-actions-\${lastOpenedRecommentNo}`).hide();
        lastOpenedRecommentNo = null;
    }
	
    // 이전에 열려있던 버튼 숨기기
    if (lastOpenedCommentNo && lastOpenedCommentNo !== commentNo) {
        const prevActions = document.getElementById(`comment-actions-\${lastOpenedCommentNo}`);
        if (prevActions) prevActions.style.display = 'none';
    }
	
    // 현재 클릭한 댓글 버튼 토글
    const actions = document.getElementById(`comment-actions-\${commentNo}`);
    if (actions) {
        actions.style.display = actions.style.display === 'none' ? 'block' : 'none';
    }
}

function renderRecommentCard(rc) {
    if (rc.status === 'N') {
        return `<div class="card recomment-card bg-light text-muted"><div class="card-body">삭제된 댓글입니다.</div></div>`;
    }
    if (rc.status === 'P') {
        return `<div class="card recomment-card bg-light text-muted"><div class="card-body">
            <i class="bi bi-exclamation-triangle-fill text-danger"></i> 신고되어 블라인드된 댓글입니다.
        </div></div>`;
    }
    return `
    <div class="card recomment-card" data-comment-no="\${rc.commentNo}">
        <div class="card-body d-flex flex-column">
            <div class="d-flex align-items-center mb-1">
                <span class="comment-content flex-grow-1">
                    \${escapeXml(rc.commentContent)}
                    \${rc.status === 'M' ? '<span class="ms-2 text-muted" style="font-size:0.85em;">수정됨</span>' : ''}
                </span>
            </div>
            <div class="d-flex justify-content-between comment-meta">
                <span>\${rc.userName}</span>
                <span>\${rc.commentDateStr}</span>
            </div>
            <!-- 추가된 부분: 액션 버튼 컨테이너 -->
            <div class="comment-actions mt-1" id="recomment-actions-\${rc.commentNo}" style="display:none;">
                \${renderCommentActions(rc, true)}
            </div>
        </div>
    </div>`;
}
function renderLikeDislike(like) {
    if (like === 'L') return '<i class="bi bi-hand-thumbs-up-fill text-primary fs-5"></i>';
    if (like === 'D') return '<i class="bi bi-hand-thumbs-down-fill text-danger fs-5"></i>';
    return '';
}


function renderCommentActions(comment, isRecomment) {
    let html = '';
    if (comment.status === 'Y' || comment.status === 'M') {
        if (!isRecomment) html += `<button class="btn btn-outline-secondary btn-sm me-1" onclick="showRecommentForm(\${comment.commentNo})">대댓글 작성</button>`;
        if (comment.userNo === loginUser.userNo || loginUser.roleType !== 'N') {
            html += `<button class="btn btn-outline-primary btn-sm me-1" onclick="showEditForm(\${comment.commentNo}, \${isRecomment})">수정</button>`;
            html += `<button class="btn btn-outline-danger btn-sm me-1" onclick="deleteComment(\${comment.commentNo}, \${isRecomment})">삭제</button>`;
        }
        html += `<button class="btn btn-outline-warning btn-sm" onclick="reportComment(\${comment.commentNo})">신고</button>`;
    }
    return html;
}
function escapeXml(str) {
    return str.replace(/[&<>"']/g, function(m) { return ({'&':'&amp;','<':'&lt;','>':'&gt;', '"':'&quot;', "'":'&#39;'}[m]); });
}

// 댓글 작성 폼 
function renderCommentWriteArea() {
    document.getElementById('commentWriteArea').innerHTML = `
        <div class="input-group">
            <textarea class="form-control" id="commentInput" rows="2" placeholder="댓글을 입력하세요"></textarea>
            <select class="selectpicker" id="commentLike">
	            <option value="L">추천</option>
	            <option value="D">비추천</option>
	        </select>
            <button class="btn btn-success" id="btnCommentSubmit" disabled>댓글 입력하기</button>
        </div>
    `;
    document.getElementById('commentInput').addEventListener('input', checkCommentInput);
    document.getElementById('commentLike').addEventListener('change', checkCommentInput);
    document.getElementById('btnCommentSubmit').addEventListener('click', submitComment);
}
function checkCommentInput() {
    const content = document.getElementById('commentInput').value.trim();
    const like = document.getElementById('commentLike').value;
    document.getElementById('btnCommentSubmit').disabled = !(content && like);
}
function submitComment() {
    const content = document.getElementById('commentInput').value.trim();
    const like = document.getElementById('commentLike').value;
    if (!content || !like) return;
    document.getElementById('btnCommentSubmit').innerHTML = `<span class="spinner-border spinner-border-sm"></span>`;
    $.ajax({
        url: `${root}/insertBakeryComment.dn`,
        method: 'POST',
        data: { content, bakeryNo: currentBakeryNo, like },
        success: function(res) {
            if (res === 'pass') {
                showBakeryModal(currentBakeryNo, 1);
            } else {
                alert('댓글 등록에 실패했습니다.');
            }
        }
    });
}

//------------------------대댓글 작성 나와바리------------------------------

//대댓글 폼 랜더링
function showRecommentForm(commentNo) {
    // 기존 폼 제거
    const oldForm = document.getElementById(`recommentForm-\${commentNo}`);
    if (oldForm) oldForm.remove();

    // 폼 생성
    const formHtml = `
        <div id="recommentForm-\${commentNo}" class="mt-2 mb-3">
            <textarea class="form-control mb-2" id="recommentInput-\${commentNo}" 
                      rows="2" placeholder="대댓글을 입력하세요"></textarea>
            <div class="d-flex justify-content-end">
                <button class="btn btn-outline-secondary btn-sm me-2" 
                        onclick="cancelRecommentForm(\${commentNo})">취소</button>
                <button class="btn btn-success btn-sm" 
                        id="btnSubmitRecomment-\${commentNo}" 
                        disabled 
                        onclick="submitRecomment(\${commentNo})">대댓글 입력하기</button>
            </div>
        </div>
    `;

    // DOM에 추가
    const actions = document.getElementById(`comment-actions-\${commentNo}`);
    if (actions) {
        actions.innerHTML = formHtml;
        
        // 이벤트 전파 방지 핸들러 추가
        const form = document.getElementById(`recommentForm-\${commentNo}`);
        form.addEventListener('click', e => e.stopPropagation());

        // 입력 필드 & 버튼에 개별 처리
        document.getElementById(`recommentInput-\${commentNo}`)
            .addEventListener('click', e => e.stopPropagation());
        document.getElementById(`btnSubmitRecomment-\${commentNo}`)
            .addEventListener('click', e => e.stopPropagation());

        // 입력 이벤트 바인딩
        document.getElementById(`recommentInput-\${commentNo}`)
            .addEventListener('input', () => checkRecommentInput(commentNo));
    }
}


//대댓글 입력확인
function checkRecommentInput(commentNo) {
    const content = document.getElementById(`recommentInput-\${commentNo}`).value.trim();
    document.getElementById(`btnSubmitRecomment-\${commentNo}`).disabled = !content;
}

//대댓글 작성취소
function cancelRecommentForm(commentNo) {
    const form = document.getElementById(`recommentForm-\${commentNo}`);
    if (form) form.remove();
    // 원래 액션 버튼 복원
    const actions = document.getElementById(`comment-actions-\${commentNo}`);
    if (actions) {
        actions.innerHTML = renderCommentActions({commentNo, userNo: loginUser.userNo}, false);
    }
}

//대댓글 전송
function submitRecomment(commentNo) {
    const content = document.getElementById(`recommentInput-\${commentNo}`).value.trim();
    if (!content) return;

    // 버튼에 로딩 표시
    const btn = document.getElementById(`btnSubmitRecomment-\${commentNo}`);
    btn.innerHTML = `<span class="spinner-border spinner-border-sm"></span> 처리 중...`;
    btn.disabled = true;

    $.ajax({
        url: `${root}/insertBakeryRecomment.dn`,
        method: 'POST',
        data: {
            content: content,
            parentCommentNo: commentNo, // 대댓글의 부모 댓글 번호
            bakeryNo: currentBakeryNo   // 현재 팝업의 빵집 번호
        },
        success: function(res) {
            if (res === 'pass') {
                // 대댓글 등록 성공 시 팝업 창 다시 로딩
                showBakeryModal(currentBakeryNo, 1);
            } else {
                alert('대댓글 등록에 실패했습니다.');
                btn.innerHTML = '대댓글 입력하기';
                btn.disabled = false;
            }
        },
        error: function() {
            alert('서버 오류가 발생했습니다.');
            btn.innerHTML = '대댓글 입력하기';
            btn.disabled = false;
        }
    });
}

//대댓글 클릭 이벤트 핸들러
$('#commentArea').on('click', '.recomment-card', function(e) {
    e.stopPropagation(); // 상위 댓글 클릭 이벤트 버블링 방지
    const commentNo = $(this).data('comment-no');
    toggleRecommentActions(commentNo);
});

let lastOpenedRecommentNo = null;

function toggleRecommentActions(commentNo) {
    // 이전에 열린 대댓글 액션 숨기기
    if (lastOpenedRecommentNo && lastOpenedRecommentNo !== commentNo) {
        $(`#recomment-actions-${lastOpenedRecommentNo}`).hide();
    }
    
    // 현재 대댓글 액션 토글
    const actions = $(`#recomment-actions-\${commentNo}`);
    actions.toggle();
    lastOpenedRecommentNo = actions.is(':visible') ? commentNo : null;
}
</script>
</body>
</html>
