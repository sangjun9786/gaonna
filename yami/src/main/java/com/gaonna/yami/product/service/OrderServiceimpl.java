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
	public int confirmOrder(Order o) {
	    // 구매확정: 상태를 BUYER_OK로 변경
	    return dao.confirmOrder(sqlSession, o);
	}
}
