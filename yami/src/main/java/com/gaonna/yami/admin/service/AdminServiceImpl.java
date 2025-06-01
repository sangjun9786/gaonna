package com.gaonna.yami.admin.service;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gaonna.yami.admin.dao.AdminDao;
import com.gaonna.yami.member.model.vo.Member;

@Service
public class AdminServiceImpl implements AdminService{
	@Autowired
	private SqlSessionTemplate sqlSession;
	@Autowired
	private AdminDao dao;
	
	
	@Override
	public Member consoleLogin(String userId) {
		return dao.consoleLogin(sqlSession,userId);
	}
	
	@Override
	public String selectRoleType(Member loginUser) {
		return dao.selectRoleType(sqlSession,loginUser);
	}
	
	//ajax 관리자 조회
	@Override
	public List<Member> searchAdmin(String select) {
		return dao.searchAdmin(sqlSession, select);
	}
}
