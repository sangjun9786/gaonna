package com.gaonna.yami.search.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.gaonna.yami.common.PageInfo;
import com.gaonna.yami.common.Pagination;
import com.gaonna.yami.composite.vo.SearchForm;
import com.gaonna.yami.member.model.vo.Member;
import com.gaonna.yami.product.vo.Category;
import com.gaonna.yami.product.vo.Product;
import com.gaonna.yami.search.model.service.SearchService;
import com.google.gson.Gson;

@Controller
public class SearchController {
	@Autowired
	private SearchService service;
	
	@RequestMapping("get.ca")
	public String getCategory(HttpSession session,
							  Model model) throws UnsupportedEncodingException {
		System.out.println("응이이이이익");
		ArrayList<Category> list = service.getCategory();
		System.out.println(list);
		if(!list.isEmpty()) {
			session.setAttribute("cate", list);
			String keyword = "팝니다";
			keyword = URLEncoder.encode(keyword, "UTF-8");
			return "redirect:/filter.bo?keyword="+keyword;
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
		System.out.println("호호호호호호");
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
					            @RequestParam(value = "price1", required = false) Long price1,
					            @RequestParam(value = "price2", required = false) Long price2,
					            @RequestParam(value = "keyword", defaultValue = "") String keyword,
					            @RequestParam(value = "condition", defaultValue = "resell") String condition,
					            Model model,
					            HttpSession session) {
        int listCount = service.getFilterCount(location, category, price1, price2, keyword);
        int boardLimit = 12;
        int pageLimit = 10;
        PageInfo pi = Pagination.getPageInfo(listCount, currentPage, pageLimit, boardLimit);
        
        ArrayList<Product> list = service.productFilter(location, category, price1, price2, pi, keyword);
        
        ArrayList<Category> clist = service.getCategory();
		if(!clist.isEmpty()) {
			model.addAttribute("cate", clist);
		}
        Member m = (Member)session.getAttribute("loginUser");
        
		if(m!=null) {
			String userLoca = service.getUserLoca(m);
			
			ArrayList<String> lcList = service.getLoca(userLoca);
	        
			model.addAttribute("userLoca", userLoca);
			model.addAttribute("loca", lcList);
		}
        
        model.addAttribute("list", list);
        model.addAttribute("pi", pi);
        model.addAttribute("selectedLocation", location);
        model.addAttribute("selectedCategory", category);
        if(price1 != null && price2 != null) {
	        model.addAttribute("selectedPrice1", price1);
	        model.addAttribute("selectedPrice2", price2);
        }
        model.addAttribute("keyword", keyword);
        model.addAttribute("condition", condition);
        
        return "product/productList2";
	}
	
	@ResponseBody
	@RequestMapping(value="ajax.do", produces = "text/html;charset=UTF-8")
	public String searchBread(String keyword) {
		
		int count = service.searchBread(keyword);
		System.out.println(count);
		if(count == 1) {
			String str = service.getBread(keyword);
			System.out.println(str);
			return str;
		}else {
			return null;
		}
	}
	
	//ajax - 카테고리 목록 검색
	@ResponseBody
	@GetMapping("selectCate.co")
	public String selectCategory() {
		try {
			List<Category> category = service.selectCategory();
			String json = new Gson().toJson(category);
			return json;
		} catch (Exception e) {
			e.printStackTrace();
			return "[]";
		}
	}
	
	//ajax - 게시글 조회
	@ResponseBody
	@GetMapping("searchPerchasedBoard.co")
	public Map<String, Object> searchMyBoard(HttpSession session,Model model
			,SearchForm searchForm) {
		try {
			//loginUser의 userNo따서 searchForm에 넣기
			searchForm.setUserNo(((Member)session
					.getAttribute("loginUser")).getUserNo());
			Map<String, Object> result = service.searchMyBoard(searchForm);
			return result;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
}
