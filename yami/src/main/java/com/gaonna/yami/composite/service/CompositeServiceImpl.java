package com.gaonna.yami.composite.service;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gaonna.yami.composite.dao.CompositeDao;
import com.gaonna.yami.composite.vo.BoardCo;
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
	public List<BoardCo> searchMyBoard(SearchForm searchForm) {
		//searchForm 정상화
		searchForm.normalize();
		return dao.selectMyBoard(sqlSession,searchForm);
	}
	
	//ajax - 댓글 수 조회
	@Override
	public int countMyReply(SearchForm searchForm) {
		return dao.countMyReply(sqlSession, searchForm);
	}
}
