package com.gaonna.yami.product.controller;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.gaonna.yami.product.service.RecommendService;
import com.gaonna.yami.product.vo.Product;

@Controller
public class RecommendController {
	
	@Autowired
	private RecommendService service;
	
	@RequestMapping("recommend.bo")
	public String recommendProduct(Model model) {
		//좋아요 기준 추천 목록
		ArrayList<Product> list = service.recommendProduct();
		//회원 평점 기준 추천 목록
		ArrayList<Product> list2 = service.recommendMember();
		
		if(list.isEmpty()) {
			model.addAttribute("errorMsg", "추천 게시판 목록 조회 실패!");
			
			return "common/errorPage";
		}else {
			model.addAttribute("list", list);
			model.addAttribute("list2", list2);
			
			return "product/recommendPage";
		}
	}
}
