package com.gaonna.yami.chat.websocket;

import org.springframework.web.socket.*;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import java.util.*;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

public class ChatWebSocketHandler extends TextWebSocketHandler {

    // 방 번호별 세션 관리
    private static Map<Integer, Set<WebSocketSession>> roomSessions = new HashMap<>();

    private int getRoomNoFromSession(WebSocketSession session) {
        // ws://.../ws/chat?roomNo=123
        String query = session.getUri().getQuery(); // "roomNo=123"
        if(query != null && query.startsWith("roomNo=")) {
            return Integer.parseInt(query.replace("roomNo=", ""));
        }
        return -1;
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        int roomNo = getRoomNoFromSession(session);
        roomSessions.putIfAbsent(roomNo, Collections.synchronizedSet(new HashSet<>()));
        roomSessions.get(roomNo).add(session);
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        int roomNo = getRoomNoFromSession(session);
        Set<WebSocketSession> set = roomSessions.get(roomNo);
        if(set != null) set.remove(session);
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        String payload = message.getPayload();

        // JSON 파싱 (json-simple)
        JSONParser parser = new JSONParser();
        JSONObject obj = (JSONObject) parser.parse(payload);
        int roomNo = Integer.parseInt(obj.get("roomNo").toString());

        Set<WebSocketSession> receivers = roomSessions.get(roomNo);
        if (receivers != null) {
            for (WebSocketSession s : receivers) {
                if (s.isOpen()) s.sendMessage(new TextMessage(payload));
            }
        }
    }
}
