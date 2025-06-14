package com.gaonna.yami.cookie.service;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.gaonna.yami.cookie.vo.CookieToken;
import com.gaonna.yami.member.model.vo.Member;

public interface CookieService {

	//자동로그인 생성
	int autoLogin(HttpServletResponse response,Member loginUser);

	//자동로그인 발동
	int autoLogin(HttpSession session,HttpServletResponse response,CookieToken cookieToken);

}
