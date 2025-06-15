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
}
