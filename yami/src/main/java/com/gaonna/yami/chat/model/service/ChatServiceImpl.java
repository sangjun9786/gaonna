package com.gaonna.yami.chat.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gaonna.yami.chat.model.dao.ChatDao;
import com.gaonna.yami.chat.model.vo.ChatListView;
import com.gaonna.yami.chat.model.vo.ChatMessage;
import com.gaonna.yami.chat.model.vo.ChatRoom;

@Service
public class ChatServiceImpl implements ChatService {

    @Autowired
    private ChatDao chatDao;

    @Override
    public ChatRoom getOrCreateRoom(int sellerNo, int buyerNo, int productNo) {


    	ChatRoom room = chatDao.findRoomByUsersAndProduct(sellerNo, buyerNo, productNo);
    	if (room != null) return room;


        ChatRoom newRoom = new ChatRoom();
        newRoom.setUser1No(sellerNo);
        newRoom.setUser2No(buyerNo);
        newRoom.setProductNo(productNo);

        chatDao.createRoom(newRoom);
        return chatDao.findRoomByUsersAndProduct(sellerNo, buyerNo, productNo);
    }

    @Override
    public ChatRoom findRoomByUsersAndProduct(int sellerNo, int buyerNo, int productNo) {
        return chatDao.findRoomByUsersAndProduct(sellerNo, buyerNo, productNo);
    }
    
    @Override
    public ChatMessage getLatestMessage(int roomNo, int userNo, String content) {
        return chatDao.selectLatestMessage(roomNo, userNo, content);
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
    public String getUserNameByNo(int userNo) {
        return chatDao.selectUserNameByNo(userNo);
    }
    
    @Override
    public List<ChatListView> getChatListByUser(int userNo) {
        return chatDao.findChatListByUser(userNo);
    }
    
    @Override
    public ChatRoom findRoomByRoomNo(int roomNo) {
        return chatDao.findRoomByRoomNo(roomNo);
    }

    
    
    
}