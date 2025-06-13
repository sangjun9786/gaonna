package com.gaonna.yami.rating.model.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gaonna.yami.rating.model.dao.RatingDao;
import com.gaonna.yami.rating.model.vo.Rating;

@Service
public class RatingServiceImpl implements RatingService {

    @Autowired
    private RatingDao ratingDao;

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
}