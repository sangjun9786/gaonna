<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="container">
    <h2>신고 목록</h2>
    <table border="1" width="100%">
        <tr>
            <th>번호</th>
            <th>유형</th>
            <th>대상번호</th>
            <th>신고자</th>
            <th>사유</th>
            <th>상태</th>
            <th>일시</th>
            <th>상세</th>
        </tr>
        <c:forEach var="report" items="${reportList}">
            <tr>
                <td>${report.reportNo}</td>
                <td>
                  <c:choose>
                    <c:when test="${report.reportType eq 'product'}">게시글</c:when>
                    <c:when test="${report.reportType eq 'reply'}">댓글</c:when>
                    <c:when test="${report.reportType eq 'chat'}">채팅</c:when>
                    <c:otherwise>${report.reportType}</c:otherwise>
                  </c:choose>
                </td>
                <td>${report.targetNo}</td>
                <td>${report.reporterNo}</td>
                <td>${report.reason}</td>
                <td>
                  <c:choose>
                    <c:when test="${report.status eq 'P'}">대기</c:when>
                    <c:when test="${report.status eq 'Y'}">처리</c:when>
                    <c:when test="${report.status eq 'N'}">반려</c:when>
                    <c:otherwise>${report.status}</c:otherwise>
                  </c:choose>
                </td>
                <td>${report.createdAt}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/report/detail?reportNo=${report.reportNo}">상세</a>
                </td>
            </tr>
        </c:forEach>
    </table>
</div>
