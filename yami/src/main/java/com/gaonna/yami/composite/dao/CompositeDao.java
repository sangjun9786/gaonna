package com.gaonna.yami.composite.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.gaonna.yami.composite.vo.Category;
import com.gaonna.yami.composite.vo.SearchForm;

@Repository
public class CompositeDao {

	public List<Category> selectCategory(SqlSessionTemplate sqlSession) {
		return sqlSession.selectList("compositeMapper.selectCategory");
	}

	public int countMyBoard(SqlSessionTemplate sqlSession, SearchForm searchForm) {
		return sqlSession.selectOne("compositeMapper.countMyBoard",searchForm);
	}

	public List<Object> selectMyQuestion(SqlSessionTemplate sqlSession, SearchForm searchForm) {
		return sqlSession.selectList("compositeMapper.selectMyQuestion",searchForm);
	}

	public List<Object> selectMyReport(SqlSessionTemplate sqlSession, SearchForm searchForm) {
		return sqlSession.selectList("compositeMapper.selectMyReport",searchForm);
	}

	public List<Object> selectMyBoard(SqlSessionTemplate sqlSession, SearchForm searchForm) {
		return sqlSession.selectList("compositeMapper.selectMyBoard",searchForm);
	}
}
