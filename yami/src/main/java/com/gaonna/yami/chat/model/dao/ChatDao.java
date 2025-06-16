package com.gaonna.yami.chat.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.gaonna.yami.chat.model.vo.ChatListView;
import com.gaonna.yami.chat.model.vo.ChatMessage;
import com.gaonna.yami.chat.model.vo.ChatRoom;

@Repository
public class ChatDao {

    @Autowired
    private SqlSession sqlSession;

    	

    //방 조회
    public ChatRoom findRoomByUsersAndProduct(int sellerNo, int buyerNo, int productNo) {
        return sqlSession.selectOne("chatMapper.findRoomByUsersAndProduct", Map.of(
            "user1No", sellerNo,
            "user2No", buyerNo,
            "productNo", productNo
        ));
    }

    // 방 생성
    public int createRoom(ChatRoom room) {
        return sqlSession.insert("chatMapper.createRoom", room);
    }



    // 채팅방 메시지 목록
    public List<ChatMessage> selectMessagesByRoomNo(int roomNo) {
        return sqlSession.selectList("chatMapper.selectMessagesByRoomNo", roomNo);
    }

    // 메시지 저장
    public int insertMessage(ChatMessage message) {
        return sqlSession.insert("chatMapper.insertMessage", message);
    }
    
    public ChatMessage selectLatestMessage(int roomNo, int senderNo, String content) {
        Map<String, Object> param = Map.of(
            "roomNo", roomNo,
            "senderNo", senderNo,
            "content", content
        );
        return sqlSession.selectOne("chatMapper.selectLatestMessage", param);
    }

    // 메시지 일괄 읽음 처리
    public int updateReadAll(int roomNo, int userNo) {
        return sqlSession.update("chatMapper.updateReadAll",
                Map.of("roomNo", roomNo, "userNo", userNo));
    }
    
    
    public int deleteMessage(int messageNo) {
        return sqlSession.delete("chatMapper.deleteMessage", messageNo);
    }
    
    
    public String selectUserNameByNo(int userNo) {
        return sqlSession.selectOne("chatMapper.selectUserNameByNo", userNo);
    }
    
    public List<ChatListView> findChatListByUser(int userNo) {
        return sqlSession.selectList("chatMapper.findChatListByUser", userNo);
    }
    
    public ChatRoom findRoomByRoomNo(int roomNo) {
        return sqlSession.selectOne("chatMapper.findRoomByRoomNo", roomNo);
    }
    
    
    
}