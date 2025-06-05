package com.gaonna.yami.wishlist.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RequestParam;

import com.gaonna.yami.member.model.vo.Member;
import com.gaonna.yami.wishlist.model.service.WishlistService;

@Controller
public class WishlistController {

    @Autowired
    private WishlistService wishlistService;

    @PostMapping("/product/wish")
    @ResponseBody
    public String toggleWish(@RequestParam int productNo, HttpSession session) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null) return "not-login";

        boolean liked = wishlistService.toggleWish(productNo, loginUser.getUserNo());
        int count = wishlistService.getWishCount(productNo);
        return (liked ? "liked:" : "unliked:") + count;
        
        
    }
}
