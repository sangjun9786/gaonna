package com.gaonna.yami.purchase.model.service;

import java.util.List;

import com.gaonna.yami.product.vo.Product;
import com.gaonna.yami.purchase.model.vo.Purchase;

public interface PurchaseService {
    int insertPurchase(Purchase purchase);

	List<Product> selectPurchasedList(String userId);
}