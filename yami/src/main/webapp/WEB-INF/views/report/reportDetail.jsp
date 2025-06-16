<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="container">
    <h2>신고 상세</h2>
    <table border="1" width="600">
        <tr>
            <th>신고번호</th><td>${report.reportNo}</td>
        </tr>
        <tr>
            <th>신고유형</th>
            <td>
              <c:choose>
                <c:when test="${report.reportType eq 'product'}">게시글</c:when>
                <c:when test="${report.reportType eq 'reply'}">댓글</c:when>
                <c:when test="${report.reportType eq 'chat'}">채팅</c:when>
                <c:otherwise>${report.reportType}</c:otherwise>
              </c:choose>
            </td>
        </tr>
        <tr>
            <th>신고대상번호</th><td>${report.targetNo}</td>
        </tr>
        <tr>
            <th>신고자</th><td>${report.reporterNo}</td>
        </tr>
        <tr>
            <th>사유</th><td>${report.reason}</td>
        </tr>
        <tr>
            <th>상세내용</th><td>${report.content}</td>
        </tr>
        <tr>
            <th>상태</th>
            <td>
              <c:choose>
                <c:when test="${report.status eq 'P'}">대기</c:when>
                <c:when test="${report.status eq 'Y'}">처리</c:when>
                <c:when test="${report.status eq 'N'}">반려</c:when>
                <c:otherwise>${report.status}</c:otherwise>
              </c:choose>
            </td>
        </tr>
        <tr>
            <th>신고일시</th><td>${report.createdAt}</td>
        </tr>
    </table>

    <!-- 관리자만 상태 변경 가능 -->
    <c:if test="${not empty loginUser && loginUser.roleType != 'N'}">
        <form id="statusForm">
            <input type="hidden" name="reportNo" value="${report.reportNo}">
            <select name="status">
                <option value="P" ${report.status == 'P' ? 'selected' : ''}>대기</option>
                <option value="Y" ${report.status == 'Y' ? 'selected' : ''}>처리</option>
                <option value="N" ${report.status == 'N' ? 'selected' : ''}>반려</option>
            </select>
            <button type="button" onclick="changeStatus()">상태변경</button>
        </form>
        <script>
            function changeStatus() {
                var form = document.getElementById("statusForm");
                var data = {
                    reportNo: form.reportNo.value,
                    status: form.status.value
                };
                fetch("${pageContext.request.contextPath}/report/updateStatus", {
                    method: "POST",
                    headers: {"Content-Type": "application/x-www-form-urlencoded"},
                    body: "reportNo=" + data.reportNo + "&status=" + data.status
                })
                .then(res => res.text())
                .then(msg => {
                    if(msg === "success") {
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
