<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" />

<div class="container py-5">
    <h2 class="mb-4">신고 상세</h2>
    <div class="row justify-content-center">
        <div class="col-md-7">
            <table class="table table-bordered shadow-sm bg-white">
                <tr><th class="table-light" style="width:30%;">신고번호</th><td>${report.REPORT_NO}</td></tr>
                <tr>
                    <th class="table-light">신고유형</th>
                    <td>
                        <c:choose>
                            <c:when test="${report.REPORT_TYPE eq 'product'}">게시글</c:when>
                            <c:when test="${report.REPORT_TYPE eq 'reply'}">댓글</c:when>
                            <c:when test="${report.REPORT_TYPE eq 'chat'}">채팅</c:when>
                            <c:otherwise>${report.REPORT_TYPE}</c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr><th class="table-light">신고대상번호</th><td>${report.TARGET_NO}</td></tr>
                <tr>
                    <th class="table-light">신고자</th>
                    <td>
                        ${report.REPORTERNAME}
                        <span style="color: #888; font-size: 13px;">(${report.REPORTER_NO})</span>
                    </td>
                </tr>
                <tr><th class="table-light">사유</th><td>${report.REASON}</td></tr>
                <tr><th class="table-light">상세내용</th><td>${report.CONTENT}</td></tr>
                <tr>
                    <th class="table-light">상태</th>
                    <td>
                        <c:choose>
                            <c:when test="${report.STATUS eq 'P'}"><span class="badge bg-warning text-dark">대기</span></c:when>
                            <c:when test="${report.STATUS eq 'Y'}"><span class="badge bg-success">처리</span></c:when>
                            <c:when test="${report.STATUS eq 'N'}"><span class="badge bg-secondary">반려</span></c:when>
                        </c:choose>
                    </td>
                </tr>
                <tr><th class="table-light">신고일시</th><td><fmt:formatDate value="${report.CREATED_AT}" pattern="yyyy년 M월 d일" /></td></tr>
                <tr>
                    <th class="table-light">처리일시</th>
                    <td>
                        <c:choose>
                            <c:when test="${not empty report.HANDLED_AT}">
                                <fmt:formatDate value="${report.HANDLED_AT}" pattern="yyyy년 M월 d일" />
                            </c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </table>

            <c:if test="${not empty loginUser && loginUser.roleType != 'N'}">
                <form id="statusForm" class="d-flex gap-2 mt-3">
                    <input type="hidden" name="reportNo" value="${report.REPORT_NO}">
                    <select name="status" class="form-select w-auto"
                        <c:if test="${report.STATUS eq 'Y' || report.STATUS eq 'N'}">disabled</c:if>>
                        <option value="P" <c:if test="${report.STATUS eq 'P'}">selected</c:if>>대기</option>
                        <option value="Y" <c:if test="${report.STATUS eq 'Y'}">selected</c:if>>처리</option>
                        <option value="N" <c:if test="${report.STATUS eq 'N'}">selected</c:if>>반려</option>
                    </select>
                    <button type="button" onclick="changeStatus()" class="btn btn-danger"
                        <c:if test="${report.STATUS eq 'Y' || report.STATUS eq 'N'}">disabled</c:if>>
                        상태변경
                    </button>
                </form>
                <script>
                    function changeStatus() {
                        const form = document.getElementById("statusForm");
                        fetch("${pageContext.request.contextPath}/report/updateStatus", {
                            method: "POST",
                            headers: {"Content-Type": "application/x-www-form-urlencoded"},
                            body: "reportNo=" + form.reportNo.value + "&status=" + form.status.value
                        }).then(res => res.text()).then(msg => {
                            if (msg === "success") {
                                alert("상태 변경 성공");
                                location.reload();
                            } else {
                                alert("상태 변경 실패");
                            }
                        });
                    }
                </script>
            </c:if>
        </div>
    </div>
</div>
