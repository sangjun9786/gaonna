package com.gaonna.yami.search.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.gaonna.yami.member.model.vo.Member;
import com.gaonna.yami.product.vo.Category;
import com.gaonna.yami.search.model.service.SearchService;

@Controller
public class SearchController {
	@Autowired
	private SearchService service;
	
	@RequestMapping("get.ca")
	public String getCategory(HttpSession session, Model model) {
		
		ArrayList<Category> list = service.getCategory();
		
		if(!list.isEmpty()) {
			session.setAttribute("cate", list);
			return "redirect:/productList2.pro";
		}else {
			System.out.println(list);
			model.addAttribute("errorMsg", "카테고리 정보 조회 실패~!");
			return "common/errorPage";
		}
		
	}
	
	@RequestMapping("get.lo")
	public String getLocation(HttpSession session) {
		Member m = (Member)session.getAttribute("loginUser");
		
		//FilterLoca
		
		return "redirect:/productList2.pro";
	}
	
}
