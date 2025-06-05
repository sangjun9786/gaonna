package com.gaonna.yami.search.model.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.gaonna.yami.common.PageInfo;
import com.gaonna.yami.member.model.vo.Member;
import com.gaonna.yami.product.vo.Category;
import com.gaonna.yami.product.vo.Product;

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

	public List<String> getUserLoca(SqlSessionTemplate sqlSession, String userLoca) {
		return sqlSession.selectList("searchMapper.getLoca", userLoca);
	}

	public int getFilterCount(SqlSessionTemplate sqlSession, String location, int category, Integer price1, Integer price2) {
		HashMap<String, String> map = new HashMap<>();
		map.put("location", location);
		map.put("category", String.valueOf(category));
		map.put("price1", price1 != null ? String.valueOf(price1) : null);
		map.put("price2", price2 != null ? String.valueOf(price2) : null);
		System.out.println("MAP => " + map);
		return sqlSession.selectOne("searchMapper.getFilterCount", map);
	}

	public ArrayList<Product> productFilter(SqlSessionTemplate sqlSession, String location, int category,
			Integer price1, Integer price2, PageInfo pi) {
		HashMap<String, String> map = new HashMap<>();
		map.put("location", location);
		map.put("category", String.valueOf(category));
		map.put("price1", price1 != null ? String.valueOf(price1) : null);
		map.put("price2", price2 != null ? String.valueOf(price2) : null);
		
		int limit = pi.getBoardLimit();
		int offset = 0;
		RowBounds rowBounds = new RowBounds(offset,limit);
		
		return (ArrayList)sqlSession.selectList("searchMapper.productFilter", map, rowBounds);
	}

}
