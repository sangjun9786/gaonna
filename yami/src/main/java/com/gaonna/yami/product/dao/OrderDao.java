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
	
	//거래완료
	public int updateOrderSuccess(SqlSessionTemplate sqlSession, int orderNo) {
		// TODO Auto-generated method stub
		return sqlSession.update("orderMapper.updateOrderSuccess", orderNo);
	}
	
	//포인트정산
	public int increasePoint(SqlSessionTemplate sqlSession, int sellerId, int usedPoint) {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<>();
	    map.put("sellerId", sellerId);
	    map.put("usedPoint", usedPoint);
	    return sqlSession.update("orderMapper.increasePoint", map);
	}
	
	//판매게시판 상태값 Y
	public int updateProductStatus(SqlSessionTemplate sqlSession, int productNo) {
		// TODO Auto-generated method stub
	    return sqlSession.update("productMapper.updateProductStatusY", productNo);

	}

}
