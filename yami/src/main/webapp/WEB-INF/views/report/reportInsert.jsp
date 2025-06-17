<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" />

<style>
    body { font-family: '맑은 고딕', 'Malgun Gothic', sans-serif; background: #f7f5ef; }
    .report-form-container {
        max-width: 420px; margin: 56px auto 65px auto; background: #fff;
        border-radius: 18px; box-shadow: 0 5px 24px #ffb5431b;
        padding: 38px 36px 34px 36px;
    }
    h3 {
        font-size: 1.28rem; font-weight: 700; margin-bottom: 22px;
        color: #ff8800; letter-spacing: -1px; text-align:center;
    }
    .form-label { font-weight: 600; color: #222; margin-bottom: 6px;}
    .radio-group { margin-bottom: 19px;}
    .radio-group .form-check-inline {
        margin-right: 15px; margin-bottom: 7px; font-size: 15.2px;
    }
    .form-check-input:checked { background-color: #ffb340; border-color: #ffb340; }
    .form-check-label { cursor:pointer; }
    textarea.form-control {
        min-height: 88px; border-radius: 10px; font-size: 15px; margin-bottom: 2px;
        border: 1.1px solid #eee7d4; background: #fdfcf9;
    }
    .btn-warning {
        background: #ffad33; border: none; border-radius: 7px;
        font-size: 1.05rem; font-weight: 700; padding: 9px 32px 9px 32px;
        transition: background 0.14s;
        letter-spacing: 0.5px;
    }
    .btn-warning:hover { background: #ff8800;}
    .action-area {
        display: flex; justify-content: flex-end; align-items: center; gap: 10px; margin-top: 10px;
    }
    .back-link { font-size: 14.1px; color: #888; text-decoration: underline; transition: color 0.13s;}
    .back-link:hover { color: #ff8a00; text-decoration: underline; }
</style>

<div class="report-form-container">
    <h3>🚩 신고하기</h3>
    <form action="${pageContext.request.contextPath}/report/insert" method="post" autocomplete="off">
        <input type="hidden" name="reportType" value="${reportType}">
        <input type="hidden" name="targetNo" value="${targetNo}">

        <div class="mb-3 radio-group">
            <label class="form-label">신고 사유</label><br>
            <c:choose>
                <c:when test="${reportType == 'chat'}">
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="reason" value="욕설" id="reason1" required>
                        <label class="form-check-label" for="reason1">욕설/비방</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="reason" value="도배" id="reason2">
                        <label class="form-check-label" for="reason2">도배</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="reason" value="광고" id="reason3">
                        <label class="form-check-label" for="reason3">광고/스팸</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="reason" value="사기" id="reason4">
                        <label class="form-check-label" for="reason4">사기/금전거래</label>
                    </div>
                </c:when>
                <c:when test="${reportType == 'post'}">
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="reason" value="음란물" id="reason5" required>
                        <label class="form-check-label" for="reason5">음란물</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="reason" value="불법" id="reason6">
                        <label class="form-check-label" for="reason6">불법정보</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="reason" value="도배" id="reason7">
                        <label class="form-check-label" for="reason7">도배/광고</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="reason" value="욕설" id="reason8">
                        <label class="form-check-label" for="reason8">욕설/비방</label>
                    </div>
                </c:when>
                <c:when test="${reportType == 'reply'}">
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="reason" value="욕설" id="reason9" required>
                        <label class="form-check-label" for="reason9">욕설/비방</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="reason" value="도배" id="reason10">
                        <label class="form-check-label" for="reason10">도배</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="reason" value="저격" id="reason11">
                        <label class="form-check-label" for="reason11">저격</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="reason" value="기타" id="reason12">
                        <label class="form-check-label" for="reason12">기타</label>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="reason" value="기타" id="reason13" required>
                        <label class="form-check-label" for="reason13">기타</label>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="mb-2">
            <label for="content" class="form-label">상세 내용</label>
            <textarea name="content" id="content" class="form-control" placeholder="신고 사유를 구체적으로 적어주세요" required></textarea>
        </div>

        <div class="action-area">
            <button type="submit" class="btn btn-warning">신고 등록</button>
            <a href="javascript:history.back()" class="back-link">뒤로가기</a>
        </div>
    </form>
</div>
