package com.gaonna.yami.member.model.service;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.gaonna.yami.member.model.dao.MemberDao;
import com.gaonna.yami.member.model.vo.Member;


@Service
public class MemberServiceImpl implements MemberService{
	@Autowired
	private SqlSessionTemplate sqlSession;
	@Autowired
	private BCryptPasswordEncoder bcrypt;
	
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
}
