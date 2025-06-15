package com.gaonna.yami.chat.model.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ChatRoom {
    private int roomNo;      
    private int user1No;      //판매자
    private int user2No;      //구매자
    private int productNo;     
    private Date createdAt;    
    private String status;      // 채팅방 상태 (A:활성, C:완료, D:삭제 )
}
