<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
        .chat-room {
            padding: 18px 24px;
            border: 1px solid #eee;
            border-radius: 12px;
            margin-bottom: 14px;
            transition: background 0.2s;
            display: flex;
            justify-content: space-between;
            align-items: center;
            cursor: pointer;
        }
        .chat-room:hover {
            background-color: #fff9f3;
        }
        .room-info {
            display: flex;
            flex-direction: column;
        }
        .user-id {
            font-size: 16px;
            font-weight: bold;
            color: #333;
        }
        .product-title {
            font-size: 14px;
            color: #777;
            margin-top: 5px;
        }
        .enter-btn {
            padding: 8px 18px;
            background-color: #ff8700;
            color: #fff;
            font-weight: bold;
            border: none;
            border-radius: 20px;
            cursor: pointer;
        }
        .enter-btn:hover {
            background-color: #ffa94d;
        }
    </style>
</head>
<body>

<div class="container">
    <h2 style="margin-bottom: 24px;">내 채팅방 목록</h2>

    <c:choose>
        <c:when test="${empty chatRooms}">
            <p style="color: #888;">참여 중인 채팅방이 없습니다.</p>
        </c:when>
        <c:otherwise>
            <c:forEach var="room" items="${chatRooms}">
                <div class="chat-room" onclick="goChat(${room.roomNo}, ${room.productNo}, ${room.user1No}, ${room.user2No})">
                    <div class="room-info">
                        <div class="user-id">
                            채팅방 번호: ${room.roomNo}
                        </div>
                        <div class="product-title">
                            상품 번호: ${room.productNo}
                        </div>
                    </div>
                    <button class="enter-btn">입장</button>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>

<script>
    const myNo = "${sessionScope.loginUser.userNo}";

    function goChat(roomNo, productNo, user1No, user2No) {
        const sellerNo = (myNo == user1No) ? user2No : user1No;
        location.href = "/yami/chat/room?productNo=" + productNo + "&sellerNo=" + sellerNo;
    }
</script>

</body>
</html>
