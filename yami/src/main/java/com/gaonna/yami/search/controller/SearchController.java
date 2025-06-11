package com.gaonna.yami.search.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

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
	public String getCategory(HttpSession session,
							  Model model) {
		
		ArrayList<Category> list = service.getCategory();
		if(!list.isEmpty()) {
			session.setAttribute("cate", list);
			return "redirect:/filter.bo";
		}else {
			System.out.println(list);
			model.addAttribute("errorMsg", "카테고리 정보 조회 실패~!");
			return "common/errorPage";
		}
		
	}
	
	@RequestMapping("get.lo")
	public String getLocation(HttpSession session,
				  			  Model model) {
		Member m = (Member)session.getAttribute("loginUser");
		
		String userLoca = service.getUserLoca(m);
		
		ArrayList<String> list = service.getLoca(userLoca);
		
		if(list.isEmpty()) {
			model.addAttribute("errorMsg", "유저 위치 정보 조회 실패~!");
			return "common/errorPage";
		}else {
			session.setAttribute("userLoca", userLoca);
			session.setAttribute("loca", list);
			return "redirect:/filter.bo";
		}
	}
	
	@RequestMapping("filter.bo")
	public String productFilter(@RequestParam(value = "currentPage", defaultValue = "1") 
	 							int currentPage,
	 							@RequestParam(value = "location", defaultValue = "all") String location,
					            @RequestParam(value = "category", defaultValue = "0") int category,
					            @RequestParam(value = "price1", required = false) Integer price1,
					            @RequestParam(value = "price2", required = false) Integer price2,
					            HttpSession session,
					            Model model) {
        String keyword = (String)session.getAttribute("keyword");
        int listCount = service.getFilterCount(location, category, price1, price2, keyword);
        int boardLimit = 2;
        int pageLimit = 5;
        PageInfo pi = Pagination.getPageInfo(listCount, currentPage, pageLimit, boardLimit);
        
        ArrayList<Product> list = service.productFilter(location, category, price1, price2, pi, keyword);
        
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
	
	@PostMapping(value="saveKeyword", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public String saveKeywordToSession(@RequestParam("keyword") String keyword, HttpSession session) {
        
        // 1. 파라미터로 받은 keyword 값을 세션에 저장
        session.setAttribute("keyword", keyword);
        
        // 2. 클라이언트(AJAX의 success 함수)에 성공 메시지 응답
        return "success";
    }
	
}
