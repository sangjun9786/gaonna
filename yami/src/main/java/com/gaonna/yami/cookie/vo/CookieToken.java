package com.gaonna.yami.cookie.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class CookieToken {
	private int tokenNo;
	private String token;
	private int userNo;
	
	
	public CookieToken(String token, int userNo) {
		super();
		this.token = token;
		this.userNo = userNo;
	}
}
