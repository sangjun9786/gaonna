package com.gaonna.yami.member.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.gaonna.yami.admin.service.AdminService;
import com.gaonna.yami.composite.service.CompositeService;
import com.gaonna.yami.cookie.service.CookieService;
import com.gaonna.yami.location.service.LocationService;
import com.gaonna.yami.location.vo.Coord;
import com.gaonna.yami.location.vo.Location;
import com.gaonna.yami.member.common.TokenGenerator;
import com.gaonna.yami.member.model.service.MemberService;
import com.gaonna.yami.member.model.vo.Member;
import com.gaonna.yami.rating.model.service.RatingService;
import com.gaonna.yami.report.model.service.ReportService;

@Controller
public class MemberController {
	@Autowired
	public MemberService service;
	@Autowired
	public TokenGenerator tokenGenerator;
	@Autowired
	public LocationService locationService;
	@Autowired
	public CookieService cookieService;
	@Autowired
	public AdminService adminService;
	@Autowired
	public RatingService ratingService;
	@Autowired
	public CompositeService compositeService;
	@Autowired
	private BCryptPasswordEncoder bcrypt;
	@Autowired
	private ReportService reportService;
	//메인 페이지 이동
	@RequestMapping("/main")
	public String home() {
		return "main";
	}
	
	//실험실 이동
	@GetMapping("lab")
	public String lab() {
		return "member/lab";
	}
	
	//회원가입 페이지 이동
	@GetMapping("insert.me")
	public String insertMember() {
		return "member/enrollForm";
	}
	
	//회원가입
	@Transactional
	@PostMapping("insert.me")
	public String insertMember(HttpSession session, Model model
			, Member m, String domain) {
		try {
			//---------유효성 검사---------//
			if(!(m.getUserId()+domain).matches("^[a-zA-Z0-9.]{1,30}$") ||
					!m.getUserPwd().matches("^[a-zA-Z0-9]{4,30}$") ||
					m.getUserName().isEmpty()
					) {
				return errorPage(model, "필수 항목을 확인해 주세요.");
			}

			if(m.getPhone().equals("--")) {
				//전화번호를 입력하지 않았을 경우 전화번호 비우기
				m.setPhone(null);
			}else if(!m.getPhone().matches("^\\d{3}-\\d{3,4}-\\d{4}$")) {
				return errorPage(model, "필수 항목을 확인해 주세요.");
			}
			
			//입력받은 아이디와 도메인을 이메일 형식으로 변경
			m.setUserId(m.getUserId()+"@"+domain);
			
			//아이디가 중복되는지 확인
			int checkId = service.checkUserId(m.getUserId());
			
			//분명 프론트에서 걸려져야 할 중복아이디를 들고오는 놈은 에러페이지로 가세요라
			if(checkId>0) {
				return errorPage(model,"잘못된 아이디입니다.");
			}
			
			//비밀번호 암호화
			m.setUserPwd(bcrypt.encode(m.getUserPwd()));
			
			//서비스로 보내고 겸사겸사 유저식별번호 따오기
			int result = service.insertMember(m);
			
			
			if(result>0) {
				//토큰 생성기로 보내기
				result = tokenGenerator.insertMemberToken(m);
				if(result>0) {
					session.setAttribute("alertMsg", "이메일을 확인해 주세요.");
					return "redirect:/";
				}else {
					return errorPage(model,"이메일 송신이 실패하였습니다.");
				}
				
			}else {
				return errorPage(model,"접근이 거부되었습니다.");
			}
			
		}catch(NullPointerException e) {
			e.printStackTrace();
			return errorPage(model,"작성하신 항목을 확인해 주세요.");
		}catch(Exception e) {
			e.printStackTrace();
			return errorPage(model,"회원가입에 실패하였습니다.");
		}
	}
	
	//ajax 아이디 중복확인
	@ResponseBody
	@RequestMapping("checkUserId.me")
	public String checkUserId(Model model, String userId, String domain) {
		try {
			//온전한 이메일 형식으로 바꿔
			String id= userId+"@"+domain;
			
			int result = service.checkUserId(id);
			
			if(result>0) {
				return "noPass";
			}else {
				return "pass";
			}
			
		}catch(Exception e){
			e.printStackTrace();
			return "err";
		}
	}
	
	//ajax 비밀번호 확인
	@ResponseBody
	@RequestMapping("checkUserPwd.me")
	public String checkUserId(HttpSession session, Model model, String inputPwd) {
		try {
			Member m = (Member)session.getAttribute("loginUser");
			
			String pwd = service.selectUserPwd(m.getUserNo());
			
			if(bcrypt.matches(inputPwd,pwd)) {
				return "pass";
			}else {
				return "noPass";
			}
			
		}catch(Exception e){
			e.printStackTrace();
			return "err";
		}
	}
	
	//로그인 페이지로 이동
	@GetMapping("login.me")
	public String loginMember() {
		return "member/login";
	}
	
	//로그인
	@PostMapping("login.me")
	public String loginMember(HttpServletRequest request
			, HttpServletResponse response, Model model
			, String userId, String domain, String userPwd
			, String autoLogin) {
		try {
			//세션 초기화
			HttpSession oldSession = request.getSession(false);
		    if (oldSession != null) {
		        oldSession.invalidate();
		    }
		    
		    //새로운 세션 생성
		    HttpSession session = request.getSession(true);
		    
			Member loginUser = service.loginMember(userId, domain, userPwd);
			if(loginUser != null) {
				
			    int reportCount = reportService.countHandledReportsByUser(loginUser.getUserNo());
			    if (reportCount >= 5) {
			        model.addAttribute("errorMsg", "이용이 제한된 회원입니다.");
			        return "common/errorPage";
			    }
			    
				switch(loginUser.getStatus()) {
				//유저 꼬라지에 따라 작동
				
				case "U" : //이메일 인증을 완료하지 않았을 경우
					Member resendEmailUser = loginUser;
					session.setAttribute("resendEmailUser",resendEmailUser);
					return "member/resendEmailMe";
				case "N" : //정지된 회원일 경우
					session.setAttribute("alertMsg","이용이 제한된 회원입니다.");
					return "redirect:/";
				case "E" : //탈퇴된 회원일 경우
					session.setAttribute("alertMsg","탈퇴된 회원입니다.");
					return "redirect:/";
				}
				
				//비밀번호 지우기
				loginUser.setUserPwd("0");
				
				//로그인 성공
				session.setAttribute("loginUser",loginUser);
				
				//우리동네 조회
				List<Coord> coords = locationService.selectUserDongne(loginUser.getUserNo());
				session.setAttribute("coords", coords);
				
				//관리자면 관리 권한 조회
				if(!loginUser.getRoleType().equals("N")) {
					loginUser.setRoleType(adminService
							.selectRoleType(loginUser));
					//('superAdmin', 'admin', 'viewer')
				}
				
			    if(autoLogin != null && autoLogin.equals("Y")) {
			    	//자동로그인 켜져 있으면 쿠키에 저장
			    	cookieService.autoLogin(response, loginUser);
			    }else {
			    	//자동 로그인 가세요 있으면 쿠키삭제 및 토큰삭제
			    	cookieService.deleteAutoLogin(response, session);
			    }
				
				return "redirect:" + response.encodeRedirectURL("/");
				
			}else{
				//해당 유저 없음
				session.setAttribute("alertMsg", "아이디와 비밀번호를 확인해 주세요.");
				return "member/login";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return errorPage(model,"로그인에 실패하였습니다.");
			
			
		}
	}
	
	//로그아웃
	@GetMapping("logout.me")
	public String logout(HttpServletResponse response,
			HttpSession session ,Model model) {
		try {
			//자동로그인 쿠키 지우기
			cookieService.deleteAutoLogin(response,session);
			
			session.invalidate();//세션 전체 초기화
			
			
			return "redirect:/";
		} catch (Exception e) {
			e.printStackTrace();
			return errorPage(model,"500 err");
		}
	}
	
	//마이페이지
	@GetMapping("mypage.me")
	public String myPage(HttpSession session ,Model model) {
		try {
			return "member/myPage";
		} catch (Exception e) {
			e.printStackTrace();
			return errorPage(model,"500 err");
		}
	}
	@GetMapping("update.me")
	public String updateMember(HttpSession session, Model model, String inputPwd) {
		try {
			return "member/update";
		} catch (Exception e) {
			e.printStackTrace();
			return errorPage(model,"500 err");
		}
	}
	
	//마이페이지 - 비밀번호 변경
	@PostMapping("updatePwd.me")
	public String updatePwd(HttpSession session, Model model,
			String newPwd) {
		try {
			Member m = (Member)session.getAttribute("loginUser");
			
			if(!newPwd.matches("^[a-zA-Z0-9]{4,30}$")) {
				//유효성 확인
				return errorPage(model, "비밀번호를 확인해주세요.");
				
			}
			
			//비밀번호 암호화
			m.setUserPwd(bcrypt.encode(newPwd));
			
			if(service.updatePwd(m)>0) {
				//수정 성공하면 로그인 세션 지우기
				session.invalidate();
				return "redirect:/";
			}else {
				return errorPage(model,"500 err");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			return errorPage(model,"500 err");
		}
	}
	
	//마이페이지 - 이름 변경
	@PostMapping("updateName.me")
	public String updateName(HttpSession session, Model model, String userName) {
		try {
			if(userName.length()>10) {
				return errorPage(model,"이름이 너무 기네용");
			}
			
			Member m = (Member)session.getAttribute("loginUser");
			m.setUserName(userName);
			
			if(service.updateName(m)==0) {
				//db저장이 안 될 경우
				return errorPage(model,"500 err");
			}
			
			//변경했으면 로그인유저 정보 업데이트
			session.setAttribute("loginUser",m);
			return "redirect:/mypage.me";
			
		} catch (Exception e) {
			e.printStackTrace();
			return errorPage(model,"500 err");
		}
	}
	
	//마이페이지 - 전화번호 변경
	@GetMapping("updatePhone.me")
	public String updatePhone(HttpSession session, Model model, String phone) {
		try {
			String phonePattern = "^\\d{3}-\\d{3,4}-\\d{4}$";
			if (!phone.matches(phonePattern)) {
			    return errorPage(model, "전화번호 형식이 올바르지 않습니다.");
			}
			
			Member m = (Member)session.getAttribute("loginUser");
			m.setPhone(phone);
			
			if(service.updatePhone(m)==0) {
				//db저장이 안 될 경우
				return errorPage(model,"500 err");
			}
			//변경했으면 로그인유저 정보 업데이트
			session.setAttribute("loginUser",m);
			return "redirect:/mypage.me";
			
		} catch (Exception e) {
			e.printStackTrace();
			return errorPage(model,"500 err");
		}
	}
	
	//우리동네 설정페이지로
	@GetMapping("dongne.me")
	public String myDongne(HttpSession session, Model model){
		try {
			return "member/dongne";
		} catch (Exception e) {
			e.printStackTrace();
			return errorPage(model,"500 err");
		}
	}
	
	
	
	//ajax로 우리동네 중복확인
	@ResponseBody
	@GetMapping("checkDongne.me")
	public String checkDongne(HttpSession session, Model model,
		String latitude, String longitude) {
		try {
			List<Coord> coords = (List)session.getAttribute("coords");
			
			//해당 위도, 경도에 해당하는 위치 추출
			Coord currCoord = new Coord();
			currCoord.setLongitude(longitude);
			currCoord.setLatitude(latitude);
			currCoord.setCoordAddress(locationService
					.reverseGeocode(currCoord));
			
			//위치가 이미 존재하면 가세요라
			for(Coord i : coords) {
				//위치 판별은 coordAddress기준
				if((i.getCoordAddress().replaceAll("\\s+", ""))
						.equals(currCoord.getCoordAddress().replaceAll("\\s+", ""))) {
					return "noPass";
				}
			}
			
			//중복 안 되면 session에 currCoord넣고 통과
			session.setAttribute("currCoord",currCoord);
			return "pass";
			
		} catch (Exception e) {
			e.printStackTrace();
			return "err";
		}
	}
	
	
	//우리동네 추가하기
	@GetMapping("insertDongne.me")
	public String insertDongne(HttpSession session, Model model,String isMain) {
		try {
			//세션에 넣어둔 currCoord를 이용할거에요
			int result = service.insertDongne(session, isMain);
			if(result==0) {
				throw new Exception();
			}
			
			//세션 청소
			session.removeAttribute("currCoord");
			
			return "member/dongne";
		} catch (Exception e) {
			e.printStackTrace();
			return errorPage(model,"500 err");
		}
	}
	
	//우리동네 삭제
	@PostMapping("deleteCoord.me")
	public String deleteCoord(HttpSession session, Model model, 
			int coordNo) {
		
		try {
			int result = service.deleteCoord(session, coordNo);
			
			if(result==0) {
				throw new Exception();
			}
			
			//coord의 session반영
			Member loginUser = (Member)session.getAttribute("loginUser");
			List<Coord> coords = locationService.selectUserDongne(loginUser.getUserNo());
			session.setAttribute("coords", coords);
			
			return "member/dongne";
		} catch (Exception e) {
			e.printStackTrace();
			return errorPage(model,"500 err");
		}
	}
	
	//대표동네 설정하기
	@PostMapping("updateMainCoord.me")
	public String updateMainCoord(HttpSession session, Model model, int coordNo) {
		try {
			Member m = (Member)session.getAttribute("loginUser");
			
			if(service.updateMainCoord(m,coordNo)>0) {
				//session업데이트
				session.setAttribute("loginUsert", m);
				
				return "member/dongne";
			}
			
			return errorPage(model,"500 err");
		} catch (Exception e) {
			e.printStackTrace();
			return errorPage(model,"500 err");
		}
	}
	
	
	
	//배송지 페이지로
	@GetMapping("deliveryAddress.me")
	public String myDeliveryAddress(HttpSession session, Model model){
		try {
			//해당 유저의 주소록 불러오기
			Member m = (Member)session.getAttribute("loginUser");
			
			List<Location> locations= locationService.selectLocation(m);
			session.setAttribute("location", locations);
			
			return "member/deliveryAddress";
		} catch (Exception e) {
			e.printStackTrace();
			return errorPage(model,"500 err");
		}
	}
	
	//배송지 추가하기 페이지로
	@GetMapping("insertLocationForm.me")
	public String insertLocation(Model model, String isMain){
		try {
			return "member/insertDeliveryAddress";
		} catch (Exception e) {
			e.printStackTrace();
			return errorPage(model,"500 err");
		}
	}
	
	//배송지 삭제
	@PostMapping("deleteLocation.me")
	public String deleteLocation(HttpSession session, Model model, int locationNo) {
		try {
			Member m = (Member)session.getAttribute("loginUser");
			
			if(locationService.deleteUserLocation(session,m,locationNo)>0) {
				//세션 업데이트
				List<Location> locations= locationService.selectLocation(m);
				session.setAttribute("location", locations);
				return "member/deliveryAddress";
			}
			
			return errorPage(model, "배송지를 삭제할 수 없습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			return errorPage(model,"500 err");
		}
	}
	
	//대표 배송지 변경
	@PostMapping("updateMainlocation.me")
	public String updateMainlocation(HttpSession session
			,Model model, int locationNo) {
		try {
			Member m = (Member)session.getAttribute("loginUser");
			
			//이미 대표 배송지면 가세요라
			if(m.getMainLocation() == locationNo) {
				return errorPage(model,"이미 대표 배송지입니다.");
			}
			
			//m에 대표 배송지 넣어두기
			m.setMainLocation(locationNo);
			
			switch (locationService.updateMainlocation(m)){
			case 0 :
				return errorPage(model,"대표배송지 변경에 실패했습니다.");
			case 1 :
				session.setAttribute("loginUser", m);//session업데이트
				return "member/deliveryAddress";
			default :
				return errorPage(model,"500 err");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			return errorPage(model,"500 err");
		}
	}
	
	
	//비밀번호 찾기 페이지로 이동
	@GetMapping("findPwd.me")
	public String GoFindPwd(){
		return "member/findPwd";
	}
	
	//비밀번호 찾기
	@PostMapping("findPwd.me")
	public String findPwd(HttpSession session, Model model
			, String userId, String domain){
		try {
			//입력받은 아이디와 도메인을 이메일 형식으로 변경
			userId = userId+"@"+domain;
			
			//아이디가 존재하는지 확인
			int checkId = service.checkUserId(userId);
			
			//분명 프론트에서 걸려져야 할 없는아이디를 들고오는 놈은 에러페이지로 가세요라
			if(checkId==0) {
				return errorPage(model,"잘못된 아이디입니다.");
			}
			
			Member m = new Member();
			m.setUserId(userId);
			m.setUserNo(service.selectUserNo(m));
			
			//토큰 생성기로 보내기
			int result = tokenGenerator.findPwdToken(m);
			if(result>0) {
				session.setAttribute("alertMsg", "이메일을 확인해 주세요.");
				return "redirect:/";
			}else {
				return errorPage(model,"이메일 송신이 실패하였습니다.");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			return errorPage(model,"500 err");
		}
	}
	
	//마이페이지 평점 조회
	@PostMapping("selectRatingScore.me")
	@ResponseBody
	public String selectRatingScore(HttpSession session) {
		try {
			Member m = (Member)session.getAttribute("loginUser");
			return ""+ratingService.selectRatingScore(m);
		} catch (Exception e) {
			e.printStackTrace();
			return "-1"; // 조회 불가
		}
	}
	
	//회원탈퇴 페이지로
	@GetMapping("deleteUser.me")
	public String goDeleteUser() {
		return "member/deleteUser";
	}
	
	
	//ajax - 아이디/비밀번호 확인
	@PostMapping("confirmIdPwd.me")
	@ResponseBody
	public String confirmIdPwd(HttpSession session
			,String userId, String userPwd) {
		try {
			Member m = (Member)session.getAttribute("loginUser");
			
			if(service.confirmIdPwd(m,userId,userPwd)>0){
				return "pass";
			}else {
				return "noPass";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "noPass";
		}
	}
	
	//회원 탈퇴
	@PostMapping("deleteUser.me")
	public String deleteUser(HttpSession session,
			HttpServletRequest request
			,HttpServletResponse response, Model model
			,String userId, String userPwd) {
		try {
			int result=0;
			Member m = (Member)session.getAttribute("loginUser");
			
			//한번 더 유효성 확인
			if(service.confirmIdPwd(m,userId,userPwd)>0) {
				result = service.deleteUser(m);
			}else {
				return errorPage(model,"아이디와 비밀번호를 확인해 주세요.");
			}
			
			if(result>0) {
				//로그아웃 처리
				cookieService.deleteAutoLogin(response,session);
				session.invalidate();
				
				//새로운 세션 생성
			    HttpSession newSession = request.getSession(true);
			    newSession.setAttribute("alertMsg","탈퇴가 완료되었습니다.");
				return "redirect:/";
			}else {
				return errorPage(model,"500 err");
			}
		} catch (Exception e) {
			e.printStackTrace();
			return errorPage(model,"500 err");
		}
	}

	
	//유저 식별번호로 유저 아이디 조회
	public String selectUserId(int userNo) {
		try {
			return service.selectUserId(userNo);
		}catch(Exception e){
			e.printStackTrace();
			return null;
		}
	}
	
	//오류창
	private String errorPage(Model model, String errMsg) {
		model.addAttribute("errorMsg",errMsg);
		return "common/errorPage";
	}
}
