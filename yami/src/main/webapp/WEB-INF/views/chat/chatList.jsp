<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>내 채팅 목록</title>
    <link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@400;700&display=swap" rel="stylesheet">
    <style>
        body {
            background: #fffdf8;
            font-family: 'Pretendard', '맑은 고딕', sans-serif;
        }
        .container {
            max-width: 480px;
            margin: 56px auto 0 auto;
            padding: 38px 32px 34px 32px;
            background: #fff;
            border-radius: 28px;
            box-shadow: 0 6px 36px 0 rgba(255,150,50,0.11);
        }
        h2 {
            font-size: 1.6rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 36px;
            letter-spacing: -1px;
        }
        .chat-item {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            padding: 20px 0 18px 0;
            border-bottom: 1px solid #f5f5f5;
            cursor: pointer;
            transition: background 0.15s;
            position: relative;
        }
        .chat-item:last-child { border-bottom: none; }
        .chat-item:hover {
            background: #fff7ec;
        }
        .avatar-circle {
            width: 40px; height: 40px;
            border-radius: 50%;
            background: linear-gradient(145deg, #ffe4ba 65%, #ffc98c 100%);
            display: flex; align-items: center; justify-content: center;
            font-weight: 700;
            font-size: 18px;
            color: #ff9500;
            margin-right: 18px;
            box-shadow: 0 2px 8px #ffe4ba6c;
            letter-spacing: -1px;
        }
        .chat-info {
            display: flex;
            flex-direction: column;
            flex: 1;
            min-width: 0;
        }
        .username-row {
            display: flex; align-items: center;
        }
        .username {
            font-weight: 700;
            color: #343434;
            font-size: 1.09rem;
            margin-right: 10px;
            max-width: 110px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
        }
        .product-title {
            color: #ff9500;
            font-size: 13px;
            background: #fff6e4;
            display: inline-block;
            border-radius: 10px;
            padding: 3px 9px 2px 9px;
            margin-top: 2px;
            margin-bottom: 5px;
            font-weight: 500;
            max-width: 180px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .last-message {
            font-size: 14px;
            color: #555;
            margin-top: 2px;
            max-width: 190px; 
            overflow: hidden; 
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .right-info {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            min-width: 78px;
        }
        .last-time {
            font-size: 13px;
            color: #bbb;
            margin-bottom: 7px;
            font-family: 'Pretendard', '맑은 고딕', sans-serif;
        }
        .unread-count {
            font-size: 13px;
            color: #fff;
            background: #ff7e0d;
            padding: 3.5px 9.5px 3.5px 9.5px;
            border-radius: 13px;
            font-weight: 700;
            box-shadow: 0 2px 7px #ffd4a06c;
            margin-top: 3px;
        }
        .empty-list-msg {
            color: #bbb;
            text-align: center;
            padding: 44px 0 34px 0;
            font-size: 1.06rem;
            font-weight: 500;
            letter-spacing: -1px;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>내 채팅 목록</h2>
    <div id="chatListArea">
        <c:choose>
            <c:when test="${empty chatList}">
                <div class="empty-list-msg">참여 중인 채팅방이 없습니다.</div>
            </c:when>
            <c:otherwise>
                <c:forEach var="chat" items="${chatList}">
                    <div class="chat-item"
                         onclick="location.href='${pageContext.request.contextPath}/chat/room?roomNo=${chat.roomNo}'">
                        <div class="avatar-circle">
                            <c:out value="${chat.userName.substring(0,1)}"/>
                        </div>
                        <div class="chat-info">
                            <div class="username-row">
                                <span class="username">${chat.userName}</span>
                            </div>
                            <span class="product-title">${chat.productTitle}</span>
                            <span class="last-message">${chat.lastMessage}</span>
                        </div>
                        <div class="right-info">
                            <div class="last-time">${chat.lastSentAt}</div>
                            <c:if test="${chat.unreadCount > 0}">
                                <div class="unread-count">${chat.unreadCount}</div>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
// 오직 리스트 AJAX 새로고침만! (읽음 처리 X)
setInterval(function() {
    $.ajax({
        url: "${pageContext.request.contextPath}/chat/list", 
        type: "GET",
        success: function(data) {
            $("#chatListArea").html($(data).find("#chatListArea").html());
        }
    });
}, 3000); 
</script>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
