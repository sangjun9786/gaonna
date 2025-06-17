package com.gaonna.yami.member.email.controller;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.gaonna.yami.cookie.service.CookieService;
import com.gaonna.yami.member.common.TokenGenerator;
import com.gaonna.yami.member.email.service.EmailService;
import com.gaonna.yami.member.email.vo.Email;
import com.gaonna.yami.member.email.vo.MemberToken;
import com.gaonna.yami.member.model.service.MemberService;
import com.gaonna.yami.member.model.vo.Member;

@Controller
public class EmailController {
    @Autowired
    private EmailService service;
	@Autowired
	public TokenGenerator tokenGenerator;
	@Autowired
	public CookieService cookieService;
	@Autowired
	public MemberService memberService;
	@Autowired
	private BCryptPasswordEncoder bcrypt;

    //이메일 보내보기
    @RequestMapping(value="sendEmail", method=RequestMethod.POST)
    public String sendEmail(Email email, HttpSession session, Model model) {
    	
    	if(email==null) {
    		model.addAttribute("alertMsg", "제출한 서식에 접근할 수 없습니다.");
    		return "common/errorPage";
    	}else if(email.getToAddress()== null || email.getToAddress().isEmpty()) {
    		session.setAttribute("alertMsg", "이메일 주소를 확인해 주세요.");
    		return "redirect:/";
    	}
    	
    	try {
    		service.sendEmail(email);
    		session.setAttribute("alertMsg", "메일이 송신되었습니다");
    		return "redirect:/";
    	}catch(Exception e) {
    		e.printStackTrace();
    		session.setAttribute("alertMsg", "제출 실패.");
    		return "redirect:/";
    	}
    }
    
    /*
     * 회원가입 이메일 링크 예시 : 
     * http://localhost:8888/yami/confirmEmailInsert.me?tokenNo=1&
     * token=dSNLdXM9Wk9fRW4jVjg2PWRWKHp6c3lidEEsJEdXWzQ
     */
    //이메일 링크 클릭해서 인증할때
    @RequestMapping(value="confirmEmailInsert.me", method=RequestMethod.GET)
    public String confirmEmailInsert(int tokenNo, String token, Model model, HttpSession session) {
    	try {
	    	MemberToken mt = new MemberToken();
	    	mt.setTokenNo(tokenNo);
	    	mt.setToken(token);
	    	
	    	//받은 토큰 비활성화하기
	    	int result = service.confirmEmailInsert(mt);
	    	
	    	if(result>0) {
	    		//토큰 번호로 유저 찾아내 계정 활성화
	    		result= memberService.confirmEmailInsert(tokenNo);
	    		
	    		if(result>0) {
	    			//인증 성공!
	    			session.setAttribute("alertMsg", "이메일 인증이 완료되었습니다.");
	    			return "redirect:/";
	    			
	    		}else {
	    			//뭔가 이상하다 싶으면 오류
	    			throw new NullPointerException();
	    		}
	    	}else {
	    		//토큰 조회가 안 되면 만료된 링크
	    		
	    		//해당 토큰의 소유주를 조회한다.
	    		Member resendEmailUser = service.resendEmail(mt);
	    		
	    		//조회 결과가 없으면 오류창
	    		if(resendEmailUser == null) {
	        		throw new NullPointerException();
	    		}
	    		
	    		session.setAttribute("resendEmailUser", resendEmailUser);
	    		return "member/resendEmailMe";
	    	}
    	} catch (Exception e) {
    		e.printStackTrace();
    		model.addAttribute("errorMsg","500err");
    		return "common/errorPage";
    	}
    }
    
    
    //회원가입 - 토큰 만료 후 이메일 재발송
    @RequestMapping("resendEmail")
    public String resendEmail(HttpSession session, Model model) {
    	try {
			Member m = (Member)session.getAttribute("resendEmailUser");
			tokenGenerator.insertMemberToken(m);
			
			//세션 지우기
			session.removeAttribute("resendEmailUser");
			
			session.setAttribute("alertMsg", "이메일을 확인해 주세요.");
			return "redirect:/";
		} catch (Exception e) {
			e.printStackTrace();
    		model.addAttribute("errorMsg","500err");
    		return "common/errorPage";
		}
    }
    
    //회원가입 - 이메일 변경
    @GetMapping("updateEmail")
    public String updateEmail(HttpSession session, Model model, String userId, String domain) {
    	try {
    		Member m = (Member)session.getAttribute("resendEmailUser");
    		
    		//세션 지우기
    		session.removeAttribute("resendEmailUser");
    		
    		//유효성 검사
			if(m == null || !(userId+domain).matches("^[a-zA-Z0-9.]{1,30}$")) {
				throw new NullPointerException();
			}
			
			//입력받은 아이디와 도메인을 이메일 형식으로 변경
			m.setUserId(userId+"@"+domain);
			
			//아이디가 중복되는지 확인
			int result = memberService.checkUserId(m.getUserId());
			
			if(result>0) {
				//중복되면 내다버리기
	    		model.addAttribute("errorMsg","잘못된 아이디입니다.");
	    		return "common/errorPage";
	    		
			}else {
				//중복 안 되면 아이디 업데이트
				result = memberService.updateId(m);
				
				
				if(result == 0) {
					//업데이트 안 되면 내다버리기
		    		model.addAttribute("errorMsg","500 err");
		    		return "common/errorPage";
				}
			}
			
			
			//토큰 생성기로 보내기
			result = tokenGenerator.insertMemberToken(m);
			if(result>0) {
				session.setAttribute("alertMsg", "이메일을 확인해 주세요.");
				return "redirect:/";
			}else {
	    		model.addAttribute("errorMsg","이메일 송신이 실패하였습니다.");
	    		return "common/errorPage";
			}
			
		} catch (Exception e) {
			e.printStackTrace();
    		model.addAttribute("errorMsg","500err");
    		return "common/errorPage";
		}
    }
    
    //마이페이지에서 이메일 변경
    @GetMapping("updateEmail.me")
    public String updateEmailMypage(HttpServletResponse response
    		,HttpSession session, Model model, String userId, String domain) {
    	try {
    		Member m = (Member)session.getAttribute("loginUser");
    		
    		//유효성 검사
    		if(m == null || !(userId+domain).matches("^[a-zA-Z0-9.]{1,30}$")) {
    			throw new NullPointerException();
    		}
    		
    		//입력받은 아이디와 도메인을 이메일 형식으로 변경
    		m.setUserId(userId+"@"+domain);
    		
    		//아이디가 중복되는지 확인
    		int result = memberService.checkUserId(m.getUserId());
    		
    		if(result>0) {
    			//중복되면 내다버리기
    			model.addAttribute("errorMsg","잘못된 아이디입니다.");
    			return "common/errorPage";
    			
    		}else {
    			//중복 안 되면 아이디 업데이트
    			result = memberService.updateId(m);
    			
    			if(result == 0) {
    				//업데이트 안 되면 내다버리기
    				model.addAttribute("errorMsg","500 err");
    				return "common/errorPage";
    			}
    		}
    		
    		//토큰 생성기로 보내기
    		result = tokenGenerator.updateEmailToken(m);
    		if(result>0) {
    			session.setAttribute("alertMsg", "이메일을 확인해 주세요.");
    			
    			//자동로그인 쿠키 지우기
    			cookieService.deleteAutoLogin(response,session);
    			
    			//로그아웃
    			session.invalidate();
    			
    			
    			
    			return "redirect:/";
    		}else {
    			model.addAttribute("errorMsg","이메일 송신이 실패하였습니다.");
    			return "common/errorPage";
    		}
    		
    	} catch (Exception e) {
    		e.printStackTrace();
    		model.addAttribute("errorMsg","500err");
    		return "common/errorPage";
    	}
    }
    
    //비밀번호 변경 - 이메일 링크 클릭했을 때
    @RequestMapping(value="findPwdEmail.me", method=RequestMethod.GET)
    public String findPwdEmail(int tokenNo, String token, Model model, HttpSession session) {
    	try {
	    	MemberToken mt = new MemberToken();
	    	mt.setTokenNo(tokenNo);
	    	mt.setToken(token);
	    	
	    	//받은 토큰 비활성화하기
	    	service.confirmEmailInsert(mt);
	    	
	    	//토큰 번호로 해당 유저 찾아내기
    		Member m = service.resendEmail(mt);
    		if(m == null) {
    			//없으면 오류!
    			throw new Exception();
    		}
	    	
	    	//session에 비밀번호 변경 페이지가 활성화되었다고 표시
	    	session.setAttribute("updatePwd", "true");
	    	
	    	//요청한 유저 세션에 넣어주기
	    	session.setAttribute("findPwdUser", m);
	    	
	    	return "redirect:/updatePwd.email";
    	} catch (Exception e) {
    		e.printStackTrace();
    		model.addAttribute("errorMsg","500err");
    		return "common/errorPage";
    	}
    }
    
    //비밀번호 변경페이지로
    @GetMapping("updatePwd.email")
    public String goUpdatePwd(HttpSession session, Model model) {
    	
    	//비밀번호 변경 페이지 접근 권한 확인
    	if(!session.getAttribute("updatePwd").toString().equals("true")) {
    		model.addAttribute("errorMsg","잘못된 접근입니다.");
    		return "common/errorPage";
    	}
    	session.removeAttribute("updatePwd");
    	
    	return "member/updatePwd";
    }
    
	//비밀번호 찾기 - 비밀번호 수정
	@PostMapping("updatePwd.email")
	public String updatePwd(HttpServletResponse response,
			HttpSession session, Model model,String newPwd) {
		try {
			
			//session에서 해당 유저 추출하기
			Member m = (Member)session.getAttribute("findPwdUser");
			
			
			if(!newPwd.matches("^[a-zA-Z0-9]{4,30}$")) {
				//유효성 확인
				model.addAttribute("errorMsg","비밀번호를 확인해주세요.");
				return "common/errorPage";
			}
			
			
			//자동로그인 쿠키 지우기
			cookieService.deleteAutoLogin(response,session);
			//세션 날리기
			session.invalidate();
			
			//비밀번호 암호화
			m.setUserPwd(bcrypt.encode(newPwd));
			
			//db업데이트
			if(memberService.updatePwd(m)>0) {
				return "redirect:/login.me";
			}else {
				model.addAttribute("errorMsg","비밀번호를 변경할 수 없습니다.");
				return "common/errorPage";
			}
			
			
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("errorMsg","500err");
			return "common/errorPage";
		}
	}
    
}
