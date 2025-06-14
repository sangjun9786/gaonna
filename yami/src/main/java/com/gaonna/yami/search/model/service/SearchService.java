package com.gaonna.yami.search.model.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.gaonna.yami.common.PageInfo;
import com.gaonna.yami.composite.vo.SearchForm;
import com.gaonna.yami.member.model.vo.Member;
import com.gaonna.yami.product.vo.Category;
import com.gaonna.yami.product.vo.Product;

public interface SearchService {

	ArrayList<Category> getCategory();

	String getUserLoca(Member m);

	ArrayList<String> getLoca(String userLoca);

	int getFilterCount(String location, int category, Long price1, Long price2, String keyword);

	ArrayList<Product> productFilter(String location, int category, Long price1, Long price2, PageInfo pi, String keyword);

	int searchBread(String keyword);

	String getBread(String keyword);

	List<Category> selectCategory();
	
	Map<String, Object> searchMyBoard(SearchForm searchForm);

}
