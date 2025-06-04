package com.gaonna.yami.composite.service;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gaonna.yami.composite.dao.CompositeDao;
import com.gaonna.yami.composite.vo.Category;
import com.gaonna.yami.composite.vo.SearchForm;

@Service
public class CompositeServiceImpl implements CompositeService{
	@Autowired
	private SqlSessionTemplate sqlSession;
	@Autowired
	private CompositeDao dao;

	//ajax - 카테고리 조회
	@Override
	public List<Category> selectCategory() {
		return dao.selectCategory(sqlSession);
	}
	
	//ajax - 게시글 수 조회
	@Override
	public int countMyBoard(SearchForm searchForm) {
		return dao.countMyBoard(sqlSession, searchForm);
	}
	
	//ajax - 게시글 조회
	@Override
	public List<?> searchMyBoard(SearchForm searchForm) {
		//searchForm 정상화
		searchForm.normalize();
		
		switch(searchForm.getSearchType1()) {
		case "question" : //질문게시판
			return dao.selectMyQuestion(sqlSession,searchForm);
		case "report" : //신고게시판
			return dao.selectMyReport(sqlSession,searchForm);
		default : //이도 저도 아니면 그냥 게시판
			return dao.selectMyBoard(sqlSession,searchForm);
		}
	}
}
