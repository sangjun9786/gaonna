package com.gaonna.yami.product.service;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gaonna.yami.product.dao.RecommendDao;

@Service
public class RecommendServiceImpl implements RecommendService {
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Autowired
	private RecommendDao dao;
	
}
