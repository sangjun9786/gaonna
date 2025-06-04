package com.gaonna.yami.search.model.dao;

import java.util.ArrayList;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.gaonna.yami.member.model.vo.Member;
import com.gaonna.yami.product.vo.Category;

@Repository
public class SearchDao {

	public ArrayList<Category> getCategory(SqlSessionTemplate sqlSession) {
		
		ArrayList<Category> list = (ArrayList)sqlSession.selectList("searchMapper.getCategory");
		 
		return list;
	}

	public String getUserLoca(SqlSessionTemplate sqlSession, Member m) {
		String str =  sqlSession.selectOne("searchMapper.getUserLoca", m);
		System.out.println(str);
		return str;
	}

	public List<String> getUserLoca(SqlSessionTemplate sqlSession, String userLoca) {
		return sqlSession.selectList("searchMapper.getLoca", userLoca);
	}

}
