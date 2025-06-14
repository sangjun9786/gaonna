package com.gaonna.yami.product.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.gaonna.yami.member.model.vo.Member;
import com.gaonna.yami.product.service.OrderService;
import com.gaonna.yami.product.service.ProductService;
import com.gaonna.yami.product.vo.Attachment;
import com.gaonna.yami.product.vo.Order;
import com.gaonna.yami.product.vo.Product;

@Controller
@RequestMapping("/order")
public class OrderController {
	
	@Autowired
    private OrderService service;
	
	//product 서비스
	@Autowired
    private ProductService pservice;
	
	//구매확정 
	@PostMapping("/confirmOrder")
	public String confirmOrder(@RequestParam("orderNo") int orderNo
							  ,Model model
							  ,HttpSession session){
	    
		Member m = (Member) session.getAttribute("loginUser");
	    
		if (m == null) {
	        model.addAttribute("msg", "로그인이 필요합니다.");
	        return "common/errorPage"; //로그인 페이지로 리턴
	    }
		int buyerId = m.getUserNo();


	    int result = service.confirmOrder(orderNo, buyerId);

	    if (result > 0) {
	        model.addAttribute("msg", "구매확정 완료! 판매자도 확정 시 거래가 완료됩니다.");
	        return "redirect:/order/productOrder?orderNo=" + orderNo; // 경로/페이지명 맞춰서 수정
	    } else {
	        model.addAttribute("msg", "구매확정 처리에 실패했습니다. 다시 시도해주세요.");
	        return "common/errorPage";
	    }
	}
	
	//구매확정시
	@GetMapping("/productOrder")
	public String orderDetail(@RequestParam("orderNo") int orderNo
							, Model model
							, HttpSession session) {
	    // 주문 정보 불러오기
	    Order o = service.selectOrder(orderNo);
	    
	    // 주문 객체에서 productNo 가져오기
	    int productNo = o.getProductNo();


	    // 2. 상품 정보 및 첨부파일 조회
	    Product product = pservice.selectProductDetail(productNo);
	    ArrayList<Attachment> atList = pservice.selectProductAttachments(productNo);
	    product.setAtList(atList);
	    
	    Member loginUser = (Member) session.getAttribute("loginUser");
	    
	    model.addAttribute("order", o);
	    model.addAttribute("product", product);
	    model.addAttribute("loginUser", loginUser);
	    
	    return "product/productOrder"; 
	}
	
}
