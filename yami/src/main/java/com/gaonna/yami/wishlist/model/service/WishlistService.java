package com.gaonna.yami.wishlist.model.service;

public interface WishlistService {
    boolean toggleWish(int productNo, int userNo);
    int getWishCount(int productNo);
}