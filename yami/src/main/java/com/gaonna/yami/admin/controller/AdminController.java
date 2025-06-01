package com.gaonna.yami.admin.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.gaonna.yami.admin.service.AdminService;
import com.gaonna.yami.location.service.LocationService;
import com.gaonna.yami.location.vo.Coord;
import com.gaonna.yami.member.model.vo.Member;
import com.google.gson.Gson;

@Controller
public class AdminController {
	@Autowired
	private AdminService service;
	@Autowired
	public LocationService locationService;
	
	//콘솔창 명령
	@PostMapping("console")
	public String console(HttpServletRequest request
			,HttpSession session, String command) {
		
		String userId = "";
		HttpSession newSession;
		Member loginUser = null;
		List<Coord> coords = new ArrayList<Coord>();
		
		String commandType = "";//명령어 유형
	
		switch (command) {
		case "sad":
		case "ㄴㅁㅇ":
			userId="superAdmin@yami";
			commandType = "login";
			break;
		case "ad":
		case "ㅁㅇ":
			userId="admin@yami";
			commandType = "login";
			break;
		case "vw":
		case "ㅍㅈ":
			userId="viewer@yami";
			commandType = "login";
		default:
			userId=command;
			commandType = "login";
			break;
		}
		
		switch	(commandType){
		case "login" :
			newSession = request.getSession(true);
			loginUser = service.consoleLogin(userId);
			newSession.setAttribute("loginUser", loginUser);
			coords= locationService.selectUserDongne(loginUser.getUserNo());
			newSession.setAttribute("coords", coords);
			//관리자면 관리 권한 조회
			if(loginUser.getRoleType() != "N") {
				loginUser.setRoleType(service
						.selectRoleType(loginUser));
				//('superAdmin', 'admin', 'viewer')
			}
			break;
		}
		return "redirect:/";
	}
	
	//관리자 전용 운영실로 이동
	@GetMapping("adminPage.ad")
	public String adminPage() {
		return "admin/adminPage";
	}
	
	//관리자 조회 및 수정 페이지로 이동
	@GetMapping("updateAdmin.ad")
	public String updateAdmin() {
		return "admin/updateAdmin";
	}
	
	
	//ajax 관리자 조회
	@ResponseBody
	@PostMapping("searchAdmin.ad")
	public String searchAdmin(String select) {
		try {
			List<Member> admin = service.searchAdmin(select);
			String adminJson = new Gson().toJson(admin);
			return adminJson;
		} catch (Exception e) {
			e.printStackTrace();
			return "[]";
		}
	}
	
	
}
