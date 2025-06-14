package com.gaonna.yami.chat.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gaonna.yami.chat.model.dao.ChatDao;
import com.gaonna.yami.chat.model.vo.ChatMessage;
import com.gaonna.yami.chat.model.vo.ChatRoom;

@Service
public class ChatServiceImpl implements ChatService {

    @Autowired
    private ChatDao chatDao;

    @Override
    public ChatRoom getOrCreateRoom(int sellerNo, int buyerNo, int productNo) {

        int user1 = Math.min(sellerNo, buyerNo);
        int user2 = Math.max(sellerNo, buyerNo);

        ChatRoom room = chatDao.findRoomByUsersAndProduct(user1, user2, productNo);
        if (room != null) return room;

        ChatRoom newRoom = new ChatRoom();
        newRoom.setUser1No(user1);
        newRoom.setUser2No(user2);
        newRoom.setProductNo(productNo);

        chatDao.createRoom(newRoom);
        return chatDao.findRoomByUsersAndProduct(user1, user2, productNo);
    }

    @Override
    public ChatRoom findRoomByUsersAndProduct(int sellerNo, int userNo, int productNo) {
        int user1 = Math.min(sellerNo, userNo);
        int user2 = Math.max(sellerNo, userNo);
        return chatDao.findRoomByUsersAndProduct(user1, user2, productNo);
    }
    
    @Override
    public ChatMessage getLatestMessage(int roomNo, int userNo, String content) {
        return chatDao.selectLatestMessage(roomNo, userNo, content);
    }

    @Override
    public List<ChatRoom> getMyRooms(int userNo) {
        return chatDao.selectMyRooms(userNo);
    }

    @Override
    public List<ChatMessage> getMessages(int roomNo) {
        return chatDao.selectMessagesByRoomNo(roomNo);
    }

    @Override
    public int sendMessage(ChatMessage message) {
        return chatDao.insertMessage(message);
    }

    @Override
    public int readAllMessages(int roomNo, int userNo) {
        return chatDao.updateReadAll(roomNo, userNo);
    }
    
    @Override
    public int deleteMessage(int messageNo) {
        return chatDao.deleteMessage(messageNo);
    }
    
    @Override
    public String getUserIdByNo(int userNo) {
        return chatDao.selectUserIdByNo(userNo);
    }
    
    
    
}
