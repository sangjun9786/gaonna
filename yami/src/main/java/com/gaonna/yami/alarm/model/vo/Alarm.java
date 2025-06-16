package com.gaonna.yami.alarm.model.vo;

import java.util.Date;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Alarm {
    private int alarmNo;
    private int userNo;
    private String type;     // 댓글,채팅
    private int refNo;       // ROOM_NO or REPLY_NO
    private String content; 
    private String isRead;   // "N", "Y"
    private Date createdAt;
}
