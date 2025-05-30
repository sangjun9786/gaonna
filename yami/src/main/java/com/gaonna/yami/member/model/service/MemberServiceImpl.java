package com.gaonna.yami.member.model.service;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

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
	
	
	@Transactional
	@Override
	public int insertDongne(HttpSession session, Model model
			, String isMain, String latitude, String longitude) throws Exception {
		
		Member loginUser = (Member)session.getAttribute("loginUser");
		
		//이미 가지고 있는 좌표들이 5개 이상이면 불가능
		List<Coord> coords = (List)session.getAttribute("coords");
		if(coords.size()>=5) {
			throw new Exception();
		}
		
		//해당 위도, 경도에 해당하는 위치 추출
		Coord currCoord = new Coord();
		currCoord.setLongitude(longitude);
		currCoord.setLatitude(latitude);
		
		currCoord.setCoordAddress(locationService.reverseGeocode(currCoord));
		
		//위치가 이미 존재하는 위치면 가세요라
		for(Coord i : coords) {
			//위치 판별은 coordAddress기준
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
}
