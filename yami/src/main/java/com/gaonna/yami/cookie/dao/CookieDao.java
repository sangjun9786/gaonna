package com.gaonna.yami.cookie.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.gaonna.yami.cookie.vo.CookieToken;

@Repository
public class CookieDao {

	//자동로그인 토큰 저장
	public int autoLogin(SqlSessionTemplate sqlSession, CookieToken cookieToken) {
		return sqlSession.insert("CookieMapper.autoLogin",cookieToken);
	}

}
