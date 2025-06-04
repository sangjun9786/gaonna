package com.gaonna.yami.member.model.vo;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

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
	private String enrollDateStr;//sdf로 변경된 문자열
	private String modifyDateStr;
	private String status;
	
	/*
	 * 권한 테이블에 값이 없으면 roleType == N
	 * 슈퍼 관리자 : superAdmin
	 * 관리자 : admin
	 * 뷰어 : viewer
	 */
	private String roleType;
	
	private int mainCoord; //0이면 대표 동네가 없다는 뜻
	private int mainLocation;
	
	
	//sdf로 변경
	public void memberSDF(List<Member> result) {
		SimpleDateFormat sdf = new SimpleDateFormat("yy년 MM월 dd일 HH시 mm분");
		for (Member member : result) {
			Date enrollDate = member.getEnrollDate();
			if (enrollDate != null) {
				member.setEnrollDateStr(sdf.format(enrollDate));
			} else {
				member.setEnrollDateStr("");
			}
			
			Date modifyDate = member.getModifyDate();
			if (modifyDate != null) {
				member.setModifyDateStr(sdf.format(modifyDate));
			} else {
				member.setModifyDateStr("");
			}
		}
	}
}
