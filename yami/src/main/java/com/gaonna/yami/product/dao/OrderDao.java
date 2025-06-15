package com.gaonna.yami.product.dao;

import java.util.HashMap;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.gaonna.yami.product.vo.Order;

@Repository
public class OrderDao {
	
	//구매확정
	public int confirmOrder(SqlSessionTemplate sqlSession, int orderNo, int buyerId) {
		// TODO Auto-generated method stub
		Map<String, Object> param = new HashMap<>();
	    param.put("orderNo", orderNo);
	    param.put("buyerId", buyerId);
	    System.out.println("확정 시도: orderNo=" + orderNo + ", buyerId=" + buyerId);

	    return sqlSession.update("orderMapper.confirmOrder", param);
	}

	public Order selectOrder(SqlSessionTemplate sqlSession, int orderNo) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("orderMapper.selectOrder",orderNo);
	}

}
