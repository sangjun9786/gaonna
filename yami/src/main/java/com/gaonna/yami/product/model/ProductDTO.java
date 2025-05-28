package com.gaonna.yami.product.model;

public class ProductDTO {
    private int productNo;
    private String title;
    private String path; // 이미지 파일명
    private int price;
    private String location;
    private String category;

    public ProductDTO() {}

    public ProductDTO(int productNo, String title, String path, int price, String location, String category) {
        this.productNo = productNo;
        this.title = title;
        this.path = path;
        this.price = price;
        this.location = location;
        this.category = category;
    }

    // Getter / Setter
    public int getProductNo() {
        return productNo;
    }

    public void setProductNo(int productNo) {
        this.productNo = productNo;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }
}