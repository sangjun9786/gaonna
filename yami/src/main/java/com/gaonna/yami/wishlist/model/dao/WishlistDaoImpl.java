package com.gaonna.yami.wishlist.model.dao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class WishlistDaoImpl implements WishlistDao {

    @Autowired
    private SqlSessionTemplate sqlSession;

    @Override
    public int checkWish(Map<String, Object> map) {
        return sqlSession.selectOne("wishlistMapper.checkWish", map);
    }

    @Override
    public int insertWish(Map<String, Object> map) {
        return sqlSession.insert("wishlistMapper.insertWish", map);
    }

    @Override
    public int deleteWish(Map<String, Object> map) {
        return sqlSession.delete("wishlistMapper.deleteWish", map);
    }

    @Override
    public int selectWishCount(int productNo) {
        return sqlSession.selectOne("wishlistMapper.selectWishCount", productNo);
    }
}