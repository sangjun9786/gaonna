package com.gaonna.yami.member.model.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.gaonna.yami.member.model.vo.Member;

@Repository
public class MemberDao {

	public int insertMember(SqlSessionTemplate sqlSession, Member m) {
		return sqlSession.insert("memberMapper.insertMember", m);
	}
	
	public int confirmEmailInsert(SqlSessionTemplate sqlSession, int tokenNo) {
		return sqlSession.update("memberMapper.confirmEmailInsert", tokenNo);
	}

	public int checkUserId(SqlSessionTemplate sqlSession, String id) {
		return sqlSession.selectOne("memberMapper.checkUserId", id);
	}

	public String selectUserId(SqlSessionTemplate sqlSession, int userNo) {
		return sqlSession.selectOne("memberMapper.selectUserId", userNo);
	}

	public Member loginMember(SqlSessionTemplate sqlSession, String userId) {
		return sqlSession.selectOne("memberMapper.loginMember", userId);
	}

	public int updateId(SqlSessionTemplate sqlSession, Member m) {
		return sqlSession.update("memberMapper.updateId", m);
	}

	public int updateName(SqlSessionTemplate sqlSession, Member m) {
		return sqlSession.update("memberMapper.updateName", m);
	}

	public int updatePhone(SqlSessionTemplate sqlSession, Member m) {
		return sqlSession.update("memberMapper.updatePhone", m);
	}

	public String selectRoleType(SqlSessionTemplate sqlSession, int userNo) {
		return sqlSession.selectOne("memberMapper.selectRoleType", userNo);
	}
	
}
