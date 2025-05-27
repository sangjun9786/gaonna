package com.gaonna.yami.member.controller;

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

import com.gaonna.yami.member.common.TokenGenerator;
import com.gaonna.yami.member.model.service.MemberService;
import com.gaonna.yami.member.model.vo.Member;

@Controller
public class MemberController {
	@Autowired
	public MemberService service;
	@Autowired
	public TokenGenerator tokenGenerator;
	
	@Autowired
	private BCryptPasswordEncoder bcrypt;
	
	//회원가입 페이지 이동
	@GetMapping("insert.me")
	public String insertMember() {
		return "member/MemberEnrollForm";
	}

	
	//회원가입
	@Transactional
	@PostMapping("insert.me")
	public String insertMember(HttpSession session, Model model
			, Member m, String domain) {
		try {
			//---------유효성 검사---------//
			if(!m.getUserId().matches("^[a-zA-Z0-9]{1,30}$") ||
					!m.getUserPwd().matches("^[a-zA-Z0-9]{4,30}$") ||
					m.getUserName().isEmpty()
					) {
				return errorPage(model, "필수 항목을 확인해 주세요.");
			}
			//입력받은 아이디와 도메인을 이메일 형식으로 변경
			m.setUserId(m.getUserId()+"@"+domain);
			
			//아이디가 중복되는지 확인
			int checkId = service.checkUserId(m.getUserId());
			
			//분명 프론트에서 걸려져야 할 중복아이디를 들고오는 놈에겐 에러페이지
			if(checkId>0) {
				return errorPage(model,"잘못된 아이디입니다.");
			}
			
			//암호화
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
	
	//로그인 페이지로 이동
	@GetMapping("login.me")
	public String loginMember() {
		return "member/loginMember";
	}
	
	//로그인
	@PostMapping("login.me")
	public String loginMember(HttpSession session, Model model
			, String userId, String domain, String userPwd) {
		try {
			Member loginUser = service.loginMember(userId, domain, userPwd);
			
			if(loginUser != null) {
				session.setAttribute("loginUser",loginUser);
				return "redirect:/";
			}else {
				session.setAttribute("alertMsg", "아이디와 비밀번호를 확인해 주세요.");
				return "member/loginMember";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return errorPage(model,"로그인에 실패하였습니다.");
		}
	}
	
	//마이페이지
	@GetMapping("mypage.me")
	public String myPage(HttpSession session, Model model) {
		try {
			return "member/myPage";
		} catch (Exception e) {
			e.printStackTrace();
			return errorPage(model,"500 err");
		}
	}
	
	
	
	//유저 식별번호로 유저 아이디 조회
	public String selectUserId(int userNo) {
		try {
			String userId = service.selectUserId(userNo);
			return userId;
			
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
