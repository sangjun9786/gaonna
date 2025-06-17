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
	
	@RequestMapping("event.ev")
	public String event(HttpSession session) {
		return "event/eventPage";
	}
	
	@RequestMapping("info.ev")
	public String eventInfo(HttpSession session, Model model) {
		Member loginUser = (Member)session.getAttribute("loginUser");
		
		Event event = service.eventInfo(loginUser);
		
		if(event != null) {
			session.setAttribute("event", event);
			return "redirect:/event.ev";
		}else {
			session.setAttribute("alertMsg", "이벤트 테이블 조회 실패");
			return "event/eventPage";
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
			int ecount = e.getCount();
			//ecount % 10, ecount % 5 구분해서 포인트 지급
			//ecount 30이면 1000포인트 지급 후 count초기화
			if(ecount == 30) {
				int resultReset = resetCount(e);
				if(resultReset > 0) {
					int resultP = point1000(loginUser);
					if(resultP > 0) {
						session.setAttribute("alertMsg", "출석 완료!!! 및 1000포인트 지급");
					}else {
						model.addAttribute("errorMsg", "포인트 지급 실패!!!");
						return "common/errorPage";
					}
				}else {
					model.addAttribute("errorMsg", "출석일 수 초기화 실패!!!");
					return "common/errorPage";
				}
			}else if(ecount % 10 == 0) {
				int resultP = point1000(loginUser);
				if(resultP > 0) {
					session.setAttribute("alertMsg", "출석 완료!!! 및 1000포인트 지급");
				}else {
					model.addAttribute("errorMsg", "포인트 지급 실패!!!");
					return "common/errorPage";
				}
			}else if(ecount % 5 == 0) {
				int resultP = point500(loginUser);
				if(resultP > 0) {
					session.setAttribute("alertMsg", "출석 완료!!! 및 500포인트 지급");
				}else {
					model.addAttribute("errorMsg", "포인트 지급 실패!!!");
					return "common/errorPage";
				}
			}
			return "redirect:/event.ev";
		}else {
			model.addAttribute("errorMsg", "출석은 하루에 한 번만 하실 수 있습니다.");
			return "common/errorPage";
		}
	}
	
	public int resetCount(Event e) {
		return service.resetCount(e);
	}
	
	public int point1000(Member loginUser) {
		return service.point1000(loginUser);
	}
	public int point500(Member loginUser) {
		return service.point500(loginUser);
	}
	
	@RequestMapping("doTest.me")
	public String doTest() {
		return "event/perchasedBoard";
	}
	
}
