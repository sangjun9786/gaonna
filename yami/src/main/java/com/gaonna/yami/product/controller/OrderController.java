package com.gaonna.yami.product.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.gaonna.yami.member.model.vo.Member;
import com.gaonna.yami.product.service.OrderService;
import com.gaonna.yami.product.vo.Attachment;
import com.gaonna.yami.product.vo.Order;
import com.gaonna.yami.product.vo.Product;

public class OrderController {
	
	@Autowired
    private OrderService service;
	
	//구매확정 
	@PostMapping("/confirmOrder")
	public String confirmOrder(Order o
							  ,Model model
							  ,HttpSession session){
	    
		Member m = (Member) session.getAttribute("loginUser");
	    
		if (m == null) {
	        model.addAttribute("msg", "로그인이 필요합니다.");
	        return "common/errorPage";
	    }

	    int result = service.confirmOrder(o);

	    if (result > 0) {
	        model.addAttribute("msg", "구매확정 완료! 판매자도 확정 시 거래가 완료됩니다.");
	        return "redirect:/orderDetail?orderNo=" + o.getOrderNo(); // 경로/페이지명 맞춰서 수정
	    } else {
	        model.addAttribute("msg", "구매확정 처리에 실패했습니다. 다시 시도해주세요.");
	        return "common/errorPage";
	    }
	}
	
}
