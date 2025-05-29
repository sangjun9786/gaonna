package com.gaonna.yami.event.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.gaonna.yami.event.model.service.EventService;
import com.gaonna.yami.event.model.vo.Event;
import com.gaonna.yami.member.model.vo.Member;

@Controller
public class EventController {
	@Autowired
	private EventService service;
	
	@RequestMapping("info.ev")
	public String eventInfo(HttpSession session) {
		Member loginUser = (Member)session.getAttribute("loginUser");
		
		Event event = service.eventInfo(loginUser);
		
		if(event != null) {
			session.setAttribute("event", event);
			return "redirect:/";
		}else {
			session.setAttribute("alertMsg", "이벤트 테이블 조회 실패");
			return "redirect:/";
		}
		
	}
	
	@RequestMapping("attendance.me")
	public String attendance(HttpSession session, Model model) {
		Event e = (Event)session.getAttribute("event");
		Member loginUser = (Member)session.getAttribute("loginUser");
		
		int result = service.attendance(e);
		
		if(result > 0) {
			e = service.eventInfo(loginUser);
			session.setAttribute("event", e);
			session.setAttribute("alertMsg", "출석 완료!!!");
			return "redirect:/";
		}else {
			model.addAttribute("errorMsg", "출석은 하루에 한 번만 하실 수 있습니다.");
			return "common/errorPage";
		}
	}
	
}
