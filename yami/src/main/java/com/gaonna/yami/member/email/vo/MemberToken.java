package com.gaonna.yami.member.email.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class MemberToken {
	//이메일 인증시 사용하는 토큰
	private int userNo; //토큰을 발행한 유저 식별번호
	private int tokenNo; //토큰 번호
	private String token; //암호화된 토큰
	private Date generatedTime; //토큰을 만든 시간
	
	
	public MemberToken(int userNo, String token) {
		super();
		this.userNo = userNo;
		this.token = token;
	}
}
