package com.gaonna.yami.rating.model.dao;

import org.apache.ibatis.session.SqlSession;
import org.mybatis.spring.SqlSessionTemplate;

import com.gaonna.yami.rating.model.vo.Rating;

public interface RatingDao {
    int insertRating(Rating rating);
    int updateAvgScore(int productNo);
	int rating(SqlSessionTemplate sqlSession, String userNo, int score);
}