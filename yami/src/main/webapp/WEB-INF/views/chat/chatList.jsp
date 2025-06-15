<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>채팅방 목록</title>
    <style>
        .container {
            max-width: 760px;
            margin: 40px auto;
            padding: 30px;
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 16px rgba(255, 165, 0, 0.1);
        }
        .chat-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px 20px;
            margin-bottom: 14px;
            border: 1px solid #eee;
            border-radius: 12px;
            transition: background 0.2s;
            cursor: pointer;
        }
        .chat-item:hover {
            background-color: #fff8ef;
        }
        .chat-info {
            display: flex;
            flex-direction: column;
        }
        .username {
            font-weight: bold;
            color: #333;
            font-size: 16px;
        }
        .product-title {
            font-size: 14px;
            color: #777;
            margin-top: 3px;
        }
        .last-message {
            font-size: 14px;
            color: #555;
            margin-top: 4px;
        }
        .right-info {
            text-align: right;
        }
        .last-time {
            font-size: 13px;
            color: #999;
        }
        .unread-count {
            margin-top: 6px;
            font-size: 12px;
            color: #fff;
            background-color: #ff6f0f;
            padding: 3px 8px;
            border-radius: 20px;
            display: inline-block;
            font-weight: bold;
        }
    </style>
</head>
<body>

<div class="container">
    <h2 style="margin-bottom: 24px;">내 채팅방 목록</h2>

    <c:choose>
        <c:when test="${empty chatList}">
            <p style="color: #888;">참여 중인 채팅방이 없습니다.</p>
        </c:when>
        <c:otherwise>
            <c:forEach var="chat" items="${chatList}">
                <div class="chat-item"
                     onclick="location.href='${pageContext.request.contextPath}/chat/room?productNo=${chat.productNo}&sellerNo=${chat.sellerNo}'">
                    <div class="chat-info">
                        <span class="username">${chat.userName}</span>
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

</body>
</html>
