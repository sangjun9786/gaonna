package com.gaonna.yami.event.model.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.gaonna.yami.event.model.vo.Event;
import com.gaonna.yami.member.model.vo.Member;

@Repository
public class EventDao {

	public Event eventInfo(SqlSessionTemplate sqlSession, Member loginUser) {
		return sqlSession.selectOne("eventMapper.eventInfo", loginUser);
	}

}
