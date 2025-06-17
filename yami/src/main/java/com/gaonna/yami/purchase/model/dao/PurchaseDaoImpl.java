package com.gaonna.yami.purchase.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.gaonna.yami.product.vo.Product;
import com.gaonna.yami.purchase.model.vo.Purchase;

@Repository
public class PurchaseDaoImpl implements PurchaseDao {
    @Autowired
    private SqlSessionTemplate sqlSession;

    @Override
    public int insertPurchase(Purchase purchase) {
        return sqlSession.insert(
          "com.gaonna.yami.purchase.model.dao.PurchaseDao.insertPurchase", purchase);
    }

    @Override
    public List<Product> selectPurchasedList(String userId) {
        return sqlSession.selectList(
          "com.gaonna.yami.purchase.model.dao.PurchaseDao.selectPurchasedList", userId);
    }
}