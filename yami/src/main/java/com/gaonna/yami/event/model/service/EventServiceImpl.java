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
	
	@Override
	public int resetCount(Event e) {
		return dao.resetCount(sqlSession, e);
	}
	
	@Override
	public int point1000(Member loginUser) {
		return dao.point1000(sqlSession, loginUser);
	}
	
	@Override
	public int point500(Member loginUser) {
		return dao.point500(sqlSession, loginUser);
	}
	
	@Override
	public int rating(int productNo, int memberNo, int score) {
		return dao.rating(sqlSession, productNo, memberNo, score);
	}
}
