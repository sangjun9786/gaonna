<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>알림함</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/bootstrap/5.3.5/css/bootstrap.min.css">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <style>
        body { background: #f7f8fa; }
        .alarm-list-container {
            max-width: 540px; margin: 48px auto 0 auto; background: #fff;
            border-radius: 22px; box-shadow: 0 4px 20px rgba(0,0,0,0.07);
            padding: 30px 32px 20px 32px;
        }
        .alarm-list-title {
            font-size: 2.1rem; font-weight: 700; margin-bottom: 18px; color: #222;
        }
        .alarm-item {
            display: flex; align-items: center; padding: 15px 0 15px 0;
            border-bottom: 1px solid #f1f3f6;
            transition: background 0.2s;
            position: relative;
        }
        .alarm-item:last-child { border-bottom: none; }
        .alarm-item.unread {
            background: #fff7eb;
        }
        .alarm-badge-dot {
            display: inline-block; width: 12px; height: 12px; border-radius: 50%;
            background: #ff9100; margin-right: 14px; flex-shrink: 0;
            box-shadow: 0 0 0 2px #fff7eb;
        }
        .alarm-type-icon {
            font-size: 1.6rem; margin-right: 10px; opacity: 0.86;
        }
        .alarm-content { flex-grow: 1; font-size: 1.11rem; color: #313336; }
        .alarm-content a { color: inherit; text-decoration: none; }
        .alarm-content a:hover { text-decoration: underline; }
        .alarm-date {
            font-size: 0.98rem; color: #b6b6b6; min-width: 74px; text-align: right;
            margin-left: 16px;
        }
        .alarm-delete-btn {
            border: none; background: none; color: #d2d2d2; font-size: 20px;
            margin-left: 13px; cursor: pointer; transition: color 0.18s;
        }
        .alarm-delete-btn:hover { color: #ff4848; }
        @media (max-width: 700px) {
            .alarm-list-container { padding: 18px 4vw 12px 4vw; }
            .alarm-list-title { font-size: 1.5rem; }
            .alarm-content { font-size: 1rem; }
        }
        .alarm-action-bar {
            margin-top: 18px; display: flex; justify-content: flex-end; gap: 10px;
        }
        .alarm-action-bar button {
            border-radius: 9px; font-weight: 600; min-width: 98px;
            box-shadow: 0 1px 3px rgba(255,184,0,0.07);
        }
        /* 스크롤 시 리스트 아래 여백 */
        .alarm-list-container { margin-bottom: 80px; }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
</head>
<body>
<div class="alarm-list-container shadow">
    <div class="alarm-list-title mb-3">
        <span>🔔 내 알림함</span>
    </div>
    <c:if test="${empty alarmList}">
        <div class="text-center text-muted py-5">알림이 없습니다.</div>
    </c:if>
    <c:forEach var="alarm" items="${alarmList}">
        <div class="alarm-item ${alarm.isRead eq 'N' ? 'unread' : ''}">
            <c:if test="${alarm.isRead eq 'N'}">
                <span class="alarm-badge-dot"></span>
            </c:if>
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
            <button class="alarm-delete-btn" onclick="deleteAlarm(${alarm.alarmNo})" title="삭제">&times;</button>
        </div>
    </c:forEach>
    <div class="alarm-action-bar">
        <button class="btn btn-outline-secondary btn-sm" onclick="deleteAllAlarms()">알림 전체 삭제</button>
        <button class="btn btn-warning btn-sm" style="color:#333;" onclick="readAllAlarms()">모두 읽음 처리</button>
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
