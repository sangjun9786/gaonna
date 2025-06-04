package com.gaonna.yami.search.model.service;

import java.util.ArrayList;
import java.util.List;

import com.gaonna.yami.member.model.vo.Member;
import com.gaonna.yami.product.vo.Category;

public interface SearchService {

	ArrayList<Category> getCategory();

	String getUserLoca(Member m);

	List<String> getLoca(String userLoca);

}
