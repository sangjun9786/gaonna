package com.gaonna.yami.common;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

import com.gaonna.yami.member.model.vo.Member;

public class DongneInterceptor implements HandlerInterceptor{
	//요청 처리 전 인터셉터
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		//request : 사용자 요청
		//response : 사용자에게 보낼 정보
		//handler : 요청 처리 주체
		
		//로그인이 되어 있지 않으면 넌 모찌나간다
		HttpSession session = request.getSession();
		
		Member loginUser =(Member)session.getAttribute("loginUser");
		if(loginUser == null) {
			System.out.println("인터셉터 발동 : 로그인 안 하면 가세요라");
			System.out.println(session.getAttribute("loginUser"));
			session.setAttribute("alertMsg", "로그인을 해 주세요.");
			response.sendRedirect(request.getContextPath());
			return false;
		}else if(loginUser.getMainCoord() == 0) {
			System.out.println("인터셉터 발동 : 대표동네 없네용 가세요라");
			session.setAttribute("alertMsg", "먼저 대표 우리동네를 추가해 주세요.");
			response.sendRedirect(request.getContextPath()+"/dongne.me");
			return false;
		}
		
		
		return HandlerInterceptor.super.preHandle(request, response, handler);
	}
}
