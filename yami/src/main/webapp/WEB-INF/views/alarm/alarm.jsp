<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>알림함</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/bootstrap/5.3.5/css/bootstrap.min.css">
    <style>
        .alarm-list-container { max-width: 580px; margin: 44px auto; background: #fff; border-radius: 18px; box-shadow: 0 4px 18px rgba(0,0,0,0.08); padding: 32px 36px 20px 36px; }
        .alarm-item { border-bottom: 1px solid #f1f3f5; padding: 14px 0; display: flex; align-items: center; }
        .alarm-content { flex-grow: 1; }
        .alarm-unread { font-weight: 700; color: #FF8700; }
        .alarm-date { font-size: 12px; color: #bbb; min-width: 75px; text-align: right; }
        .alarm-type-icon { margin-right: 10px; font-size: 22px; }
        .alarm-delete-btn { border: none; background: none; color: #999; font-size: 18px; margin-left: 10px; cursor: pointer;}
        .alarm-content a { text-decoration: none; color: inherit; }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
</head>
<body>
<div class="alarm-list-container">
    <h3>내 알림함</h3>
    <c:if test="${empty alarmList}">
        <div class="text-center text-muted py-5">알림이 없습니다.</div>
    </c:if>
    <c:forEach var="alarm" items="${alarmList}">
        <div class="alarm-item ${alarm.isRead eq 'N' ? 'alarm-unread' : ''}">
            <span class="alarm-type-icon">
                <c:choose>
                    <c:when test="${alarm.type eq 'reply'}">💬</c:when>
                    <c:when test="${alarm.type eq 'chat'}">🟠</c:when>
                    <c:otherwise>🔔</c:otherwise>
                </c:choose>
            </span>
            <span class="alarm-content">
                <c:choose>
                    <c:when test="${alarm.type eq 'chat'}">
                        <a href="${pageContext.request.contextPath}/chat/room?roomNo=${alarm.refNo}">
                            <c:out value="${alarm.content}" />
                        </a>
                    </c:when>
                    <c:when test="${alarm.type eq 'reply'}">
					    <a href="${pageContext.request.contextPath}/alarm/readOneAndRedirect?alarmNo=${alarm.alarmNo}&type=${alarm.type}&refNo=${alarm.refNo}">
					        <c:out value="${alarm.content}" />
					    </a>
					</c:when>
                    <c:otherwise>
                        <c:out value="${alarm.content}" />
                    </c:otherwise>
                </c:choose>
            </span>
            <span class="alarm-date">
                <fmt:formatDate value="${alarm.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
            </span>
            <button class="alarm-delete-btn" onclick="deleteAlarm(${alarm.alarmNo})">&times;</button>
        </div>
    </c:forEach>
    <div class="text-end mt-3">
        <button class="btn btn-sm btn-outline-secondary" onclick="deleteAllAlarms()">알림 전체 삭제</button>
        <button class="btn btn-sm btn-primary" onclick="readAllAlarms()">모두 읽음 처리</button>
    </div>
</div>

<script>
function deleteAlarm(alarmNo) {
    if(confirm("이 알림을 삭제하시겠습니까?")) {
        $.post("${pageContext.request.contextPath}/alarm/delete", { alarmNo: alarmNo }, function(result) {
            if(result === 'success') location.reload();
            else alert("삭제 실패");
        });
    }
}
function deleteAllAlarms() {
    if(confirm("알림을 모두 삭제할까요?")) {
        $.post("${pageContext.request.contextPath}/alarm/deleteAll", function(result) {
            if(result === 'success') location.reload();
            else alert("삭제 실패");
        });
    }
}
function readAllAlarms() {
    $.post("${pageContext.request.contextPath}/alarm/readAll", function(result) {
        if(result === 'success') location.reload();
        else alert("실패");
    });
}
</script>
</body>
</html>
