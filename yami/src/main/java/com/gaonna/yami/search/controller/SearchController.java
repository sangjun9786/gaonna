package com.gaonna.yami.search.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.gaonna.yami.common.PageInfo;
import com.gaonna.yami.common.Pagination;
import com.gaonna.yami.member.model.vo.Member;
import com.gaonna.yami.product.vo.Category;
import com.gaonna.yami.product.vo.Product;
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
	public String getLocation(HttpSession session, Model model) {
		Member m = (Member)session.getAttribute("loginUser");
		
		String userLoca = service.getUserLoca(m);
		
		ArrayList<String> list = service.getLoca(userLoca);
		
		if(list.isEmpty()) {
			model.addAttribute("errorMsg", "유저 위치 정보 조회 실패~!");
			return "common/errorPage";
		}else {
			session.setAttribute("userLoca", userLoca);
			session.setAttribute("loca", list);
			return "redirect:/productList2.pro";
		}
	}
	
	@RequestMapping("filter.bo")
	public String productFilter(@RequestParam(value = "currentPage", defaultValue = "1") 
	 							int currentPage,
	 							@RequestParam("location") String location,
					            @RequestParam("category") int category,
					            @RequestParam(value = "price1", required = false) Integer price1,
					            @RequestParam(value = "price2", required = false) Integer price2,
					            Model model) {
        
        int listCount = service.getFilterCount(location, category, price1, price2);
        int boardLimit = 2;
        int pageLimit = 5;
        PageInfo pi = Pagination.getPageInfo(listCount, currentPage, pageLimit, boardLimit);
        
        ArrayList<Product> list = service.productFilter(location, category, price1, price2, pi);
        
        model.addAttribute("list", list);
        model.addAttribute("pi", pi);
        model.addAttribute("selectedLocation", location);
        model.addAttribute("selectedCategory", category);
        if(price1 != null && price2 != null) {
	        model.addAttribute("selectedPrice1", price1);
	        model.addAttribute("selectedPrice2", price2);
        }
        return "product/productList2";
	}
	
}
