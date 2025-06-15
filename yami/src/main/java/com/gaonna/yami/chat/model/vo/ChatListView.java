package com.gaonna.yami.chat.model.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ChatListView {
	private int roomNo;
    private String productTitle;
    private String lastMessage;
    private String lastSentAt; 
    private int unreadCount;
    private String userName;
    private int productNo;
    private int sellerNo;

}
