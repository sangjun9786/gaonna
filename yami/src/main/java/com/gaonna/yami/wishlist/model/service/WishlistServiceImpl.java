package com.gaonna.yami.wishlist.model.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gaonna.yami.wishlist.model.dao.WishlistDao;

@Service
public class WishlistServiceImpl implements WishlistService {

    @Autowired
    private WishlistDao wishlistDao;

    @Override
    public boolean toggleWish(int productNo, int userNo) {
        Map<String, Object> map = new HashMap<>();
        map.put("productNo", productNo);
        map.put("userNo", userNo);

        int count = wishlistDao.checkWish(map);
        if (count > 0) {
            wishlistDao.deleteWish(map);
            return false;
        } else {
            wishlistDao.insertWish(map);
            return true;
        }
    }

    @Override
    public int getWishCount(int productNo) {
        return wishlistDao.selectWishCount(productNo);
    }
}