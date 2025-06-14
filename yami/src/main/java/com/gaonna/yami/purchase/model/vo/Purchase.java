package com.gaonna.yami.purchase.model.vo;

import java.sql.Date;

public class Purchase {
    private int purchaseNo;
    private int productNo;
    private String buyerId;
    private Date purchaseDate;

    // Getter & Setter
    public int getPurchaseNo() { return purchaseNo; }
    public void setPurchaseNo(int purchaseNo) { this.purchaseNo = purchaseNo; }

    public int getProductNo() { return productNo; }
    public void setProductNo(int productNo) { this.productNo = productNo; }

    public String getBuyerId() { return buyerId; }
    public void setBuyerId(String buyerId) { this.buyerId = buyerId; }

    public Date getPurchaseDate() { return purchaseDate; }
    public void setPurchaseDate(Date purchaseDate) { this.purchaseDate = purchaseDate; }
}