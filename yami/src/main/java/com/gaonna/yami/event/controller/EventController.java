package com.gaonna.yami.event.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.gaonna.yami.event.model.service.EventService;
import com.gaonna.yami.event.model.vo.Event;
import com.gaonna.yami.member.model.vo.Member;

@Controller
public class EventController {
	@Autowired
	private EventService service;
	
	@RequestMapping("info.ev")
	public String eventInfo(Member loginUser, HttpSession session) {
		
		Event event = service.eventInfo(loginUser);
		
		if(event != null) {
			session.setAttribute("event", event);
			return "redirect:/";
		}else {
			session.setAttribute("errorMsg", "이벤트 테이블 조회 실패");
			return "redirect:/";
		}
		
	}
	
}
