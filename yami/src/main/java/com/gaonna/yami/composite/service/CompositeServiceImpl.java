package com.gaonna.yami.composite.service;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gaonna.yami.composite.dao.CompositeDao;

@Service
public class CompositeServiceImpl {
	@Autowired
	private SqlSessionTemplate sqlSession;
	@Autowired
	private CompositeDao dao;
}
