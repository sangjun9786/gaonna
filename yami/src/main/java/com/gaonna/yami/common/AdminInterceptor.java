package com.gaonna.yami.common;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

import com.gaonna.yami.member.model.vo.Member;

public class AdminInterceptor implements HandlerInterceptor{
	
	//요청 처리 전 인터셉터
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		//관리자가 아니면 넌 모찌나간다
		HttpSession session = request.getSession();
		Member loginUser = (Member)session.getAttribute("loginUser");
		if(loginUser == null ||
				loginUser.getRoleType() == null ||
				loginUser.getRoleType().equals("N")) {
			session.setAttribute("alertMsg", "접근 권한이 없습니다.");
			response.sendRedirect(request.getContextPath());
			return false;
		}
		return HandlerInterceptor.super.preHandle(request, response, handler);
	}
}
