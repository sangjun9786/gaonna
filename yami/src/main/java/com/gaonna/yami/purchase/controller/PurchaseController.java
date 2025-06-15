package com.gaonna.yami.purchase.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.gaonna.yami.member.model.vo.Member;
import com.gaonna.yami.product.vo.Product;
import com.gaonna.yami.purchase.model.service.PurchaseService;
import com.gaonna.yami.purchase.model.vo.Purchase;

@Controller
public class PurchaseController {

    @Autowired
    private PurchaseService purchaseService;

    /**
     * 📌 상품 구매 등록
     */
    @PostMapping("/purchaseInsert.do")
    public String insertPurchase(@RequestParam("productNo") int productNo,
                                 HttpSession session) {

        Member loginUser = (Member) session.getAttribute("loginUser");

        Purchase p = new Purchase();
        p.setProductNo(productNo);
        p.setBuyerId(loginUser.getUserId()); // userId 기준

        purchaseService.insertPurchase(p);

        session.setAttribute("alertMsg", "구매가 완료되었습니다.");
        return "redirect:/myPage.me";
    }

    /**
     * 📌 로그인한 유저의 구매 목록 조회 (평점용 Ajax)
     */
    @GetMapping("/myPurchasedList.po")
    @ResponseBody
    public Map<String, Object> getMyPurchasedList(
            @SessionAttribute("loginUser") Member loginUser) {

        List<Product> list = purchaseService.selectPurchasedList(loginUser.getUserId());

        Map<String, Object> result = new HashMap<>();
        result.put("result", list);
        result.put("totalCount", list.size());

        return result;
    }
}