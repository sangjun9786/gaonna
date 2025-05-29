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
	private int point;
	
	private Date enrollDate;
	private Date modifyDate;
	private String status;
	
	
	/*
	 * 권한 테이블에 값이 없으면 roleType == N
	 * 슈퍼 관리자 : superAdmin
	 * 관리자 : admin
	 * 뷰어 : viewer
	 */
	private String roleType;
	
	private int mainCoord;
	private int mainLocation;
}
