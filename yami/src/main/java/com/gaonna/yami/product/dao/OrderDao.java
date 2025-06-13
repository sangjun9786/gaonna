package com.gaonna.yami.product.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.gaonna.yami.product.vo.Order;

@Repository
public class OrderDao {
	
	//구매확정
	public int confirmOrder(SqlSessionTemplate sqlSession, Order o) {
		// TODO Auto-generated method stub
		return sqlSession.update("orderMapper.confirmOrder",o);
	}

}
