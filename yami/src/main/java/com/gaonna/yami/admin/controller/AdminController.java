package com.gaonna.yami.admin.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.gaonna.yami.admin.service.AdminService;
import com.gaonna.yami.composite.vo.SearchForm;
import com.gaonna.yami.location.service.LocationService;
import com.gaonna.yami.member.model.service.MemberService;
import com.gaonna.yami.location.vo.Coord;
import com.gaonna.yami.location.vo.Location;
import com.gaonna.yami.member.model.vo.Member;
import com.google.gson.Gson;

@Controller
public class AdminController {
	@Autowired
	private AdminService service;
	@Autowired
	public LocationService locationService;
	@Autowired
	public MemberService memberService;
	
	//콘솔창 명령!
	@PostMapping("console")
	public String console(HttpServletRequest request
			, HttpServletResponse response, String command) {
		try {
			String userId = "";
			Member loginUser = new Member();
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
				break;
				
				
			case "t1":
			case "ㅅ1":
				userId="hugme@hugme.please";
				commandType = "login";
				break;
			case "t2":
			case "ㅅ2":
				userId="aeaeaeng@hugme.please";
				commandType = "login";
				break;
			case "t3":
			case "ㅅ3":
				userId="novita@hugme.please";
				commandType = "login";
				break;
			case "t4":
			case "ㅅ4":
				userId="station@yamm";
				commandType = "login";
				break;
			case "t5":
			case "ㅅ5":
				userId="sell@yamm";
				commandType = "login";
				break;
				
				
			default:
				userId=command;
				commandType = "login";
				break;
			}
			
			switch	(commandType){
			case "login" :
				HttpSession oldSession = request.getSession(false);
			    if (oldSession != null) {
			        oldSession.invalidate();
			    }
			    
				HttpSession newSession = request.getSession(true);
				loginUser = service.consoleLogin(userId);
				loginUser.setUserPwd("0");
				newSession.setAttribute("loginUser", loginUser);
				coords= locationService.selectUserDongne(loginUser.getUserNo());
				newSession.setAttribute("coords", coords);
				//관리자면 관리 권한 조회
				if(!loginUser.getRoleType().equals("N")) {
					loginUser.setRoleType(service
							.selectRoleType(loginUser));
					//('superAdmin', 'admin', 'viewer')
				}
				return "redirect:" + response.encodeRedirectURL("/");
			}
			return "redirect:/";
			
		} catch (Exception e) {
			e.printStackTrace();
			return "redirect:/";
		}
	}
	
	//관리자 전용 운영실로 이동
	@GetMapping("adminPage.ad")
	public String goAadminPage() {
		return "admin/adminPage";
	}
	
	//관리자 조회 및 수정 페이지로 이동
	@GetMapping("updateAdmin.ad")
	public String goUpdateAdmin(HttpSession session) {
		Member loginUser= (Member)session.getAttribute("loginUser");
		if(!loginUser.getRoleType().equals("superAdmin")) {
			//최고 관리자 권한 확인
			return "redirect:/";
		}
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
	
	//관리자 수정
	@ResponseBody
	@PostMapping("updateAdmin.ad")
	public String updateAdmin(HttpSession session, Member m) {
		try {
			Member loginUser= (Member)session.getAttribute("loginUser");
			
			if(!loginUser.getRoleType().equals("superAdmin")) {
				//최고 관리자 권한 확인
				return "noRole";
				
			}else if(m.getUserNo() == 0
					&& !m.getRoleType().equals("superAdmin")) {
				//0번 권한을 수정하면 오류
				return "superAdmin";
			}
			
			int result =  service.updateAdmin(m);
			
			if(result==0) {
				return "noPass";
			}
			
			return "pass";
		} catch (Exception e) {
			e.printStackTrace();
			return "noPass";
		}
	}
	
	//관리자 추가 페이지로
	@GetMapping("insertAdmin.ad")
	public String goInsertAdmin(HttpSession session,Model model, Member m) {
		Member loginUser= (Member)session.getAttribute("loginUser");
		if(!loginUser.getRoleType().equals("superAdmin")) {
			//최고 관리자 권한 확인
			return "redirect:/";
		}
		return "admin/insertAdmin";
	}
	
	//관리자 추가하기
	@PostMapping("insertAdmin.ad")
	public String insertAdmin(HttpSession session,Model model, Member m) {
		Member loginUser= (Member)session.getAttribute("loginUser");
		if(!loginUser.getRoleType().equals("superAdmin")) {
			//최고 관리자 권한 확인
			return "redirect:/";
		}
		
		if(memberService.checkUserId(m.getUserId())>0) {
			//아이디 췤
			session.setAttribute("alertMsg", "이미 존재하는 아이디입니다.");
			return "redirect:/insertAdmin.ad";
			
		}else if(service.insertAdmin(m) ==0) {
			//db에 추가하기 실패
			return "common/errorPage";
		}
		
		return "redirect:/adminPage.ad";
	}
	
	//회원 조회/수정 페이지로
	@GetMapping("updateUser.ad")
	public String goUpdateUser() {
		return "admin/updateUser";
	}
	
	
	//ajax 회원 조회
	@ResponseBody
	@GetMapping("searchMember.ad")
	public String searchMember(String searchType
			,String searchKeyword, int searchCount, int page) {
		try {
			List<Member> result = service.searchMember(searchType
					,searchKeyword, searchCount, page);
			String json = new Gson().toJson(result);
			
			return json;
			
		} catch (Exception e) {
			e.printStackTrace();
			return "[]";
		}
	}
	
	//ajax 회원 수 세기
	@ResponseBody
	@GetMapping("countMember.ad")
	public String countMember(String searchType ,String searchKeyword) {
		try {
			return service.countMember(searchType, searchKeyword);
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	
	//ajax 회원 정보 수정
	@ResponseBody
	@PostMapping("updateUser.ad")
	public String updateUser(HttpSession session
			,@RequestBody String json) {
		Member loginUser= (Member)session.getAttribute("loginUser");
		if(!loginUser.getRoleType().equals("superAdmin")
				&& !loginUser.getRoleType().equals("admin")) {
			//권한 확인
			return "noPass";
		}
		
		Member m = new Gson().fromJson(json, Member.class);
		
		if(service.updateUser(m)>0) {
			return "pass";
		}else {
			return "noPass";
		}
		
	}
	
	//ajax 회원 동네 조회
	@ResponseBody
	@GetMapping("userDongne.ad")
	public List<Coord> userDongne(String userNo) {
		try {
			int userNoToInt = Integer.parseInt(userNo);
			List<Coord> coords = service.userDongne(userNoToInt);
			return coords;
			
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	//ajax 회원 배송지 조회
	@ResponseBody
	@GetMapping("userLocation.ad")
	public List<Location> userLocation(String userNo) {
		try {
			int userNoToInt = Integer.parseInt(userNo);
			List<Location> Location = service.userLocation(userNoToInt);
			return Location;
			
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	
	//게시글 조회/수정 페이지로
	@GetMapping("updateBoard.ad")
	public String goUpdateBoard() {
		return "admin/updateBoard";
	}
	
	//ajax 게시글 조회
	@ResponseBody
	@GetMapping("searchBoard.ad")
	public Map<String, Object> searchBoard(SearchForm searchForm) {
		try {
			return service.searchBoard(searchForm);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	//댓글 조회/수정 페이지로
	@GetMapping("updateReply.ad")
	public String goUpdateReply() {
		return "admin/updateReply";
	}
	
	//ajax - 판매게시판 댓글 조회
	@ResponseBody
	@PostMapping("searchReply.ad")
	public Map<String, Object> searchMyReply(HttpSession session,Model model
			,SearchForm searchForm) {
		try {
			Map<String, Object> result = service.searchReply(searchForm);
			return result;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	//ajax - 우리동네빵집 댓글 조회
	@ResponseBody
	@PostMapping("searchReplyDongne.ad")
	public Map<String, Object> searchMyReplyDongne(HttpSession session,Model model
			,SearchForm searchForm) {
		try {
			Map<String, Object> result = service.searchReplyDongne(searchForm);
			return result;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
}
