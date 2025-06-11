<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<meta charset="UTF-8">
<title>YAMI : 나의 댓글 - 우리동네 빵집</title>
<style>
/* 숨쉬듯 반짝이는 강조 효과 */
@keyframes breathe-highlight {
    0% { box-shadow: 0 0 0 0 rgba(255,193,7,0.7); }
    50% { box-shadow: 0 0 16px 8px rgba(255,193,7,0.5); }
    100% { box-shadow: 0 0 0 0 rgba(255,193,7,0.7); }
}
.comment-highlight {
    animation: breathe-highlight 1.8s cubic-bezier(.4,0,.2,1) 3;
    background: linear-gradient(90deg, #fffbe8 60%, #fff9c4 100%);
    transition: background 0.5s;
    z-index: 10;
    position: relative;
}
</style>
</head>
<body>
<%@include file="/WEB-INF/views/common/header.jsp"%>

<div class="container mt-4">
    <h4 class="mb-4">
        <i class="bi bi-chat-left-text"></i> 내가 작성한 댓글
    </h4>
    <!-- 댓글 영역 -->
    <div id="myCommentArea"></div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
const targetBakeryNo = '<%= pageContext.getAttribute("targetBakeryNo") %>';
const targetCommentNo = '<%= pageContext.getAttribute("targetCommentNo") %>';
const root = '<%= request.getContextPath() %>';

let currentPage = 1;
let isLoading = false;
let foundTarget = false;

// 기존 댓글 렌더링 함수 재활용
function renderBakeryComments(comments, isFirst, hasNext) {
    let html = '';
    const commentList = comments.filter(c => c.commentType === 'COMMENT');
    if (isFirst && commentList.length === 0) {
        document.getElementById('myCommentArea').innerHTML = `
            <div class="text-center py-4 text-muted">
                아직 댓글이 없습니다.
            </div>
        `;
        return;
    }
    commentList.forEach(comment => {
        html += renderCommentCard(comment, comments);
    });
    if (isFirst) {
        document.getElementById('myCommentArea').innerHTML = html;
    } else {
        document.getElementById('myCommentArea').insertAdjacentHTML('beforeend', html);
    }
    // (대)댓글 강조 및 스크롤 이동 시도
    highlightAndScrollToTarget();
}

// 기존 댓글 카드 렌더링 함수 재활용(아래에서 강조 클래스 주입)
function renderCommentCard(comment, allComments) {
    // ...삭제, 블라인드 처리 생략...
    let highlightClass = (comment.commentNo == targetCommentNo) ? 'comment-highlight' : '';
    let html = `<div class="card comment-card \${highlightClass}" data-comment-no="\${comment.commentNo}" style="margin-bottom:0.5rem;">
        <div class="card-body d-flex flex-column">
            <div class="d-flex align-items-center mb-1">
                <span class="comment-content flex-grow-1">
                    \${escapeXml(comment.commentContent)}
                    \${comment.status === 'M' ? '<span class="ms-2 text-muted" style="font-size:0.85em;">수정됨</span>' : ''}
                </span>
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
    html += `<div class="recomments-container ms-4" data-parent-comment="\${comment.commentNo}">`;
    recomments.forEach(rc => {
        html += renderRecommentCard(rc);
    });
    html += `</div>`;
    return html;
}
function renderRecommentCard(rc) {
    let highlightClass = (rc.commentNo == targetCommentNo) ? 'comment-highlight' : '';
    return `
    <div class="card recomment-card ms-4 \${highlightClass}" data-comment-no="\${rc.commentNo}">
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

// 댓글/대댓글 액션 렌더링(수정/삭제/신고 등)
function renderCommentActions(comment, isRecomment) {
    let html = '';
    // ...권한 체크 및 버튼 렌더링 기존대로...
    html += `<button class="btn btn-outline-primary btn-sm me-1" onclick="showEditForm(\${comment.commentNo}, \${!!isRecomment}, \${comment.userNo})">수정</button>`;
    html += `<button class="btn btn-outline-danger btn-sm me-1" onclick="deleteComment(\${comment.commentNo}, \${comment.userNo})">삭제</button>`;
    html += `<button class="btn btn-outline-warning btn-sm" onclick="reportComment(\${comment.commentNo})">신고</button>`;
    return html;
}

// XSS 방지
function escapeXml(str) {
    if (!str) return '';
    return str.replace(/[&<>"']/g, function(m) { return ({'&':'&amp;','<':'&lt;','>':'&gt;', '"':'&quot;', "'":'&#39;'}[m]); });
}

// (대)댓글 불러오기
function loadBakeryComments(bakeryNo, page, isFirst) {
    if (isLoading) return;
    isLoading = true;
    $.ajax({
        url: `${root}/selectBakeryComment.dn`,
        method: 'POST',
        data: { bakeryNo, page },
        dataType: 'json',
        success: function(res) {
            if (res.status === 'pass') {
                renderBakeryComments(res.comments, isFirst, res.hasNext);
                // 다음 페이지 필요하면 자동 로딩
                if (!foundTarget && res.hasNext) {
                    // 현재 페이지에 targetCommentNo가 없으면 다음 페이지 로딩
                    const exists = res.comments.some(c => c.commentNo == targetCommentNo || (c.commentType === 'RECOMMENT' && c.commentNo == targetCommentNo));
                    if (!exists) {
                        currentPage++;
                        loadBakeryComments(bakeryNo, currentPage, false);
                    }
                }
            } else {
                document.getElementById('myCommentArea').innerHTML = '<div class="text-danger text-center">댓글을 불러오지 못했습니다.</div>';
            }
        },
        error: function() {
            document.getElementById('myCommentArea').innerHTML = '<div class="text-danger text-center">서버 오류로 댓글을 불러오지 못했습니다.</div>';
        },
        complete: function() {
            isLoading = false;
        }
    });
}

// 강조 및 스크롤 이동
function highlightAndScrollToTarget() {
    if (foundTarget) return;
    const targetCard = document.querySelector(`.card[data-comment-no="\${targetCommentNo}"]`);
    if (targetCard) {
        foundTarget = true;
        // 스크롤 이동
        setTimeout(() => {
            targetCard.scrollIntoView({ behavior: "smooth", block: "center" });
        }, 200);
        // 강조 효과(이미 적용되어 있음), 애니메이션 끝나면 클래스 제거
        setTimeout(() => {
            targetCard.classList.remove('comment-highlight');
        }, 5400); // 1.8s * 3회
    }
}

// 페이지 진입 시 자동 로딩
$(document).ready(function() {
    if (targetBakeryNo) {
        loadBakeryComments(targetBakeryNo, currentPage, true);
    } else {
        $('#myCommentArea').html('<div class="text-center text-muted">대상 빵집 정보가 없습니다.</div>');
    }
});


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
    const content = document.getElementById(`editContent-\${commentNo}`).value.trim();
    const like = isRecomment ? 'P' : document.getElementById(`editLike-\${commentNo}`).value;
    document.getElementById(`btnSubmitEdit-\${commentNo}`).disabled = !content || (!isRecomment && !like);
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
</script>
</body>
</html>
