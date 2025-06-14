<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>채팅방</title>
    <style>
        body {
            background: #fff;
        }
        .container {
            width: 750px;
            max-width: 98%;
            margin: 40px auto;
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 4px 18px rgba(255, 174, 66, 0.12);
            padding: 35px 40px 25px 40px;
            display: flex;
            flex-direction: column;
            min-height: 700px;
        }
        .chat-header {
            display: flex;
            align-items: center;
            gap: 18px;
            padding-bottom: 18px;
            margin-bottom: 14px;
            border-bottom: 1.5px solid #f1f3f5;
            background: #fff;
        }
        .chat-profile-icon {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background: linear-gradient(135deg, #ffe5c2 60%, #ffb870 100%);
            color: #ff8200;
            font-size: 1.6rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 2px 8px #f5e3c1a5;
            letter-spacing: 0.5px;
            user-select: none;
        }
        .chat-header-info {
            display: flex; flex-direction: column;
        }
        .chat-user-id {
            font-size: 1.2rem; font-weight: 700; color: #333;
            letter-spacing: -0.5px; margin-bottom: 1px;
        }
        .chat-desc {
            font-size: 0.92rem; color: #bbb; font-weight: 400; margin-top: 2px;
        }
        #chat-area {
            flex-grow: 1;
            background: #fff;
            border: 1.2px solid #ececec;
            border-radius: 16px;
            padding: 18px 12px 18px 12px;
            overflow-y: auto;
            margin-bottom: 18px;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
            gap: 4px;
        }
        .chat-date-separator {
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 18px 0 10px 0;
        }
        .chat-date-text {
            background: #dee2e6;
            color: #666;
            font-weight: 500;
            padding: 5px 18px;
            border-radius: 18px;
            font-size: 13px;
            letter-spacing: 0.2px;
            box-shadow: none;
        }
        .msg-row { display: flex; align-items: flex-end; margin-bottom: 4px; position: relative; }
        .msg-me { justify-content: flex-end; }
        .msg-other { justify-content: flex-start; }
        .msg-bubble {
            max-width: 80%;
            background: #ff8700;
            color: #fff;
            padding: 9px 15px 8px 15px;
            border-radius: 20px 20px 3px 20px;
            font-size: 16px;
            font-weight: 500;
            word-break: break-all;
            position: relative;
            box-shadow: 0 1px 6px rgba(255, 174, 66, 0.07);
            user-select: text;
        }
        .msg-other .msg-bubble {
            background: #e0e0e0;
		    color: #333;
		    border-radius: 20px 20px 20px 3px;
        }
        .chat-time {
            color: #ad793b;
            font-size: 12px;
            margin: 0 7px;
            white-space: nowrap;
            align-self: flex-end;
        }
        #input-area {
            display: flex;
            gap: 8px;
            margin-top: 10px;
        }
        #chat-input {
            flex-grow: 1;
            padding: 13px 18px;
            font-size: 16px;
            border-radius: 24px;
            border: 1.4px solid #ececec;      
            outline: none;
            background: #fff;                
            color: #333;
            transition: border-color 0.2s;
        }
        #chat-input:focus {
            border-color: #ffb066;  
            box-shadow: 0 0 5px #ffecb3a0;
        }
        #chat-input::placeholder {
            color: #888;          
            font-weight: 400;
            opacity: 1;
        }
        #send-btn {
            background-color: #ff8700;
            color: white;
            border: none;
            border-radius: 24px;
            padding: 0 30px;
            font-size: 17px;
            font-weight: 700;
            cursor: pointer;
            transition: background-color 0.22s;
        }
        #send-btn:hover {
            background-color: #ffad4b;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <div class="container">

        <div class="chat-header">
            <div class="chat-profile-icon">
                ${fn:toUpperCase(fn:substring(otherId, 0, 1))}
            </div>
            <div class="chat-header-info">
                <span class="chat-user-id">${otherId}</span>
                <span class="chat-desc">안전한 거래를 위해 채팅창에서만 대화하세요</span>
            </div>
        </div>

        <!-- 메시지 영역 -->
        <div id="chat-area">
            <c:set var="prevDate" value="" scope="page" />
            <c:forEach var="msg" items="${chatMessages}">
                <c:set var="currentDate">
                    <fmt:formatDate value="${msg.sentAt}" pattern="yyyy-MM-dd" />
                </c:set>
                <c:if test="${prevDate ne currentDate}">
                    <div class="chat-date-separator">
                        <span class="chat-date-text">
                            <fmt:formatDate value="${msg.sentAt}" pattern="yyyy년 M월 d일" />
                        </span>
                    </div>
                    <c:set var="prevDate" value="${currentDate}" scope="page"/>
                </c:if>
                <div class="msg-row ${msg.senderNo eq sessionScope.loginUser.userNo ? 'msg-me' : 'msg-other'}"
                     data-msgno="${msg.messageNo}" data-mine="${msg.senderNo eq sessionScope.loginUser.userNo}">
                    <div class="msg-bubble"
                        <c:if test="${msg.senderNo eq sessionScope.loginUser.userNo}">
                            ondblclick="deleteMsgByBubble(this)"
                        </c:if>
                    >
                        ${msg.content}
                    </div>
                    <span class="chat-time">
                        <fmt:formatDate value="${msg.sentAt}" pattern="a h:mm" />
                    </span>
                </div>
            </c:forEach>
        </div>
        <div id="input-area">
            <input type="text" id="chat-input" autocomplete="off" placeholder="메시지를 입력하세요"/>
            <button id="send-btn" onclick="sendMsg()" aria-label="전송">
                <svg width="26" height="26" fill="none" stroke="#fff" stroke-width="2.7" viewBox="0 0 24 24">
                    <path d="M5 12h14M13 6l6 6-6 6" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
            </button>
        </div>
    </div>
    <script>
        var roomNo = "${chatRoom.roomNo}";
        var senderNo = "${sessionScope.loginUser.userNo}";
        var socket = new WebSocket("ws://localhost:8888/yami/ws/chat?roomNo=" + roomNo);

        $.post("/yami/chat/readAll", {roomNo: roomNo});

        function formatKoreanTime(dateString) {
            if (!dateString) return "";
            var date = new Date(dateString);
            var hour = date.getHours();
            var minute = ('0' + date.getMinutes()).slice(-2);
            var isPM = hour >= 12;
            var period = isPM ? "오후" : "오전";
            var h12 = hour % 12;
            if (h12 === 0) h12 = 12;
            return period + " " + h12 + ":" + minute;
        }

        socket.onmessage = function(event) {
            var data = JSON.parse(event.data);
            var whoIsMe = (data.senderNo == senderNo);
            var rowClass = whoIsMe ? "msg-row msg-me" : "msg-row msg-other";
            var chatArea = document.getElementById("chat-area");

            // 메시지 생성 (신규 메시지에 삭제 기능 포함)
            var msgRow = document.createElement("div");
            msgRow.className = rowClass;
            msgRow.setAttribute("data-msgno", data.messageNo);
            msgRow.setAttribute("data-mine", whoIsMe);

            var bubble = document.createElement("div");
            bubble.className = "msg-bubble";
            bubble.textContent = data.content;

            // 내 메시지만 더블클릭 이벤트 부여
            if (whoIsMe) {
                bubble.ondblclick = function() { deleteMsgByBubble(bubble); };
            }

            var time = document.createElement("span");
            time.className = "chat-time";
            time.textContent = formatKoreanTime(data.sentAt);

            msgRow.appendChild(bubble);
            msgRow.appendChild(time);

            chatArea.appendChild(msgRow);
            chatArea.scrollTop = chatArea.scrollHeight;
        };

        function sendMsg() {
            var input = $("#chat-input");
            var msg = input.val();
            if (msg) {
                $.ajax({
                    url: "/yami/chat/send",
                    type: "POST",
                    data: { roomNo: roomNo, content: msg },
                    success: function(result) {
                        if (result) {
                            socket.send(JSON.stringify(result));
                            input.val("");
                        } else {
                            alert("메시지 전송 실패!");
                        }
                    },
                    error: function() {
                        alert("서버 통신 오류!");
                    }
                });
            }
        }

        $("#chat-input").keyup(function(e) {
            if (e.key === "Enter") sendMsg();
        });

        // --- 메시지 삭제(더블클릭) ---
        function deleteMsgByBubble(bubble) {
            var row = $(bubble).closest('.msg-row');
            var msgNo = row.data('msgno');
            if (row.data('mine')) {
                if (confirm('정말 삭제하시겠습니까?')) {
                    $.post('/yami/chat/delete', { messageNo: msgNo }, function(result) {
                        if(result === 'success') row.remove();
                        else alert('삭제 실패');
                    });
                }
            }
        }
    </script>
</body>
</html>
