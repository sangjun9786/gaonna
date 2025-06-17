package com.gaonna.yami.product.dao;

import java.util.ArrayList;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.gaonna.yami.product.vo.Product;

@Repository
public class RecommendDao {

	public ArrayList<Product> recommendProduct(SqlSessionTemplate sqlSession) {
		ArrayList<Product> list = (ArrayList)sqlSession.selectList("searchMapper.recommendProduct");
		System.out.println(list);
		return list;
	}

	public ArrayList<Product> recommendMember(SqlSessionTemplate sqlSession) {
		return (ArrayList)sqlSession.selectList("searchMapper.recommendMember");
	}

}
