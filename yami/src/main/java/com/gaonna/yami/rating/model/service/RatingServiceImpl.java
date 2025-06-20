package com.gaonna.yami.rating.model.service;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gaonna.yami.member.model.vo.Member;
import com.gaonna.yami.rating.model.dao.RatingDao;
import com.gaonna.yami.rating.model.vo.Rating;

@Service
public class RatingServiceImpl implements RatingService {

    @Autowired
    private RatingDao ratingDao;
    @Autowired
	private SqlSessionTemplate sqlSession;

    /**
     * 1) RATING 테이블에 INSERT
     * 2) PRODUCT 테이블의 평균 점수를 갱신 (updateAvgScore 매퍼 필요)
     * 3) INSERT 결과(row count)를 컨트롤러에 그대로 돌려줌
     */
    @Transactional
    @Override
    public int insertRating(Rating rating) {
        int inserted = ratingDao.insertRating(rating);
        // insert 성공 시에만 평균 갱신
        if (inserted > 0) {
            ratingDao.updateAvgScore(rating.getProductNo());
        }
        return inserted;
    }
    
    @Override
    public int rating(String userNo, int score) {
    	return ratingDao.rating(sqlSession, userNo, score);
    }
    
    //마이페이지 - 평점조회
    @Override
    public double selectRatingScore(Member m) {
    	double result=0;
    	
    	List<Rating> ratings = ratingDao.countRatingMember(sqlSession,m);
    	int count = ratings.size();
    	
    	//평점이 적으면 0 반환
    	if(count<3) {
    		return 0;
    	}
    	
    	//평균 구하기
    	double addAllRating=0;
    	for(Rating r : ratings) {
    		addAllRating +=r.getScore();
    	}
    	result = addAllRating/count;
    	
    	//평균 반올림
    	result = Math.round(result * 10) / 10.0;
    	
    	return result;
    }
}