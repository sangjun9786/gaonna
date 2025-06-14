package com.gaonna.yami.cookie.service;

import javax.servlet.http.HttpServletResponse;

import com.gaonna.yami.member.model.vo.Member;

public interface CookieService {

	//자동로그인
	int autoLogin(HttpServletResponse response,Member loginUser);

}
