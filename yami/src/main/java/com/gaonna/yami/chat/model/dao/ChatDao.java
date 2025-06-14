package com.gaonna.yami.chat.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.gaonna.yami.chat.model.vo.ChatMessage;
import com.gaonna.yami.chat.model.vo.ChatRoom;

@Repository
public class ChatDao {

    @Autowired
    private SqlSession sqlSession;

    

    // 방 조회(입장, 생성시 중복확인)
    public ChatRoom findRoomByUsersAndProduct(int user1No, int user2No, int productNo) {
        return sqlSession.selectOne("chatMapper.findRoomByUsersAndProduct", Map.of(
            "user1No", user1No,
            "user2No", user2No,
            "productNo", productNo
        ));
    }

    // 방 생성
    public int createRoom(ChatRoom room) {
        return sqlSession.insert("chatMapper.createRoom", room);
    }


    // 내 채팅방 목록 (userNo 기준)
    public List<ChatRoom> selectMyRooms(int userNo) {
        return sqlSession.selectList("chatMapper.selectMyRooms", userNo);
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
    
    
    public String selectUserIdByNo(int userNo) {
        return sqlSession.selectOne("chatMapper.selectUserIdByNo", userNo);
    }
    
    
    
    
    
}
