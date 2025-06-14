	package com.gaonna.yami.chat.model.service;
	
	import java.util.List;
	
	import com.gaonna.yami.chat.model.vo.ChatMessage;
	import com.gaonna.yami.chat.model.vo.ChatRoom;
	
	public interface ChatService {
		//생성
		ChatRoom getOrCreateRoom(int sellerNo, int buyerNo, int productNo);
		//입장
		ChatRoom findRoomByUsersAndProduct(int sellerNo, int userNo, int productNo);
	    
	    List<ChatRoom> getMyRooms(int userNo);
	
	    List<ChatMessage> getMessages(int roomNo);
	
	    int sendMessage(ChatMessage message);
	
	    int readAllMessages(int roomNo, int userNo);
	
		ChatMessage getLatestMessage(int roomNo, int userNo, String content);
		
		int deleteMessage(int messageNo); 
		
		String getUserIdByNo(int userNo);
	}
