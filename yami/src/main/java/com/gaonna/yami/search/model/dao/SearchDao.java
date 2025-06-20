package com.gaonna.yami.search.model.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.gaonna.yami.common.PageInfo;
import com.gaonna.yami.composite.vo.BoardCo;
import com.gaonna.yami.composite.vo.SearchForm;
import com.gaonna.yami.member.model.vo.Member;
import com.gaonna.yami.product.vo.Category;
import com.gaonna.yami.product.vo.Product;
import com.gaonna.yami.search.model.vo.PerchasedBo;

@Repository
public class SearchDao {

	public ArrayList<Category> getCategory(SqlSessionTemplate sqlSession) {
		
		ArrayList<Category> list = (ArrayList)sqlSession.selectList("searchMapper.getCategory");
		 
		return list;
	}

	public String getUserLoca(SqlSessionTemplate sqlSession, Member m) {
		String str =  sqlSession.selectOne("searchMapper.getUserLoca", m);
		
		return str;
	}

	public ArrayList<String> getUserLoca(SqlSessionTemplate sqlSession, String userLoca) {
		return (ArrayList)sqlSession.selectList("searchMapper.getLoca", userLoca);
	}

	public int getFilterCount(SqlSessionTemplate sqlSession, String location, int category, Long price1, Long price2, String keyword) {
		HashMap<String, Object> map = new HashMap<>();
	    map.put("location", location);
	    map.put("category", category);
	    map.put("price1", price1);
	    map.put("price2", price2);
	    map.put("keyword", keyword);
		
		return sqlSession.selectOne("searchMapper.getFilterCount", map);
	}

	public ArrayList<Product> productFilter(SqlSessionTemplate sqlSession, String location, int category,
			Long price1, Long price2, PageInfo pi, String keyword) {
		HashMap<String, Object> map = new HashMap<>();
	    map.put("location", location);
	    map.put("category", category);
	    map.put("price1", price1);
	    map.put("price2", price2);
	    map.put("keyword", keyword);
		
		int limit = pi.getBoardLimit();
		int offset = (pi.getCurrentPage()-1)*limit;
		RowBounds rowBounds = new RowBounds(offset,limit);
		
		return (ArrayList)sqlSession.selectList("searchMapper.productFilter", map, rowBounds);
	}

	public int searchBread(SqlSessionTemplate sqlSession, String keyword) {
		return sqlSession.selectOne("searchMapper.searchBread", keyword);
	}

	public String getBread(SqlSessionTemplate sqlSession, String keyword) {
		return sqlSession.selectOne("searchMapper.getBread", keyword);
	}

	public List<Category> selectCategory(SqlSessionTemplate sqlSession) {
		return sqlSession.selectList("searchMapper.getCategory");
	}

	public int countMyBoard(SqlSessionTemplate sqlSession, SearchForm searchForm) {
		return sqlSession.selectOne("searchMapper.countMyBoard", searchForm);
	}

	public List<PerchasedBo> searchMyBoard(SqlSessionTemplate sqlSession, SearchForm searchForm) {
		return sqlSession.selectList("searchMapper.searchMyBoard", searchForm);
	}

}
