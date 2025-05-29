package com.gaonna.yami.event.model.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.gaonna.yami.event.model.vo.Event;
import com.gaonna.yami.member.model.vo.Member;

@Repository
public class EventDao {

	public Event eventInfo(SqlSessionTemplate sqlSession, Member loginUser) {
		
		Event event = sqlSession.selectOne("eventMapper.eventInfo", loginUser);
		
		if(event != null) {
			return event;
		}else {
			sqlSession.insert("eventMapper.insertEvent", loginUser);
			return sqlSession.selectOne("eventMapper.eventInfo", loginUser);
		}
	}

	public int attendance(SqlSessionTemplate sqlSession, Event e) {
		Event event = sqlSession.selectOne("eventMapper.compareDate", e);
		if(event != null) {
			return sqlSession.update("eventMapper.attendance", e);
		}else {
			return 0;
		}
	}

}
