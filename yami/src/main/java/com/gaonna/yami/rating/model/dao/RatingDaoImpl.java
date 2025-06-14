package com.gaonna.yami.rating.model.dao;

import java.util.HashMap;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.gaonna.yami.rating.model.vo.Rating;

@Repository
public class RatingDaoImpl implements RatingDao {

//    @Autowired
//    private SqlSessionTemplate sqlSession;

//    @Override
//    public int insertRating(Rating rating) {
//        return sqlSession.insert("ratingMapper.insertRating", rating);
//    }
//
//    @Override
//    public int updateAvgScore(int productNo) {
//        return sqlSession.update("ratingMapper.updateAvgScore", productNo);
//    }
    
    @Override
    public int rating(SqlSessionTemplate sqlSession, String userNo, int rating) {
    	int count = sqlSession.selectOne("ratingMapper.count", userNo);
    	Map<String, Object> map = new HashMap<>();
    	map.put("userNo", userNo);
    	map.put("score", rating);
    	System.out.println(userNo);
    	System.out.println(rating);
    	if(count == 1) {
    		return sqlSession.update("ratingMapper.rating", map);
    	}else {
    		return sqlSession.insert("ratingMapper.insert", map);
    	}
    }

	@Override
	public int insertRating(Rating rating) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int updateAvgScore(int productNo) {
		// TODO Auto-generated method stub
		return 0;
	}
}