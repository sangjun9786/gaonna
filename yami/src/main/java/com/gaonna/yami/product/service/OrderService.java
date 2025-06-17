package com.gaonna.yami.product.service;

import org.springframework.stereotype.Repository;

import com.gaonna.yami.product.vo.Order;

@Repository
public interface OrderService {
	
	//구매확정
	int confirmOrder(int orderNo, int buyerId);
	
	//주문 조회
	Order selectOrder(int orderNo);
	
	//판매 확정
	int orderSuccess(Order o);
	
	//주문 취소
	int cancelOrder(int orderNo);

}
