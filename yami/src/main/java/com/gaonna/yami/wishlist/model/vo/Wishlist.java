package com.gaonna.yami.wishlist.model.vo;

public class Wishlist {
    private int wishId;
    private int userNo;
    private int productNo;
    private int wishCount; // 실제 사용 여부에 따라 제거 가능

    public Wishlist() {}

    public Wishlist(int wishId, int userNo, int productNo, int wishCount) {
        this.wishId = wishId;
        this.userNo = userNo;
        this.productNo = productNo;
        this.wishCount = wishCount;
    }

    public int getWishId() {
        return wishId;
    }

    public void setWishId(int wishId) {
        this.wishId = wishId;
    }

    public int getUserNo() {
        return userNo;
    }

    public void setUserNo(int userNo) {
        this.userNo = userNo;
    }

    public int getProductNo() {
        return productNo;
    }

    public void setProductNo(int productNo) {
        this.productNo = productNo;
    }

    public int getWishCount() {
        return wishCount;
    }

    public void setWishCount(int wishCount) {
        this.wishCount = wishCount;
    }

    @Override
    public String toString() {
        return "Wishlist [wishId=" + wishId + ", userNo=" + userNo + ", productNo=" + productNo + ", wishCount=" + wishCount + "]";
    }
}