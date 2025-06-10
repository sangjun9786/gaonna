package com.gaonna.yami.wishlist.model.dao;

import java.util.Map;

public interface WishlistDao {
    int checkWish(Map<String, Object> map);
    int insertWish(Map<String, Object> map);
    int deleteWish(Map<String, Object> map);
    int selectWishCount(int productNo);
}