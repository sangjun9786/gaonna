package com.gaonna.yami.composite.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.gaonna.yami.composite.vo.BoardCo;
import com.gaonna.yami.composite.vo.Category;
import com.gaonna.yami.composite.vo.ReplyCo;
import com.gaonna.yami.composite.vo.SearchForm;
import com.gaonna.yami.location.vo.BakeryComment;

@Repository
public class CompositeDao {

	public List<Category> selectCategory(SqlSessionTemplate sqlSession) {
		return sqlSession.selectList("compositeMapper.selectCategory");
	}

	public int countMyBoard(SqlSessionTemplate sqlSession, SearchForm searchForm) {
		return sqlSession.selectOne("compositeMapper.countMyBoard",searchForm);
	}

	public List<BoardCo> searchMyBoard(SqlSessionTemplate sqlSession, SearchForm searchForm) {
		return sqlSession.selectList("compositeMapper.searchMyBoard",searchForm);
	}

	public int countMyReply(SqlSessionTemplate sqlSession, SearchForm searchForm) {
		return sqlSession.selectOne("compositeMapper.countMyReply",searchForm);
	}

	public List<ReplyCo> searchMyReply(SqlSessionTemplate sqlSession, SearchForm searchForm) {
		return sqlSession.selectList("compositeMapper.searchMyReply",searchForm);
	}

	public int countMyReplyDongne(SqlSessionTemplate sqlSession, SearchForm searchForm) {
		return sqlSession.selectOne("compositeMapper.countMyReplyDongne",searchForm);
	}

	public List<BakeryComment> searchMyReplyDongne(SqlSessionTemplate sqlSession, SearchForm searchForm) {
		return sqlSession.selectList("compositeMapper.searchMyReplyDongne",searchForm);
	}

	public int countMyWishlist(SqlSessionTemplate sqlSession, SearchForm searchForm) {
		return sqlSession.selectOne("compositeMapper.countMyWishlist",searchForm);
	}

	public List<BoardCo> searchMyWishlist(SqlSessionTemplate sqlSession, SearchForm searchForm) {
		return sqlSession.selectList("compositeMapper.searchMyWishlist",searchForm);
	}
}
