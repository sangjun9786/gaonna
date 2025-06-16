package com.gaonna.yami.chat.websocket;

import java.util.Collections;
import com.gaonna.yami.chat.common.ApplicationContextProvider; 
import com.gaonna.yami.chat.model.service.ChatService;         

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

public class ChatWebSocketHandler extends TextWebSocketHandler {

    // 방 번호별 세션 관리
    private static Map<Integer, Set<WebSocketSession>> roomSessions = new HashMap<>();

    private int getRoomNoFromSession(WebSocketSession session) {
        String query = session.getUri().getQuery(); 
        if (query != null) {
            for (String param : query.split("&")) {
                if (param.startsWith("roomNo=")) {
                    try {
                        return Integer.parseInt(param.split("=")[1]);
                    } catch (Exception e) {
                        return -1;
                    }
                }
            }
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

        JSONParser parser = new JSONParser();
        JSONObject obj = (JSONObject) parser.parse(payload);
        int roomNo = Integer.parseInt(obj.get("roomNo").toString());

        Set<WebSocketSession> receivers = roomSessions.get(roomNo);
        if (receivers != null) {
            // 1. 채팅 메시지 broadcast
            if ("chat".equals(obj.get("type"))) {
                for (WebSocketSession s : receivers) {
                    if (s.isOpen()) s.sendMessage(new TextMessage(payload));
                }
            }
            // 2. 읽음 신호 broadcast	
            else if ("read".equals(obj.get("type"))) {
            	int userNo = Integer.parseInt(obj.get("userNo").toString());
            	ChatService chatService = ApplicationContextProvider.getBean(ChatService.class);
            	chatService.readAllMessages(roomNo, userNo);
            	
                for (WebSocketSession s : receivers) {
                    if (s.isOpen()) s.sendMessage(new TextMessage(payload));
                }
            }
        }
    }

}
