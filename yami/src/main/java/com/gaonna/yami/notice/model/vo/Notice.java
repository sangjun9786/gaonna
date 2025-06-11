package com.gaonna.yami.notice.model.vo;

import java.sql.Date;
	

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Notice {

    private int noticeNo;        
    private String noticeTitle;    
    private String noticeContent; 
    private int userNo;        
    private int count;             
    private Date createDate;       
    private Date modifyDate;       
    private String status;     
    private String userId;
}
