package com.gaonna.yami.chat.model.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ChatMessage {
    private int messageNo;  
    private int roomNo;       
    private int senderNo;    
    private String content;  
    private Date sentAt;     
    private String isRead;    // 읽음 여부 ('N', 'Y')
}
