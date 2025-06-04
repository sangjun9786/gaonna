package com.gaonna.yami.search.model.dao;

import java.util.ArrayList;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.gaonna.yami.product.vo.Category;

@Repository
public class SearchDao {

	public ArrayList<Category> getCategory(SqlSessionTemplate sqlSession) {
		
		 ArrayList<Category> list = (ArrayList)sqlSession.selectList("searchMapper.getCategory");
		 
		return list;
	}

}
