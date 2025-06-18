package com.gaonna.yami.cookie.service;

import java.time.Duration;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseCookie;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gaonna.yami.admin.service.AdminService;
import com.gaonna.yami.cookie.dao.CookieDao;
import com.gaonna.yami.cookie.vo.CookieToken;
import com.gaonna.yami.location.service.LocationService;
import com.gaonna.yami.location.vo.Coord;
import com.gaonna.yami.member.model.vo.Member;

@Service
public class CookieServiceImpl implements CookieService{
	@Autowired
	private SqlSessionTemplate sqlSession;
	@Autowired
	public LocationService locationService;
	@Autowired
	private AdminService adminService;
	@Autowired
	private CookieDao dao;
	
	//자동로그인 생성
	@Transactional
	@Override
	public int autoLogin(HttpServletResponse response
			,Member loginUser) {
		//토큰 생성
		String token = UUID.randomUUID().toString();
		
		CookieToken cookieToken = new CookieToken(
				token,loginUser.getUserNo());
		
		//기존 토큰 삭제
		dao.deleteAutoLoginToken(sqlSession,cookieToken);
		
		//토큰 저장
		int result = dao.insertAutoLoginToken(sqlSession,cookieToken);
		
		//토큰에 토큰번호 더해서 온전한 토큰 만들기
		token = cookieToken.getUserNo() +"_"+ token;

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
	
	//자동로그인 발동
	@Override
	public int autoLogin(HttpSession session,
			HttpServletResponse response,CookieToken cookieToken) {
		Member loginUser = new Member();
		List<Coord> coords = new ArrayList<Coord>();
		int result = 1;
		
		//토큰 확인
		result *= dao.selectAutoLoginToken(sqlSession,cookieToken);
		
		if(result == 1) {
			//토큰 조회되었으면 로그인
			loginUser = dao.autoLogin(sqlSession, cookieToken.getUserNo());
			loginUser.setUserPwd("0");

			//위치정보 조회
			coords= locationService.selectUserDongne(loginUser.getUserNo());
			session.setAttribute("coords", coords);
			
			//관리자 권한조회
			if(!loginUser.getRoleType().equals("N")) {
				loginUser.setRoleType(adminService
						.selectRoleType(loginUser));
			}
			session.setAttribute("loginUser", loginUser);
			
			//기존 토큰 삭제하고 재발급
			autoLogin(response,loginUser);
			
			return 1;
		}else {
			return 0;
		}
	}
	
	//자동로그인 토큰 삭제
	@Override
	public void deleteAutoLogin(HttpServletResponse response,HttpSession session) {
		CookieToken cookieToken = new CookieToken();
		
		//달디달고 달디단 쿠키 지우기
		ResponseCookie cookie = ResponseCookie.from("autoLogin", "")
				.httpOnly(true)
				.secure(true)
				.path("/")
				.maxAge(0)
				.build();
		response.addHeader("Set-Cookie", cookie.toString());
		
		//cookie_token 삭제
		Member m = ((Member)session.getAttribute("loginUser"));
		if(m==null) return;
		int userNo = m.getUserNo();
		cookieToken.setUserNo(userNo);
		
		dao.deleteAutoLoginToken(sqlSession,cookieToken);
		
	}
}
