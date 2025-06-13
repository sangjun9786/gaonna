package com.gaonna.yami.rating.model.dao;

import org.apache.ibatis.session.SqlSession;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.gaonna.yami.rating.model.vo.Rating;

@Repository
public class RatingDaoImpl implements RatingDao {

    @Autowired
    private SqlSessionTemplate sqlSession;

    @Override
    public int insertRating(Rating rating) {
        return sqlSession.insert("ratingMapper.insertRating", rating);
    }

    @Override
    public int updateAvgScore(int productNo) {
        return sqlSession.update("ratingMapper.updateAvgScore", productNo);
    }
}