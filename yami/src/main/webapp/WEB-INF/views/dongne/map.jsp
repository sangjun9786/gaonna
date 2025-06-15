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
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<style>
    #map { margin: 30px auto; border-radius: 20px; }
    .bakery-marker { cursor: pointer; }
    .modal-dialog-scrollable { max-height: 90vh; }
    .comment-card { margin-bottom: 0.5rem;  position: relative; z-index: 1;
    	transition: transform 0.2s, box-shadow 0.2s; cursor: pointer; background: #ffffff;}
    .comment-card:hover {transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); background: #fff9e6;}
    .comment-content { font-size: 1.05rem; }
    .comment-meta { font-size: 0.85rem; color: #888; }
    .comment-actions { margin-top: 0.3rem; }
    .loading-spinner { display: inline-block; width: 1.2em; height: 1.2em; }
    .modal-header .btn-close { margin: -0.5rem -0.5rem -0.5rem auto; }
    .modal-backdrop {
	    display: none !important;
	}
	.modal.show .modal-backdrop {
	    display: block;
	    opacity: 0.5;
	}
	.modal-dialog-scrollable .modal-body {
	    overflow-y: visible;
	}
	#commentArea {
	    max-height: none !important;
	    overflow-y: visible;
	}
	.recomment-card {
		cursor: pointer;
	    margin-left: 0 !important;
	    background: #ffffff !important;
	    border: 1px solid #eee !important;
	    border-radius: 8px !important;
	    position: relative;
	    z-index: 0;
	}
	.recomment-card:hover {
	    transform: translateX(-10px);
	    transition: transform 0.3s ease;
	    background: #fff9e6 !important;
	}
    .recomment-more-card {
	    cursor: pointer;
	    transition: background 0.2s;
	}
	.recomment-more-card:hover {
	    background: #f8f9fa;
	}
	.recomment-more-card i {
	    transition: transform 0.3s;
	}
	.recomment-more-card:hover i {
	    transform: translateY(2px);
	}
	.recomments-container {
	    border-left: 2px solid #eee;
	    padding-left: 2rem;
	    margin-left: 2rem;
	    margin-top: 0.5rem;
	    position: relative;
	}
	.temp-message {
	    opacity: 1;
	    transition: opacity 1.5s ease-in-out;
	}
	@keyframes fadeOut {
	    0% { opacity: 1; }
	    70% { opacity: 1; }
	    100% { opacity: 0; display: none; }
	}
    
    
    .main-row {
        position: relative;
        width: 100%;
        min-height: 540px;
    }
    .bakery-sidebar {
        position: absolute;
        top: 40px;
        left:-100px;
        width: 220px;
        min-width: 180px;
        max-width: 280px;
        background: #fffbe8;
        border-radius: 16px;
        box-shadow: 0 2px 12px rgba(0,0,0,0.06);
        padding: 24px 16px 16px 16px;
        display: flex;
        flex-direction: column;
        align-items: center;
        z-index: 2;
    }
    #map {
        width: 60vw;
        height: 40vw;
        min-width: 340px;
        min-height: 340px;
        max-width: 900px;
        max-height: 700px;
        margin: 0 auto;
        position: relative;
        left: 50%;
        transform: translateX(-50%);
        border-radius: 20px;
        display: block;
        z-index: 1;
    }
    @media (max-width: 991px) {
        .main-row { min-height: unset; }
        .bakery-sidebar { position: static; margin: 0 auto 24px auto; }
        #map { width: 100vw; left: 0; transform: none; }
    }
    .bakery-sidebar .bi-cake {
        font-size: 2.5rem;
        color: #ff9800;
        margin-bottom: 8px;
    }
    .bakery-sidebar h4 {
        font-weight: bold;
        color: #ff9800;
        margin-bottom: 18px;
        text-align: center;
        line-height: 1.2;
    }
    .bakery-sidebar .btn {
        margin-top: 18px;
        width: 100%;
    }
</style>
</head>
<body>
<%@include file="/WEB-INF/views/common/header.jsp"%>
<%@ include file="/WEB-INF/views/common/searchbar.jsp" %>

<div class="container mt-5">
    <div class="d-flex justify-content-center align-items-start main-row">
        <div class="bakery-sidebar">
            <i class="bi bi-cake"></i>
            <h4>
                우리 동네<br>빵집
            </h4>
            <button class="btn btn-outline-warning" onclick="location.href='${root}/dongne.me'">
                대표동네 변경하기
            </button>
        </div>
        <div>
            <div id="map"></div>
        </div>
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

/* ====== 지도 및 마커 표시 ====== */
window.onload = function() {
    // 센터 좌표 설정
    const mainCoordNo = loginUser.mainCoord;
    const centerCoord = coords.find(c => c.coordNo == mainCoordNo);
    const centerLat = parseFloat(centerCoord.latitude);
    const centerLng = parseFloat(centerCoord.longitude);

    const keyword = $('#keyword').val();
    const encodedKeyword = encodeURIComponent(keyword);
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
    
    if(keyword && keyword.trim() !== "") {
		$.ajax({
			url : "ajax.do",
			data : {
				keyword : keyword
			},
			success : function(result) {
				//응답데이터가 잇다면 success function의 매개변수로 전달됨
				console.log("서버 응답 결과:", result);
				if(result != null) {
					showBakeryModal(result, 1);
				}
			},
			error : function() {
				console.log("통신 실패");
			}
		});
    }
};

/* ====== 빵집 모달 표시 및 댓글 로딩 ====== */
let currentBakeryNo = null;
let currentPage = 1;
let isLoadingComments = false;
let isCommentEditing = false;

function showBakeryModal(bakeryNo, page) {
    currentBakeryNo = bakeryNo;
    currentPage = 1;
    isCommentEditing = false;
    
    //모달이 이미 존재할 경우 닫기
	const existingModal = bootstrap.Modal.getInstance(document.getElementById('bakeryModal'));
    if (existingModal) existingModal.dispose();

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
            
            // 추가: body 스타일 초기화
            document.body.style.paddingRight = '';
            document.body.style.overflow = '';
            
            // 댓글 영역 초기화
            document.getElementById('commentArea').innerHTML = '';
            document.getElementById('commentLoadMore').style.display = 'none';
            document.getElementById('commentWriteArea').innerHTML = '';
        });
        modal.hide();
    }
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
    
    // 댓글 카드 렌더링
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
    
    const recomments = allComments.filter(rc => 
	    rc.commentType === 'RECOMMENT' && 
	    rc.parentCommentNo === comment.commentNo
	);
    
    // 대댓글 컨테이너 생성
    html += `<div class="recomments-container ms-4" data-parent-comment="\${comment.commentNo}">`;
    recomments.slice(0, 10).forEach(rc => {
        html += renderRecommentCard(rc);
    });
    html += `</div>`;
    
    if(recomments.length >= 10) {
        html += `
            <div class="recomment-more-card mt-2" 
                 data-parent-comment-no="\${comment.commentNo}" 
                 data-page="2" 
                 onclick="loadMoreRecomments(\${comment.commentNo}, this)">
                <div class="text-center py-2 bg-light rounded">
                    <i class="bi bi-chevron-double-down"></i> 대댓글 더 보기
                </div>
            </div>`;
    }
    
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
        return `<div class="card recomment-card ms-4 bg-light text-muted"><div class="card-body">삭제된 댓글입니다.</div></div>`;
    }
    if (rc.status === 'P') {
        return `<div class="card recomment-card ms-4 bg-light text-muted"><div class="card-body">
            <i class="bi bi-exclamation-triangle-fill text-danger"></i> 신고되어 블라인드된 댓글입니다.
        </div></div>`;
    }
    return `
    <div class="card recomment-card ms-4" 
	    data-comment-no="\${rc.commentNo}" 
	    data-parent-comment-no="\${rc.parentCommentNo}">
	    
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
        if (comment.userNo == loginUser.userNo || loginUser.roleType !== 'N') {
            html += `<button class="btn btn-outline-primary btn-sm me-1" onclick="showEditForm(\${comment.commentNo}, \${isRecomment}, \${comment.userNo})">수정</button>`;
            html += `<button class="btn btn-outline-danger btn-sm me-1" onclick="deleteComment(\${comment.commentNo}, \${comment.userNo})">삭제</button>`;
        }
        <%--html += `<button class="btn btn-outline-warning btn-sm" onclick="reportComment(\${comment.commentNo})">신고</button>`;--%>
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
    const btn = document.getElementById('btnCommentSubmit');
    if (content.length === 0 || content.length > 100 || !like) {
        btn.disabled = true;
    } else {
        btn.disabled = false;
    }
    // 100자 초과시 자동 자르기
    if (content.length > 100) {
        document.getElementById('commentInput').value = content.substring(0, 100);
    }
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
    const input = document.getElementById(`recommentInput-\${commentNo}`);
    const content = input.value.trim();
    const btn = document.getElementById(`btnSubmitRecomment-\${commentNo}`);
    if (content.length === 0 || content.length > 100) {
        btn.disabled = true;
    } else {
        btn.disabled = false;
    }
    if (content.length > 100) {
        input.value = content.substring(0, 100);
    }
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

//----------------------(대)댓글 수정------------------------
function showEditForm(commentNo, isRecomment,commentUserNo) {
    isCommentEditing = true;
    
    // 기존 댓글 내용 가져오기
    const commentCard = document.querySelector(`[data-comment-no="\${commentNo}"]`);
    const contentElement = commentCard.querySelector('.comment-content');
    const originalContent = contentElement.childNodes[0].textContent.trim();
    
    // 수정 폼 생성
    const formHtml = `
        <div class="edit-form-container">
            <textarea class="form-control mb-2" id="editContent-\${commentNo}" 
                      rows="2">\${originalContent}</textarea>
            \${!isRecomment ? `
            <select class="form-select mb-2" id="editLike-\${commentNo}">
                <option value="L">추천</option>
                <option value="D">비추천</option>
            </select>` : ''}
            <div class="d-flex justify-content-end gap-2">
                <button class="btn btn-outline-secondary btn-sm" 
                        onclick="cancelEdit('\${commentNo}', \${isRecomment})">취소</button>
                <button class="btn btn-primary btn-sm" 
                        id="btnSubmitEdit-\${commentNo}" 
                        disabled
                        onclick="submitEdit('\${commentNo}', \${isRecomment ? 'true' : 'false'}, '\${commentUserNo}')">수정하기</button>
            </div>
        </div>
    `;

    // 폼 삽입 및 기존 내용 교체
    const commentBody = commentCard.querySelector('.card-body');
    commentBody.innerHTML = formHtml;
    
    // 이벤트 전파 방지
    commentCard.querySelector('textarea').addEventListener('click', e => e.stopPropagation());
    
    // 입력 유효성 검사
    document.getElementById(`editContent-\${commentNo}`).addEventListener('input', () => 
        checkEditInput(commentNo, isRecomment)
    );
    if(!isRecomment) {
        document.getElementById(`editLike-\${commentNo}`).addEventListener('change', () => 
            checkEditInput(commentNo, isRecomment)
        );
    }
}

function checkEditInput(commentNo, isRecomment) {
    const input = document.getElementById(`editContent-\${commentNo}`);
    const content = input.value.trim();
    const like = isRecomment ? 'P' : document.getElementById(`editLike-\${commentNo}`).value;
    const btn = document.getElementById(`btnSubmitEdit-\${commentNo}`);
    if (content.length === 0 || content.length > 100 || (!isRecomment && !like)) {
        btn.disabled = true;
    } else {
        btn.disabled = false;
    }
    if (content.length > 100) {
        input.value = content.substring(0, 100);
    }
}
function cancelEdit(commentNo, isRecomment) {
    isCommentEditing = false;
    showBakeryModal(currentBakeryNo, currentPage); // 모달 다시 로드
}

function submitEdit(commentNo, isRecomment, commentUserNo) {
    const content = document.getElementById(`editContent-\${commentNo}`).value.trim();
    const like = isRecomment ? 'P' : document.getElementById(`editLike-\${commentNo}`).value;
    const btn = document.getElementById(`btnSubmitEdit-\${commentNo}`);
    
    btn.innerHTML = `<span class="spinner-border spinner-border-sm"></span>`;
    btn.disabled = true;
    
    $.ajax({
        url: `${root}/updateBakeryComment.dn`,
        method: 'POST',
        data: {
            commentNo: commentNo,
            content: content,
            bakeryLike: like,
            userNo: commentUserNo
        },
        success: function(res) {
            if(res === 'pass') {
                showBakeryModal(currentBakeryNo, currentPage);
            } else {
                alert('댓글 수정에 실패했습니다');
                btn.innerHTML = '수정하기';
                btn.disabled = false;
            }
        },
        error: function() {
            alert('서버 오류 발생');
            btn.innerHTML = '수정하기';
            btn.disabled = false;
        }
    });
    showBakeryModal(currentBakeryNo, 1); // 성공 후 강제 페이지 1 로드
}


//대댓글 조회
function loadMoreRecomments(parentCommentNo, element) {
    const page = parseInt(element.dataset.page);
    const commentCard = document.querySelector(`[data-comment-no="\${parentCommentNo}"]`);
    if (!commentCard) {
        console.error('댓글 카드를 찾을 수 없음:', parentCommentNo);
        return;
    }
    
    let recommentsContainer = commentCard.nextElementSibling?.classList.contains('recomments-container') 
            ? commentCard.nextElementSibling : createRecommentsContainer(commentCard);
    while (recommentsContainer && !recommentsContainer.classList.contains('recomments-container')) {
        recommentsContainer = recommentsContainer.nextElementSibling;
    }
    
    // 컨테이너가 없으면 생성
    if (!recommentsContainer) {
        recommentsContainer = document.createElement('div');
        recommentsContainer.className = 'recomments-container ms-4';
        recommentsContainer.setAttribute('data-parent-comment', parentCommentNo);
        
        commentCard.parentNode.insertBefore(recommentsContainer, commentCard.nextSibling);
    }

    $.ajax({
        url: `${root}/selectBakeryRecomment.dn`,
        method: 'POST',
        data: { 
            bakeryNo: currentBakeryNo, 
            page, 
            parentCommentNo 
        },
        success: function(res) {
            if(res.status === 'pass' && res.comments.length > 0) {
                res.comments.forEach(rc => {
                    recommentsContainer.insertAdjacentHTML('beforeend', 
                        renderRecommentCard(rc)
                    );
                });
                
                if(res.hasNext) {
                    element.dataset.page = page + 1;
                } else {
                    element.outerHTML = `
                        <div class="temp-message text-muted text-center py-2">
                            마지막 대댓글입니다
                        </div>`;
                    setTimeout(() => {
                        const tempMsg = document.querySelector('.temp-message');
                        tempMsg?.parentNode.removeChild(tempMsg);
                    }, 1500);
                }
            } else {
                element.remove();
            }
        },
        error: function() {
            alert('대댓글 조회 실패');
        }
    });
}


function createRecommentsContainer(commentCard) {
    const container = document.createElement('div');
    container.className = 'recomments-container ms-4';
    container.setAttribute('data-recomments-container', '');
    commentCard.querySelector('.card-body').appendChild(container);
    return container;
}

//----------------------(대)댓글 삭제하기-------------------------------
function deleteComment(commentNo, userNo) {
    if (!confirm('정말 삭제하시겠습니까?')) return;
    
    const btn = document.querySelector(`[onclick*="deleteComment(\${commentNo}"]`);
    if (btn) {
        btn.innerHTML = `<span class="spinner-border spinner-border-sm"></span>`;
        btn.disabled = true;
    }

    $.ajax({
        url: `${root}/deleteBakeryComment.dn`,
        method: 'POST',
        data: { 
            commentNo: commentNo,
            userNo: userNo
        },
        success: function(res) {
            if(res === 'pass') {
                //모달을 완전히 닫기
                const modalElement = document.getElementById('bakeryModal');
                const modal = bootstrap.Modal.getInstance(modalElement);
                if (modal) modal.hide();

                //백드롭, body 상태, 스크롤 등 정상화
                setTimeout(() => {
                    document.body.classList.remove('modal-open');
                    $('.modal-backdrop').remove();
                    document.body.style.overflow = '';
                    document.body.style.paddingRight = '';
                    
                    //모달을 재로딩
                    showBakeryModal(currentBakeryNo, 1);
                }, 400); // Bootstrap 모달 hide 애니메이션 시간(0.4초) 이후 재오픈
            } else {
                alert('삭제 권한이 없습니다');
                if (btn) {
                    btn.innerHTML = '삭제';
                    btn.disabled = false;
                }
            }
        },
        error: function() {
            alert('서버 오류 발생');
            if (btn) {
                btn.innerHTML = '삭제';
                btn.disabled = false;
            }
        }
    });
}

</script>
</body>
</html>