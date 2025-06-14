package com.gaonna.yami.rating.controller;

import java.security.Provider.Service;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import com.gaonna.yami.member.model.vo.Member;
import com.gaonna.yami.rating.model.vo.Rating;
import com.gaonna.yami.rating.model.service.RatingService;

@Controller
public class RatingController {

    @Autowired
    private RatingService ratingService;

    /**
     * AJAX 로 평점 등록
     * POST  /yami/insertRating.rt
     * consumes x-www-form-urlencoded
     * produces application/json
     */
    @PostMapping(
        value = "/insertRating.rt",
        produces = MediaType.APPLICATION_JSON_VALUE
    )
    @ResponseBody
    public int insertRating(
            @RequestParam("userNo")   String userNo,
            @RequestParam("score")       int score,
            HttpSession session
    ) {
//        Map<String,Object> result = new HashMap<>();

//        // 1) 세션에서 로그인 유저 꺼내기
//        Member loginUser = (Member) session.getAttribute("loginUser");
//        if (loginUser == null) {
//            result.put("status", "fail");
//            result.put("message", "로그인이 필요합니다.");
//            return result;
//        }
        
        int result = 0;
        result = ratingService.rating(userNo, score);

//        // 2) VO 채우기
//        Rating rating = new Rating();
//        rating.setProductNo(productNo);
//        rating.setScore(score);
//        rating.setUserComment(comment);
//        // VO에 userId 대신 userNo 필드가 있다면 아래처럼 바꿔주세요
//        // rating.setUserNo(loginUser.getUserNo());
//        rating.setUserNo(loginUser.getUserNo());
//
//        // 3) 서비스 호출
//        int inserted = ratingService.insertRating(rating);
//
//        // 4) JSON 응답
//        if (inserted > 0) {
//            result.put("status", "success");
//        } else {
//            result.put("status", "fail");
//            result.put("message", "등록에 실패했습니다.");
//        }
        return result;
    }
}