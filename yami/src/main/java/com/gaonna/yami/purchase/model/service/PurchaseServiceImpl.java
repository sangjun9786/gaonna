package com.gaonna.yami.purchase.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gaonna.yami.product.vo.Product;              // ← VO 패키지 경로 확인!
import com.gaonna.yami.purchase.model.dao.PurchaseDao;
import com.gaonna.yami.purchase.model.vo.Purchase;

@Service
public class PurchaseServiceImpl implements PurchaseService {

    @Autowired
    private PurchaseDao purchaseDao;

    @Override
    public int insertPurchase(Purchase purchase) {
        return purchaseDao.insertPurchase(purchase);
    }

    // ★ 여기만 null 이었기 때문에 NPE 발생했습니다!
    @Override
    public List<Product> selectPurchasedList(String userId) {
        return purchaseDao.selectPurchasedList(userId);
    }
}