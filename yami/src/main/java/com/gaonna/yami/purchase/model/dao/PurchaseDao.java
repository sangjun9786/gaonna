package com.gaonna.yami.purchase.model.dao;

import java.util.List;
import com.gaonna.yami.product.vo.Product;
import com.gaonna.yami.purchase.model.vo.Purchase;

public interface PurchaseDao {
    int insertPurchase(Purchase purchase);
    List<Product> selectPurchasedList(String userId);
}