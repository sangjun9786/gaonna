package com.gaonna.yami.product.service;

import java.util.List;
import com.gaonna.yami.common.PageInfo;
import com.gaonna.yami.product.model.ProductDTO;

public interface ProductService {
    int getListCount();
    List<ProductDTO> selectProductList(PageInfo pi);
}