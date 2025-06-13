package com.gaonna.yami.product.service;

import java.util.ArrayList;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gaonna.yami.product.dao.RecommendDao;
import com.gaonna.yami.product.vo.Product;

@Service
public class RecommendServiceImpl implements RecommendService {
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Autowired
	private RecommendDao dao;
	
	@Override
	public ArrayList<Product> recommendProduct() {
		return dao.recommendProduct(sqlSession);
	}
	
//	@Override
//	public ArrayList<Product> recommendMember() {
//		return dao.recommendMember(sqlSession);
//	}
}
