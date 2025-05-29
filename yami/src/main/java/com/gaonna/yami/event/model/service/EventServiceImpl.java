package com.gaonna.yami.event.model.service;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gaonna.yami.event.model.dao.EventDao;
import com.gaonna.yami.event.model.vo.Event;
import com.gaonna.yami.member.model.vo.Member;

@Service
public class EventServiceImpl implements EventService {
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Autowired
	private EventDao dao;
	
	@Override
	public Event eventInfo(Member loginUser) {
		return dao.eventInfo(sqlSession, loginUser);
	}
	
	@Override
	public int attendance(Event e) {
		return dao.attendance(sqlSession, e);
	}
	
}
