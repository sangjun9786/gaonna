package com.gaonna.yami.member.email.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.gaonna.yami.member.email.vo.MemberToken;
import com.gaonna.yami.member.model.vo.Member;

@Repository
public class EmailDao {
	
	public int deleteToken(SqlSessionTemplate sqlSession, Member m) {
		return sqlSession.update("emailMapper.deleteToken",m);
	}
	
	public int insertMemberToken(SqlSessionTemplate sqlSession, MemberToken memberToken) {
		return sqlSession.insert("emailMapper.insertMemberToken", memberToken);
	}

	public int confirmEmailInsert(SqlSessionTemplate sqlSession, MemberToken mt) {
		return sqlSession.update("emailMapper.confirmEmailInsert", mt);
	}

	public Member resendEmail(SqlSessionTemplate sqlSession, MemberToken mt) {
		return sqlSession.selectOne("emailMapper.resendEmail", mt);
	}

}
