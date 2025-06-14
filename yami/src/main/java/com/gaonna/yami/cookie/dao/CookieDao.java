package com.gaonna.yami.cookie.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.gaonna.yami.cookie.vo.CookieToken;
import com.gaonna.yami.member.model.vo.Member;

@Repository
public class CookieDao {

	//자동로그인 기존 토큰 삭제
	public int deleteAutoLoginToken(SqlSessionTemplate sqlSession, CookieToken cookieToken) {
		return sqlSession.delete("cookieMapper.deleteAutoLoginToken",cookieToken);
	}
	
	//자동로그인 토큰 저장
	public int insertAutoLoginToken(SqlSessionTemplate sqlSession, CookieToken cookieToken) {
		return sqlSession.insert("cookieMapper.insertAutoLoginToken",cookieToken);
	}

	//자동로그인 토큰 확인
	public int selectAutoLoginToken(SqlSessionTemplate sqlSession, CookieToken cookieToken) {
		return sqlSession.selectOne("cookieMapper.selectAutoLoginToken",cookieToken);
	}

	//로그인
	public Member autoLogin(SqlSessionTemplate sqlSession, int userNo) {
		return sqlSession.selectOne("cookieMapper.autoLogin", userNo);
	}

}
