package com.gaonna.yami.rating.model.dao;

import org.apache.ibatis.session.SqlSession;
import com.gaonna.yami.rating.model.vo.Rating;

public interface RatingDao {
    int insertRating(Rating rating);
    int updateAvgScore(int productNo);
}