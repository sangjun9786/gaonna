package com.gaonna.yami.admin.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.gaonna.yami.member.model.vo.Member;

@Repository
public class AdminDao {

	public Member consoleLogin(SqlSessionTemplate sqlSession, String userId) {
		return sqlSession.selectOne("adminMapper.consoleLogin",userId);
	}

	public String selectRoleType(SqlSessionTemplate sqlSession, Member loginUser) {
		return sqlSession.selectOne("adminMapper.selectRoleType",loginUser);
	}

	public List<Member> searchAdmin(SqlSessionTemplate sqlSession, String select) {
		return sqlSession.selectList("adminMapper.searchAdmin", select);
	}

}
