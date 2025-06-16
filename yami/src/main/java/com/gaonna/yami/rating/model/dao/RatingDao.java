package com.gaonna.yami.rating.model.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.mybatis.spring.SqlSessionTemplate;

import com.gaonna.yami.member.model.vo.Member;
import com.gaonna.yami.rating.model.vo.Rating;

public interface RatingDao {
    int insertRating(Rating rating);
    int updateAvgScore(int productNo);
	int rating(SqlSessionTemplate sqlSession, String userNo, int score);
	List<Rating> countRatingMember(SqlSessionTemplate sqlSession, Member m);
}