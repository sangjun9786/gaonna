<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" />

<style>
    .container { max-width: 1100px; }
    h2 { font-weight: 700; color: #222; }
    .table th, .table td { vertical-align: middle; }
    .table td, .table th { font-size: 16px; }
    .badge.bg-warning { background: #ffe08a !important; color: #ad7b00 !important; }
    .badge.bg-success { background: #54c689 !important; }
    .badge.bg-secondary { background: #c6c6c6 !important; }
    @media (max-width: 900px) {
        .container { max-width: 99%; }
        .table th, .table td { font-size: 15px; }
    }
</style>

<div class="container py-5">
    <h2 class="mb-4">신고 목록</h2>
    <div class="table-responsive">
        <table class="table table-bordered align-middle text-center shadow-sm bg-white">
            <thead class="table-light">
                <tr>
                    <th style="width: 6%;">번호</th>
                    <th style="width: 9%;">유형</th>
                    <th style="width: 11%;">대상번호</th>
                    <th style="width: 10%;">신고자</th>
                    <th style="width: 16%;">사유</th>
                    <th style="width: 9%;">상태</th>
                    <th style="width: 15%;">신고일시</th>
                    <th style="width: 15%;">처리일시</th>
                    <th style="width: 9%;">상세</th>
                </tr>
            </thead>
            <tbody>
            <c:forEach var="report" items="${reportList}" varStatus="status">
                <tr>
                    <td>${status.index + 1}</td>
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
                            <c:when test="${report.status eq 'P'}">
                                <span class="badge bg-warning text-dark">대기</span>
                            </c:when>
                            <c:when test="${report.status eq 'Y'}">
                                <span class="badge bg-success">처리</span>
                            </c:when>
                            <c:when test="${report.status eq 'N'}">
                                <span class="badge bg-secondary">반려</span>
                            </c:when>
                            <c:otherwise>${report.status}</c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <fmt:formatDate value="${report.createdAt}" pattern="yyyy년 M월 d일" />
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${report.status eq 'Y' or report.status eq 'N'}">
                                <fmt:formatDate value="${report.handledAt}" pattern="yyyy년 M월 d일" />
                            </c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/report/detail?reportNo=${report.reportNo}" class="btn btn-outline-dark btn-sm px-3">상세</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
