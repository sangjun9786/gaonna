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
        body { background: #fff; }
        .container {
            width: 750px; max-width: 98%; margin: 40px auto; background: #fff;
            border-radius: 18px; box-shadow: 0 4px 18px rgba(255, 174, 66, 0.12);
            padding: 35px 40px 25px 40px; display: flex; flex-direction: column; min-height: 700px;
        }
        .chat-header { display: flex; align-items: center; gap: 18px; padding-bottom: 18px; margin-bottom: 14px; border-bottom: 1.5px solid #f1f3f5; }
        .chat-profile-icon { width: 48px; height: 48px; border-radius: 50%; background: linear-gradient(135deg, #ffe5c2 60%, #ffb870 100%); color: #ff8200; font-size: 1.6rem; font-weight: 700; display: flex; align-items: center; justify-content: center; box-shadow: 0 2px 8px #f5e3c1a5; }
        .chat-header-info { display: flex; flex-direction: column; }
        .chat-user-id { font-size: 1.2rem; font-weight: 700; color: #333; }
        .chat-desc { font-size: 0.92rem; color: #bbb; font-weight: 400; }
        #chat-area {
            flex-grow: 1; border: 1.2px solid #ececec; border-radius: 16px;
            padding: 18px 12px; overflow-y: auto; margin-bottom: 18px;
            display: flex; flex-direction: column; gap: 4px;
        }
        .chat-date-separator { display: flex; justify-content: center; margin: 18px 0 10px 0; }
        .chat-date-text { background: #dee2e6; color: #666; font-weight: 500; padding: 5px 18px; border-radius: 18px; font-size: 13px; }
        .msg-row { display: flex; align-items: flex-end; margin-bottom: 4px; }
        .msg-me { justify-content: flex-end; }
        .msg-other { justify-content: flex-start; }
        .msg-bubble {
            max-width: 80%; background: #ff8700; color: #fff;
            padding: 9px 15px; border-radius: 20px 20px 3px 20px;
            font-size: 16px; font-weight: 500; word-break: break-word;
            cursor: pointer;
        }
        .msg-other .msg-bubble { background: #e0e0e0; color: #333; border-radius: 20px 20px 20px 3px; }
        .chat-time { font-size: 12px; color: #ad793b; margin: 0 7px; }
        .unread { font-size: 12px; color: #888; font-weight: bold; margin-right: 6px; }
        #input-area { display: flex; gap: 8px; }
        #chat-input { flex-grow: 1; padding: 13px 18px; font-size: 16px; border-radius: 24px; border: 1.4px solid #ececec; }
        #send-btn { background-color: #ff8700; color: white; border: none; border-radius: 24px; padding: 0 30px; font-size: 17px; font-weight: 700; cursor: pointer; }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<div class="container">
    <div class="chat-header">
        <div class="chat-profile-icon">${fn:toUpperCase(fn:substring(otherName, 0, 1))}</div>
        <div class="chat-header-info">
            <span class="chat-user-id">${otherName}</span>
            <span class="chat-desc">안전한 거래를 위해 채팅창에서만 대화하세요</span>
        </div>
    </div>

    <div id="chat-area">
        <c:set var="prevDate" value="" scope="page" />
        <c:forEach var="msg" items="${chatMessages}">
            <c:set var="currentDate"><fmt:formatDate value="${msg.sentAt}" pattern="yyyy-MM-dd" /></c:set>
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
                <c:if test="${msg.senderNo eq sessionScope.loginUser.userNo && msg.isRead eq 'N'}">
                    <span class="unread">1</span>
                </c:if>
                <div class="msg-bubble"
                    <c:if test="${msg.senderNo eq sessionScope.loginUser.userNo}">
                        ondblclick="deleteMsgByBubble(this)"
                    </c:if>
                    <c:if test="${msg.senderNo ne sessionScope.loginUser.userNo}">
                        ondblclick="reportMsgByBubble(this)"
                    </c:if>>
                    ${msg.content}
                </div>
                <span class="chat-time">
                    <fmt:formatDate value="${msg.sentAt}" pattern="a h:mm" />
                </span>
            </div>
        </c:forEach>
    </div>

    <div id="input-area">
        <input type="text" id="chat-input" placeholder="메시지를 입력하세요"/>
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
var socket = new WebSocket("ws://192.168.150.51:8888/yami/ws/chat?roomNo=" + roomNo);
var chatArea = document.getElementById("chat-area");

function formatKoreanTime(dateString) {
    if (!dateString) return "";
    var date = new Date(dateString);
    var hour = date.getHours();
    var minute = ('0' + date.getMinutes()).slice(-2);
    var period = hour >= 12 ? "오후" : "오전";
    var h12 = hour % 12 || 12;
    return period + " " + h12 + ":" + minute;
}

// 날짜 라벨 관리를 위한 변수 (생략 가능)
var lastMsgDate = (function() {
    var msgs = document.querySelectorAll("#chat-area .msg-row");
    if (msgs.length > 0) {
        var last = msgs[msgs.length-1];
        var time = last.querySelector('.chat-time');
        if (time) {
            var now = new Date();
            var y = now.getFullYear(), m = now.getMonth()+1, d = now.getDate();
            return y + '-' + ('0'+m).slice(-2) + '-' + ('0'+d).slice(-2);
        }
    }
    return null;
})();

socket.onopen = function() {
    socket.send(JSON.stringify({
        type: "read",
        roomNo: roomNo,
        userNo: senderNo
    }));
};

// 메시지 수신(웹소켓)
socket.onmessage = function(event) {
    var data = JSON.parse(event.data);

    // 메시지 도착(type === 'chat')
    if (data.type === "chat") {
        var msgDateObj = new Date(data.sentAt);
        var msgDate = msgDateObj.getFullYear() + "-" +
            ('0' + (msgDateObj.getMonth() + 1)).slice(-2) + "-" +
            ('0' + msgDateObj.getDate()).slice(-2);

        // 날짜 라벨 표시
        if (!lastMsgDate || lastMsgDate !== msgDate) {
            var dateSeparator = document.createElement("div");
            dateSeparator.className = "chat-date-separator";
            var dateText = document.createElement("span");
            dateText.className = "chat-date-text";
            dateText.textContent = msgDateObj.getFullYear() + "년 " + (msgDateObj.getMonth()+1) + "월 " + msgDateObj.getDate() + "일";
            dateSeparator.appendChild(dateText);
            chatArea.appendChild(dateSeparator);
            lastMsgDate = msgDate;
        }

        var whoIsMe = (data.senderNo == senderNo);
        var rowClass = whoIsMe ? "msg-row msg-me" : "msg-row msg-other";
        var msgRow = document.createElement("div");
        msgRow.className = rowClass;
        msgRow.setAttribute("data-msgno", data.messageNo);
        msgRow.setAttribute("data-mine", whoIsMe);

        // 읽음 표시(내가 보낸 메시지이면서 isRead == 'N'만 표시)
        if (whoIsMe && data.isRead === 'N') {
            const unread = document.createElement("span");
            unread.className = "unread";
            unread.textContent = "1";
            msgRow.appendChild(unread);
        }

        var bubble = document.createElement("div");
        bubble.className = "msg-bubble";
        bubble.textContent = data.content;
        if (whoIsMe) {
            bubble.ondblclick = function() { deleteMsgByBubble(bubble); };
        } else {
            bubble.ondblclick = function() { reportMsgByBubble(bubble); };
        }
        var time = document.createElement("span");
        time.className = "chat-time";
        time.textContent = formatKoreanTime(data.sentAt);

        msgRow.appendChild(bubble);
        msgRow.appendChild(time);

        chatArea.appendChild(msgRow);
        chatArea.scrollTop = chatArea.scrollHeight;

        // 읽음 신호 전송 (상대방이 보낸 메시지 도착했을 때만!)
        if (!whoIsMe && data.type === "chat") {
            socket.send(JSON.stringify({
                type: "read",
                roomNo: roomNo,
                userNo: senderNo
            }));
        }
    }
    // 읽음 신호(type === 'read')
    else if (data.type === "read") {
        // 내가 보낸 메시지의 '1' 읽음표시 삭제
        $("#chat-area .msg-row.msg-me .unread").remove();
    }
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
                    result.type = "chat";
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

// 내 메시지 더블클릭 → 삭제
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

// 상대 메시지 더블클릭 → 신고
function reportMsgByBubble(bubble) {
    var row = $(bubble).closest('.msg-row');
    var msgNo = row.data('msgno');
    if (!row.data('mine')) {
        if (confirm('신고 페이지로 이동하시겠습니까?')) {
            location.href = '/yami/report/insertForm?reportType=chat&targetNo=' + msgNo;
        }
    }
}
</script>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
