<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=85oq183idp"></script>
<meta charset="UTF-8">
<title>동네 한바퀴</title>
<style>
    #map { margin: 30px auto; border-radius: 20px; }
    .bakery-marker { cursor: pointer; }
    .modal-dialog-scrollable { max-height: 90vh; }
    .comment-card { margin-bottom: 0.5rem; }
    .recomment-card { margin-left: 2rem; background: #fff8e1; }
    .comment-content { font-size: 1.05rem; }
    .comment-meta { font-size: 0.85rem; color: #888; }
    .comment-actions { margin-top: 0.3rem; }
    .loading-spinner { display: inline-block; width: 1.2em; height: 1.2em; }
    .modal-header .btn-close { margin: -0.5rem -0.5rem -0.5rem auto; }
    .modal-backdrop { opacity: 0.4 !important; }
</style>
</head>
<body>
<%@include file="/WEB-INF/views/common/header.jsp"%>

<div class="container mt-5">
    <div class="text-center mb-4">
        <h2>
            <i class="bi bi-geo-alt-fill text-warning"></i>
            우리 동네 빵집
        </h2>
    </div>
    <div class="d-flex justify-content-center">
        <div id="map" style="width: 600px; height: 400px;"></div>
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
        <div id="commentEnd" class="text-center my-2 text-muted" style="display:none;">
          마지막 댓글입니다
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
        coordAddress: '${fn:escapeXml(coord.coordAddress)}',
    </c:forEach>
];
const bakeries = JSON.parse('${fn:escapeXml(bakeriesJson)}');
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
                url: 'https://cdn-icons-png.flaticon.com/512/3075/3075977.png', // 빵집 아이콘
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
    // 빵집 정보 표시
    const bakery = bakeries.find(b => b.bakeryNo == bakeryNo);
    const infoHtml = `
        <div class="d-flex align-items-center mb-2">
            <span class="fs-4 fw-bold me-2">${bakery.bakeryName}</span>
            <span class="badge bg-secondary me-2"><i class="bi bi-telephone"></i> ${bakery.phone || '-'}</span>
            <span class="badge bg-light text-dark me-2"><i class="bi bi-calendar"></i> ${bakery.openDateStr || '-'}</span>
        </div>
        <div class="mb-1">
            <i class="bi bi-geo-alt"></i> ${bakery.roadAddress || '-'}
            <br>
            <i class="bi bi-geo"></i> ${bakery.jibunAddress || '-'}
        </div>
        <div>
            <span class="me-3"><i class="bi bi-hand-thumbs-up text-primary"></i> ${bakery.like}</span>
            <span><i class="bi bi-hand-thumbs-down text-danger"></i> ${bakery.dislike}</span>
        </div>
    `;
    document.getElementById('bakeryModalLabel').innerText = bakery.bakeryName;
    document.getElementById('bakeryInfo').innerHTML = infoHtml;

    // 댓글 영역 초기화 및 로딩 표시
    document.getElementById('commentArea').innerHTML = `
        <div class="text-center py-4">
            <div class="spinner-border text-warning loading-spinner" role="status"></div>
            <div>댓글을 불러오는 중...</div>
        </div>
    `;
    document.getElementById('commentLoadMore').style.display = 'none';
    document.getElementById('commentEnd').style.display = 'none';
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
    const modal = bootstrap.Modal.getInstance(document.getElementById('bakeryModal'));
    modal.hide();
    document.body.removeEventListener('keydown', handleModalEscClose);
    document.getElementById('bakeryModal').removeEventListener('click', handleModalOutsideClick);
}

/* ====== 댓글 불러오기 ====== */
function loadBakeryComments(bakeryNo, page, isFirst) {
    if (isLoadingComments) return;
    isLoadingComments = true;
    $.ajax({
        url: `${root}/selectBakeryComment.dn`,
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
    // 댓글, 대댓글 정렬
    const commentList = comments.filter(c => c.commentType === 'COMMENT');
    commentList.forEach(comment => {
        html += renderCommentCard(comment, comments);
    });
    if (isFirst) {
        document.getElementById('commentArea').innerHTML = html;
    } else {
        document.getElementById('commentArea').innerHTML += html;
    }
    document.getElementById('commentLoadMore').style.display = hasNext ? 'block' : 'none';
    document.getElementById('commentEnd').style.display = hasNext ? 'none' : 'block';
    // 스크롤 이벤트 (무한 스크롤)
    const area = document.getElementById('commentArea');
    area.onscroll = function() {
        if (!isLoadingComments && area.scrollTop + area.clientHeight >= area.scrollHeight - 10 && hasNext) {
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
    let html = `<div class="card comment-card">
        <div class="card-body d-flex flex-column">
            <div class="d-flex align-items-center mb-1">
                <span class="comment-content flex-grow-1">
                    \${escapeXml(comment.commentContent)}
                    \${comment.status === 'M' ? '<span class="ms-2 text-muted" style="font-size:0.85em;">수정됨</span>' : ''}
                </span>
                <span class="ms-2">\${renderLikeDislike(comment.like)}</span>
            </div>
            <div class="d-flex justify-content-between comment-meta">
                <span>\${comment.userName}</span>
                <span>\${comment.commentDateStr}</span>
            </div>
            <div class="comment-actions mt-1">
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
function renderRecommentCard(rc) {
    if (rc.status === 'N') {
        return `<div class="card recomment-card bg-light text-muted"><div class="card-body">삭제된 댓글입니다.</div></div>`;
    }
    if (rc.status === 'P') {
        return `<div class="card recomment-card bg-light text-muted"><div class="card-body">
            <i class="bi bi-exclamation-triangle-fill text-danger"></i> 신고되어 블라인드된 댓글입니다.
        </div></div>`;
    }
    return `<div class="card recomment-card">
        <div class="card-body d-flex flex-column">
            <div class="d-flex align-items-center mb-1">
                <span class="comment-content flex-grow-1">\${escapeXml(rc.commentContent)}\${rc.status === 'M' ? '<span class="ms-2 text-muted" style="font-size:0.85em;">수정됨</span>' : ''}</span>
            </div>
            <div class="d-flex justify-content-between comment-meta">
                <span>\${rc.userName}</span>
                <span>\${rc.commentDateStr}</span>
            </div>
            <div class="comment-actions mt-1">
                \${renderCommentActions(rc, true)}
            </div>
        </div>
    </div>`;
}
function renderLikeDislike(like) {
    if (like === 'L') return '<i class="bi bi-hand-thumbs-up text-primary"></i>';
    if (like === 'D') return '<i class="bi bi-hand-thumbs-down text-danger"></i>';
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

/* ====== 댓글/대댓글 작성 폼 ====== */
function renderCommentWriteArea() {
    document.getElementById('commentWriteArea').innerHTML = `
        <div class="input-group">
            <textarea class="form-control" id="commentInput" rows="2" placeholder="댓글을 입력하세요"></textarea>
            <select class="form-select" id="commentLike">
                <option value="">추천/비추천</option>
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
</script>
</body>
</html>
