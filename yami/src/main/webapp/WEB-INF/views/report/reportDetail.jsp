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
                <tr>
                    <th class="table-light" style="width:30%;">신고번호</th>
                    <td>${report.reportNo}</td>
                </tr>
                <tr>
                    <th class="table-light">신고유형</th>
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
                    <th class="table-light">신고대상번호</th>
                    <td>${report.targetNo}</td>
                </tr>
                <tr>
                    <th class="table-light">신고자</th>
                    <td>${report.reporterNo}</td>
                </tr>
                <tr>
                    <th class="table-light">사유</th>
                    <td>${report.reason}</td>
                </tr>
                <tr>
                    <th class="table-light">상세내용</th>
                    <td>${report.content}</td>
                </tr>
                <tr>
                    <th class="table-light">상태</th>
                    <td>
                        <c:choose>
                            <c:when test="${report.status eq 'P'}"><span class="badge bg-warning text-dark">대기</span></c:when>
                            <c:when test="${report.status eq 'Y'}"><span class="badge bg-success">처리</span></c:when>
                            <c:when test="${report.status eq 'N'}"><span class="badge bg-secondary">반려</span></c:when>
                            <c:otherwise>${report.status}</c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <th class="table-light">신고일시</th>
                    <td>
                        <fmt:formatDate value="${report.createdAt}" pattern="yyyy년 M월 d일" />
                    </td>
                </tr>
                <tr>
                    <th class="table-light">처리일시</th>
                    <td>
                        <c:choose>
                            <c:when test="${not empty report.handledAt}">
                                <fmt:formatDate value="${report.handledAt}" pattern="yyyy년 M월 d일" />
                            </c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </table>

           <!-- 관리자만 상태 변경, 처리(Y)/반려(N)면 비활성화 -->
			<c:if test="${not empty loginUser && loginUser.roleType != 'N'}">
			    <form id="statusForm" class="d-flex gap-2 mt-3">
			        <input type="hidden" name="reportNo" value="${report.reportNo}">
			        
			        <!-- Y or N이면 선택 못하도록 disabled -->
			        <select name="status" class="form-select w-auto"
			            <c:if test="${report.status eq 'Y' || report.status eq 'N'}">disabled</c:if>>
			            <option value="P" <c:if test="${report.status eq 'P'}">selected</c:if>>대기</option>
			            <option value="Y" <c:if test="${report.status eq 'Y'}">selected</c:if>>처리</option>
			            <option value="N" <c:if test="${report.status eq 'N'}">selected</c:if>>반려</option>
			        </select>
			
			        <!-- 처리완료(Y) 또는 반려(N)면 버튼도 막기 -->
			        <button type="button" onclick="changeStatus()" class="btn btn-danger"
			            <c:if test="${report.status eq 'Y' || report.status eq 'N'}">disabled</c:if>>
			            상태변경
			        </button>
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
    </div>
</div>
