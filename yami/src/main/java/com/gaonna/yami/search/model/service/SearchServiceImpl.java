package com.gaonna.yami.search.model.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gaonna.yami.common.PageInfo;
import com.gaonna.yami.composite.vo.SearchForm;
import com.gaonna.yami.member.model.vo.Member;
import com.gaonna.yami.product.vo.Category;
import com.gaonna.yami.product.vo.Product;
import com.gaonna.yami.search.model.dao.SearchDao;
import com.gaonna.yami.search.model.vo.PerchasedBo;

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
	public ArrayList<String> getLoca(String userLoca) {
		return dao.getUserLoca(sqlSession, userLoca);
	}
	
	@Override
	public int getFilterCount(String location, int category, Long price1, Long price2, String keyword) {
		return dao.getFilterCount(sqlSession, location, category, price1, price2, keyword);
	}
	
	@Override
	public ArrayList<Product> productFilter(String location, int category, Long price1, Long price2, PageInfo pi, String keyword) {
		return dao.productFilter(sqlSession, location, category, price1, price2, pi, keyword);
	}
	
	@Override
	public int searchBread(String keyword) {
		return dao.searchBread(sqlSession, keyword);
	}
	
	@Override
	public String getBread(String keyword) {
		return dao.getBread(sqlSession, keyword);
	}
	
	@Override
	public List<Category> selectCategory() {
		return dao.selectCategory(sqlSession);
	}
	
	//ajax - 게시글 조회
	@Override
	public Map<String, Object> searchMyBoard(SearchForm searchForm) {
		//resultCount(게시글 수) 구하기
		searchForm.setResultCount(dao.countMyBoard(sqlSession, searchForm));
		
		//searchForm 정상화
		searchForm.normalize();
		
		//게시글 구하기
		List<PerchasedBo> result = dao.searchMyBoard(sqlSession,searchForm);
		
		
		return Map.of("result", result, "totalCount", searchForm.getResultCount());
	}
}
