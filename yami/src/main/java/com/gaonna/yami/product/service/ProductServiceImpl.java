package com.gaonna.yami.product.service;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.gaonna.yami.common.PageInfo;
import com.gaonna.yami.product.model.ProductDTO;

@Service
public class ProductServiceImpl implements ProductService {

    @Autowired
    private SqlSession sqlSession;

    @Override
    public int getListCount() {
        return sqlSession.selectOne("productMapper.getListCount");
    }

    @Override
    public List<ProductDTO> selectProductList(PageInfo pi) {
        return sqlSession.selectList("productMapper.selectProductList", pi);
    }
}