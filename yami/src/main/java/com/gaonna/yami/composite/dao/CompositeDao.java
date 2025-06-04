package com.gaonna.yami.composite.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.gaonna.yami.composite.vo.BoardCo;
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

	public List<BoardCo> selectMyBoard(SqlSessionTemplate sqlSession, SearchForm searchForm) {
		return sqlSession.selectList("compositeMapper.selectMyBoard",searchForm);
	}

	public int countMyReply(SqlSessionTemplate sqlSession, SearchForm searchForm) {
		return sqlSession.selectOne("compositeMapper.countMyReply",searchForm);
	}
}
