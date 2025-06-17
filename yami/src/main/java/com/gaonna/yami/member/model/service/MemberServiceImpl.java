package com.gaonna.yami.member.model.service;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gaonna.yami.location.service.LocationService;
import com.gaonna.yami.location.vo.Coord;
import com.gaonna.yami.member.model.dao.MemberDao;
import com.gaonna.yami.member.model.vo.Member;


@Service
public class MemberServiceImpl implements MemberService{
	@Autowired
	private SqlSessionTemplate sqlSession;
	@Autowired
	private BCryptPasswordEncoder bcrypt;
	@Autowired
	private LocationService locationService;
	
	
	@Autowired
	private MemberDao dao;

	@Override
	public int insertMember(Member m) {
		return dao.insertMember(sqlSession,m);
	}
	
	@Override
	public int confirmEmailInsert(int tokenNo) {
		return dao.confirmEmailInsert(sqlSession,tokenNo);
	}

	@Override
	public int checkUserId(String id) {
		return dao.checkUserId(sqlSession,id);
	}

	@Override
	public String selectUserId(int userNo) {
		return dao.selectUserId(sqlSession,userNo);
	}
	
	//로그인
	@Override
	public Member loginMember(String userId, String domain, String userPwd){
		
		//유효성 검사
		if(!userId.matches("^[a-zA-Z0-9]{1,30}$")
				||!userPwd.matches("^[a-zA-Z0-9]{4,30}$")
				||domain == null) {
			return null;
		}
		//입력받은 아이디와 도메인을 이메일 형식으로 변경
		userId = userId+"@"+domain;
		
		Member m = dao.loginMember(sqlSession,userId);
		
		//해당하는 아이디의 유저가 없으면 널 반환
		if(m == null) {
			return null;
		}
		
		if(m.getRoleType().equals("Y")) {
			//권한 있으면 조회해서 넣어주기
			m.setRoleType(dao.selectRoleType(sqlSession,m.getUserNo()));
		}
		
		//비밀번호 검증
		if(bcrypt.matches(userPwd,m.getUserPwd())) {
			return m;
		}else {
			return null;
		}
	}
	
	@Override
	public int updateId(Member m) {
		return dao.updateId(sqlSession,m);
	}
	@Override
	public int updateName(Member m) {
		return dao.updateName(sqlSession,m);
	}
	@Override
	public int updatePhone(Member m) {
		return dao.updatePhone(sqlSession,m);
	}
	@Override
	public int updatePwd(Member m) {
		return dao.updatePwd(sqlSession,m);
	}
	
	
	@Override
	public int insertDongne(HttpSession session, String isMain) throws Exception {
		
		//session의 currCoord, loginUser불러오기
		Coord currCoord = (Coord)session.getAttribute("currCoord");
		Member loginUser = (Member)session.getAttribute("loginUser");
		
		//받아 온 값 유효성 검사
		
		//이미 가지고 있는 좌표들이 5개 이상이면 되겠냐?
		List<Coord> coords = (List)session.getAttribute("coords");
		if(coords.size()>=5) {
			throw new Exception();
		}
		//중복검사
		for(Coord i : coords) {
			if((i.getCoordAddress().replaceAll("\\s+", ""))
					.equals(currCoord.getCoordAddress().replaceAll("\\s+", ""))) {
				throw new Exception();
			}
		}
		
		
		int result=0;
		if(isMain.equals("Y")) {
			//위치 넣고 바로 대표로 삼기
			result = locationService.insertDongneMain(currCoord,loginUser);
			
			//loginUser도 최신화
			session.setAttribute("loginUser", loginUser);
		}else {
			//위치 넣기
			result = locationService.insertDongne(currCoord,loginUser);
		}
		
		//currCoord에 현재시각 수동 넣어주기
		currCoord.setCoordDate(new Date());
		
		//coords 초기화
		coords = locationService.selectUserDongne(loginUser.getUserNo());
		session.setAttribute("coords", coords);
		
		return result;
	}
	
	@Override
	@Transactional
	public int deleteCoord(HttpSession session, int coordNo) {
		
		Member loginUser = (Member)session.getAttribute("loginUser");
		int result=1;
		
		
		//coordNo가 대표이면 대표번호 삭제
		if(coordNo == loginUser.getMainCoord()) {
			result *= dao.deleteMainCoord(sqlSession, loginUser);
			
			if(result>0) {
				//session반영
				loginUser.setMainCoord(0);
				session.setAttribute("loginUser", loginUser);
			}
		}
		
		//coord삭제
		result *= locationService.deleteCoord(coordNo);
		
		return result;
	}
	
	@Override
	public int updateMainCoord(Member m, int coordNo) {
		
		//유효성 검사 -  coordNo가 대표 동네일 경우
		if(coordNo == m.getMainCoord()) {
			return 0;
		}
		
		//m의 mainCoord를 받은 coordNo로 바꿔치기
		m.setMainCoord(coordNo);
		
		//db업데이트
		int result = dao.updateMainCoord(sqlSession, m);
		
		return result;
	}
	
	@Override
	public int selectUserNo(Member m) {
		return dao.selectUserNo(sqlSession,m);
	}
	
	
	@Override
	public String selectUserPwd(int userNo) {
		return dao.selectUserPwd(sqlSession,userNo);
	}
	
	//ajax - 아이디/비밀번호 확인
	@Override
	public int confirmIdPwd(Member m,String userId, String userPwd) {
		
		//아이디 확인
		if(!userId.equals(m.getUserId())) {
			return 0;
		}
		
		//비밀번호 조회
		m.setUserPwd(dao.selectUserPwd(sqlSession,m.getUserNo()));
		
		//비밀번호 확인
		if(!bcrypt.matches(userPwd,m.getUserPwd())) {
			return 0;
		}
		return 1;
	}
	
	@Override
	public int deleteUser(Member m) {
		return dao.deleteUser(sqlSession,m);
	}	
}