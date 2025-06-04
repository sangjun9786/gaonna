package com.gaonna.yami.search.model.service;

import java.util.ArrayList;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gaonna.yami.member.model.vo.Member;
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
	
	@Override
	public String getUserLoca(Member m) {
		return dao.getUserLoca(sqlSession, m);
	}
	
	@Override
	public List<String> getLoca(String userLoca) {
		return dao.getUserLoca(sqlSession, userLoca);
	}
	
}
