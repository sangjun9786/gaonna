package com.gaonna.yami.cookie.service;

import java.time.Duration;
import java.util.UUID;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseCookie;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gaonna.yami.cookie.dao.CookieDao;
import com.gaonna.yami.cookie.vo.CookieToken;
import com.gaonna.yami.member.model.vo.Member;

@Service
public class CookieServiceImpl implements CookieService{
	@Autowired
	private SqlSessionTemplate sqlSession;
	@Autowired
	private CookieDao dao;
	
	//자동로그인
	@Transactional
	@Override
	public int autoLogin(HttpServletResponse response
			,Member loginUser) {
		//토큰 생성
		String token = UUID.randomUUID().toString();
		
		//토큰과 유저정보 저장
		CookieToken cookieToken = new CookieToken(
				token,loginUser.getUserNo());
		int result = dao.autoLogin(sqlSession,cookieToken);
		
		//토큰에 토큰번호 더해서 온전한 토큰 만들기
		token = cookieToken.getTokenNo() +"%"+ token;

		//달디달고 달디단 쿠키 생성
		ResponseCookie cookie = ResponseCookie.from("autoLogin", token)
		        .httpOnly(true)
		        .secure(true)
		        .path("/")
		        .maxAge(Duration.ofDays(30))
		        .build();
		response.addHeader("Set-Cookie", cookie.toString());
		
		return result;
	}
}
