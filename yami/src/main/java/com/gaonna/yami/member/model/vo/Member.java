package com.gaonna.yami.member.model.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@NoArgsConstructor
@AllArgsConstructor
@Data
public class Member {
	private int userNo;
	private String userId;
	private String userPwd;
	private String userName;
	private String phone;
	
	private Date enrollDate;
	private Date modifyDate;
	private String status;
	
	private String userRole; //권한 테이블에 값이 있으면 Y, 없으면 N
}
