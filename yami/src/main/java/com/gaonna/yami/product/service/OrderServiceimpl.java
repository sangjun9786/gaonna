package com.gaonna.yami.product.service;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gaonna.yami.product.dao.OrderDao;
import com.gaonna.yami.product.vo.Order;

@Service
public class OrderServiceimpl implements OrderService {
	
	@Autowired
    private SqlSessionTemplate sqlSession;
	
	@Autowired
    private OrderDao dao;
	
	@Override
	public int confirmOrder(int orderNo, int buyerId) {
	    // 구매확정: 상태를 BUYER_OK로 변경
	    return dao.confirmOrder(sqlSession, orderNo, buyerId);
	}
	
	@Override
	public Order selectOrder(int orderNo) {
		// TODO Auto-generated method stub
		return dao.selectOrder(sqlSession, orderNo);
	}
	
	@Transactional
	@Override
	public int orderSuccess(Order o) {
		// TODO Auto-generated method stub
		int r1 = dao.updateOrderSuccess(sqlSession, o.getOrderNo());
	    int r2 = dao.increasePoint(sqlSession, o.getSellerId(), o.getUsedPoint());
	    int r3 = dao.updateProductStatus(sqlSession, o.getProductNo());

	    return r1 * r2 * r3; // 하나라도 실패하면 0 반환
	}
	
	@Transactional
	@Override
	public int cancelOrder(int orderNo) {
		// TODO Auto-generated method stub
		Order o = dao.selectOrder(sqlSession, orderNo); 
	    int r1 = dao.deleteOrder(sqlSession, orderNo); //주문테이블 삭제
	    int r2 = dao.updateProductStatusN(sqlSession, o.getProductNo()); //게시판상태값
	    int r3 = 1;
	    if (o.getUsedPoint() > 0) {
	        r3 = dao.refundPoint(sqlSession, o.getBuyerId(), o.getUsedPoint()); //포인트 환불
	    }

	    return (r1 > 0 && r2 > 0 && r3 > 0) ? 1 : 0; // 모두 성공했을때만 반환
	}
}