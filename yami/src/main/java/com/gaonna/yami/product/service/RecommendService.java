package com.gaonna.yami.product.service;

import java.util.ArrayList;

import org.springframework.stereotype.Repository;

import com.gaonna.yami.product.vo.Product;

@Repository
public interface RecommendService {

	ArrayList<Product> recommendProduct();

//	ArrayList<Product> recommendMember();s

}
