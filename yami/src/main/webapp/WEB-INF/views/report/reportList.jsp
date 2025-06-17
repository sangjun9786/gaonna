<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" />

<div class="container py-5">
    <h2 class="mb-4">대기 신고 목록</h2>
    <div class="btn-group mb-3">
        <a href="${pageContext.request.contextPath}/report/list" class="btn btn-outline-warning active">대기 신고</a>
        <a href="${pageContext.request.contextPath}/report/archived" class="btn btn-secondary">처리/반려 신고</a>
    </div>
    <div class="table-responsive">
        <table class="table table-bordered align-middle text-center shadow-sm bg-white">
            <thead class="table-light">
                <tr>
                    <th>번호</th>
                    <th>유형</th>
                    <th>대상번호</th>
                    <th>신고자</th>
                    <th>사유</th>
                    <th>상태</th>
                    <th>신고일시</th>
                    <th>상세</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty reportList}">
                        <tr><td colspan="8" class="text-muted">대기 중인 신고가 없습니다.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="report" items="${reportList}" varStatus="status">
                            <c:if test="${report.STATUS eq 'P'}">
                                <tr>
                                    <td>${status.index + 1}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${report.REPORT_TYPE eq 'product'}">게시글</c:when>
                                            <c:when test="${report.REPORT_TYPE eq 'reply'}">댓글</c:when>
                                            <c:when test="${report.REPORT_TYPE eq 'chat'}">채팅</c:when>
                                            <c:otherwise>${report.REPORT_TYPE}</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${report.TARGET_NO}</td>
                                    <td>${report.REPORTERNAME}</td>
                                    <td>${report.REASON}</td>
                                    <td><span class="badge bg-warning text-dark">대기</span></td>
                                    <td><fmt:formatDate value="${report.CREATED_AT}" pattern="yyyy년 M월 d일" /></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/report/detail?reportNo=${report.REPORT_NO}" class="btn btn-outline-dark btn-sm">상세</a>
                                    </td>	
                                </tr>
                            </c:if>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>
