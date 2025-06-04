package com.gaonna.yami.search.model.service;

import java.util.ArrayList;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gaonna.yami.product.vo.Category;
import com.gaonna.yami.search.model.dao.SearchDao;

@Service
public class SearchServiceImpl implements SearchService {
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Autowired
	private SearchDao dao;
	
	@Override
	public ArrayList<Category> getCategory() {
		return dao.getCategory(sqlSession);
	}
	
}
