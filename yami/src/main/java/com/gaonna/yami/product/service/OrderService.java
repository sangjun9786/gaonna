package com.gaonna.yami.product.service;

import org.springframework.stereotype.Repository;

import com.gaonna.yami.product.vo.Order;

@Repository
public interface OrderService {
	
	//구매확정
	int confirmOrder(Order o); 

}
