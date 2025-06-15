package com.gaonna.yami.common;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseCookie;
import org.springframework.web.servlet.HandlerInterceptor;

import com.gaonna.yami.cookie.service.CookieService;
import com.gaonna.yami.cookie.vo.CookieToken;

public class GlobalInterceptor implements HandlerInterceptor{
	@Autowired
	private CookieService cookieService;
	
	//자동 로그인
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		try {
			HttpSession session = request.getSession();
			//로그인이 되어 있다? 너 잘 걸렸다 심심했는데
			if (session == null ||
					session.getAttribute("loginUser") != null) {
	            return true;
	        }
			
			//달고달디단 쿠키 추출
			Cookie[] cookies = request.getCookies();
	        String autoLogin = null;
	        
	        if (cookies != null) {
	            for (Cookie cookie : cookies) {
	                if ("autoLogin".equals(cookie.getName())) {
	                	autoLogin = cookie.getValue();
	                    break;
	                }
	            }
	        }
	        
	        //쿠키 없으면 가세요라
	        if (autoLogin == null) {
	        	return true;
	        }
	        
	        //쿠키에서 토큰, 회원번호 추출
            String[] autoLoginTokenStr = autoLogin.split("_");
            int userNo = Integer.parseInt(autoLoginTokenStr[0]);
            String token = autoLoginTokenStr[1];
            CookieToken cookieToken = new CookieToken(token, userNo);
            
            //자동 로그인
            int result = cookieService.autoLogin(session, response, cookieToken);
            
            //서버에 해당 토큰 없음. 달디달고 달디단 쿠키 지우기
            if (result != 1) {
        		ResponseCookie cookie = ResponseCookie.from("autoLogin", "")
        		        .httpOnly(true)
        		        .secure(true)
        		        .path("/")
        		        .maxAge(0)
        		        .build();
        		response.addHeader("Set-Cookie", cookie.toString());
            	return true;
            }
			
			return HandlerInterceptor.super.preHandle(request, response, handler);
		}catch (Exception e) {
			return true;
		}
	}
}
