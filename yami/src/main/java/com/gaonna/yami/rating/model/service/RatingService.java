package com.gaonna.yami.rating.model.service;

import com.gaonna.yami.rating.model.vo.Rating;

public interface RatingService {
    /** 새 평점 레코드를 INSERT 하고, 영향을 받은 행(row) 수를 리턴 */
    int insertRating(Rating rating);
}